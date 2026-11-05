import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/identity/staff_context_controller.dart';
import 'package:care_track_client_mobile/controllers/ui/clock_controller.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/models/identity/staff_context.dart';
import 'package:care_track_client_mobile/models/identity/staff_hospital.dart';
import 'package:care_track_client_mobile/screens/staff/desk_screen.dart';
import 'package:care_track_client_mobile/screens/staff/queue_screen.dart';
import 'package:care_track_client_mobile/screens/staff/shifts_screen.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Answers API calls from [respond] (null → 204 No Content) and records every request.
class FakeServer implements HttpClientAdapter {
  FakeServer(this.respond);

  final Object? Function(RequestOptions request) respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = respond(options);
    if (body == null) return ResponseBody.fromString('', 204);
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeTokens implements TokenSource {
  @override
  Future<String?> validAccessToken() async => 'token';

  @override
  Future<void> handleUnauthorized() async {}
}

class FixedStaff extends StaffContextController {
  FixedStaff(this.context);

  final StaffContext context;

  @override
  Future<StaffContext> build() async => context;
}

final now = DateTime.utc(2026, 11, 5, 9);

StaffContext staffWith(List<String> permissions) => StaffContext(
  hospitals: [
    StaffHospital(
      hospitalId: 'h1',
      organizationId: 'o1',
      code: 'H1',
      name: 'Dev Hospital',
      administrator: false,
      permissions: permissions.toSet(),
    ),
  ],
  selectedId: 'h1',
);

Map<String, dynamic> page(List<Map<String, dynamic>> items) => {
  'items': items,
  'page': 0,
  'pageSize': 20,
  'totalItems': items.length,
  'totalPages': 1,
  'hasNext': false,
  'correlationId': 'c',
};

Map<String, dynamic> booking() => {
  'id': 'b1',
  'code': 'BK-1',
  'hospitalId': 'h1',
  'patientId': 'p1',
  'clinicianId': 'c1',
  'patientName': 'Development Patient',
  'clinicianName': 'Development Doctor',
  'startsAt': '2026-11-05T11:00:00Z',
  'endsAt': '2026-11-05T11:30:00Z',
  'status': 'REQUESTED',
  'version': 3,
};

Map<String, dynamic> appointment({required String startsAt, required String endsAt}) => {
  'id': 'a1',
  'code': 'APT-1',
  'bookingId': 'b1',
  'hospitalId': 'h1',
  'patientId': 'p1',
  'clinicianId': 'c1',
  'patientName': 'Development Patient',
  'clinicianName': 'Development Doctor',
  'startsAt': startsAt,
  'endsAt': endsAt,
  'cancellationDeadlineAt': '2026-11-04T09:00:00Z',
  'createdAt': '2026-11-01T09:00:00Z',
  'status': 'SCHEDULED',
  'version': 1,
};

Future<FakeServer> pumpScreen(
  WidgetTester tester,
  Widget screen,
  List<String> permissions,
  Object? Function(RequestOptions request) respond,
) async {
  final server = FakeServer(respond);
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
        staffContextProvider.overrideWith(() => FixedStaff(staffWith(permissions))),
        nowProvider.overrideWithValue(now),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return server;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('queue lists waiting requests and confirms with a retry-safe key', (tester) async {
    final server = await pumpScreen(tester, const QueueScreen(), [
      PermissionCodes.bookingReadAll,
      PermissionCodes.bookingConfirm,
    ], (r) => r.path.endsWith('/confirm') ? {'id': 'a1'} : page([booking()]));

    final list = server.requests.first;
    expect(list.path, '/hospitals/h1/bookings');
    expect(list.queryParameters, containsPair('status', 'REQUESTED'));
    expect(list.queryParameters, containsPair('sortDirection', 'asc'));
    expect(find.text('Development Patient'), findsOneWidget);
    expect(find.textContaining('with Development Doctor'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    final confirm = server.requests.firstWhere((r) => r.path.endsWith('/confirm'));
    expect(confirm.method, 'POST');
    expect(confirm.queryParameters, {'expectedVersion': 3});
    expect(confirm.headers[PermissionCodes.idempotencyHeader], 'confirm-b1-v3');
    expect(server.requests.last.path, '/hospitals/h1/bookings', reason: 'the queue reloads after a decision');
  });

  testWidgets('without BOOKING:CONFIRM the queue is read-only', (tester) async {
    await pumpScreen(tester, const QueueScreen(), [PermissionCodes.bookingReadAll], (_) => page([booking()]));
    expect(find.text('Development Patient'), findsOneWidget);
    expect(find.text('Confirm'), findsNothing);
  });

  testWidgets('desk offers check-in inside the window and sends the identity check', (tester) async {
    // Starts 10 minutes after "now": check-in is open, "did not arrive" is not.
    final server = await pumpScreen(
      tester,
      const DeskScreen(),
      [PermissionCodes.appointmentReadAll, PermissionCodes.appointmentCheckIn, PermissionCodes.appointmentNoShow],
      (r) => r.path.endsWith('/check-in')
          ? appointment(startsAt: '2026-11-05T09:10:00Z', endsAt: '2026-11-05T09:40:00Z')
          : page([appointment(startsAt: '2026-11-05T09:10:00Z', endsAt: '2026-11-05T09:40:00Z')]),
    );
    expect(server.requests.first.queryParameters, containsPair('status', 'SCHEDULED'));
    expect(find.text('Did not arrive'), findsNothing);

    // The button keeps spinning while the sheet is open, so step time instead of settling.
    await tester.tap(find.text('Check in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('ID card'));
    await tester.pumpAndSettle();
    final checkIn = server.requests.firstWhere((r) => r.path.endsWith('/check-in'));
    expect(checkIn.data, {'expectedVersion': 1, 'verificationMethod': 'ID_CARD'});
  });

  testWidgets('desk offers "did not arrive" only after the end plus 30 minutes', (tester) async {
    await pumpScreen(tester, const DeskScreen(), [
      PermissionCodes.appointmentReadAll,
      PermissionCodes.appointmentCheckIn,
      PermissionCodes.appointmentNoShow,
    ], (_) => page([appointment(startsAt: '2026-11-05T08:00:00Z', endsAt: '2026-11-05T08:30:00Z')]));
    expect(find.text('Did not arrive'), findsOneWidget);
    expect(find.text('Check in'), findsNothing);
  });

  testWidgets('shifts list who works next and add a shift for the picked person', (tester) async {
    final server = await pumpScreen(tester, const ShiftsScreen(), [PermissionCodes.shiftWrite], (r) {
      if (r.path.endsWith('/clinicians')) {
        return page([
          {'id': 'c1', 'code': 'U1', 'name': 'Development Doctor', 'userType': 'DOCTOR'},
        ]);
      }
      final shift = {
        'id': 's1',
        'code': 'CS-1',
        'hospitalId': 'h1',
        'clinicianId': 'c1',
        'clinicianName': 'Development Doctor',
        'startsAt': '2026-11-05T13:00:00Z',
        'endsAt': '2026-11-05T21:00:00Z',
      };
      return r.method == 'POST' ? shift : page([shift]);
    });
    expect(find.textContaining('Starts in 4 h'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);

    await tester.tap(find.text('Doctor or nurse'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Development Doctor').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add shift'));
    await tester.pumpAndSettle();
    final create = server.requests.firstWhere((r) => r.method == 'POST');
    expect(create.path, '/hospitals/h1/clinician-shifts');
    expect((create.data as Map)['clinicianId'], 'c1');
  });

  testWidgets('a screen the hospital does not grant shows the locked state', (tester) async {
    final server = await pumpScreen(tester, const ShiftsScreen(), [PermissionCodes.bookingReadAll], (_) => page([]));
    expect(find.text('This screen is not open to you here.'), findsOneWidget);
    expect(server.requests.where((r) => r.path.endsWith('/clinician-shifts')), isEmpty);
  });
}
