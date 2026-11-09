import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/identity/staff_context_controller.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/models/identity/staff_context.dart';
import 'package:care_track_client_mobile/models/identity/staff_hospital.dart';
import 'package:care_track_client_mobile/screens/staff/my_requests_screen.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return ResponseBody.fromString(
      jsonEncode(respond(options)),
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
  @override
  Future<StaffContext> build() async => const StaffContext(
    hospitals: [
      StaffHospital(
        hospitalId: 'h1',
        organizationId: 'o1',
        code: 'H1',
        name: 'Dev Hospital',
        administrator: false,
        permissions: {},
      ),
    ],
    selectedId: 'h1',
  );
}

Map<String, dynamic> request({String status = 'REQUESTED', bool canCancel = true, int version = 2}) => {
  'id': 'r1',
  'code': 'SR-1',
  'type': 'EMPLOYMENT_LETTER',
  'details': 'For the embassy',
  'status': status,
  'requestedAt': '2026-11-05T09:00:00Z',
  'decidedByName': null,
  'decisionNote': null,
  'version': version,
  'canCancel': canCancel,
};

Map<String, dynamic> page(List<Map<String, dynamic>> items) => {
  'items': items,
  'page': 0,
  'pageSize': 20,
  'totalItems': items.length,
  'totalPages': 1,
  'hasNext': false,
  'correlationId': 'c',
};

Future<FakeServer> pumpMyRequests(WidgetTester tester, Object? Function(RequestOptions request) respond) async {
  final server = FakeServer(respond);
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
        staffContextProvider.overrideWith(FixedStaff.new),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: MyRequestsScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return server;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('lists own requests without any permission, in the Organization', (tester) async {
    final server = await pumpMyRequests(tester, (_) => page([request()]));
    expect(server.requests.first.path, '/organizations/o1/staff-requests/mine');
    expect(find.text('Employment letter'), findsOneWidget);
    expect(find.text('For the embassy'), findsOneWidget);
    expect(find.text('Waiting'), findsOneWidget);
    expect(find.text('Cancel request'), findsOneWidget);
  });

  testWidgets('cancels a waiting request with the version it saw', (tester) async {
    final server = await pumpMyRequests(
      tester,
      (r) => r.path.endsWith('/cancel') ? request(status: 'CANCELLED', canCancel: false) : page([request()]),
    );

    await tester.scrollUntilVisible(find.text('Cancel request'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Cancel request'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel request').last);
    await tester.pumpAndSettle();

    final cancel = server.requests.firstWhere((r) => r.path.endsWith('/cancel'));
    expect(cancel.path, '/organizations/o1/staff-requests/r1/cancel');
    expect(cancel.data, {'expectedVersion': 2});
    expect(server.requests.last.path, '/organizations/o1/staff-requests/mine', reason: 'the list reloads');
  });

  testWidgets('sends a new request once a type and details are given', (tester) async {
    final server = await pumpMyRequests(
      tester,
      (r) => r.method == 'POST' ? request() : page([]),
    );

    expect(find.text('No requests yet.'), findsOneWidget);
    final send = find.widgetWithText(FilledButton, 'Send to HR');
    expect(tester.widget<FilledButton>(send).onPressed, isNull);

    await tester.tap(find.text('What do you need?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salary certificate').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  For the bank  ');
    await tester.pumpAndSettle();
    await tester.tap(send);
    await tester.pumpAndSettle();

    final create = server.requests.firstWhere((r) => r.method == 'POST');
    expect(create.path, '/organizations/o1/staff-requests');
    expect(create.data, {'type': 'SALARY_CERTIFICATE', 'details': 'For the bank'});
    expect(find.text('Your request was sent to HR.'), findsOneWidget);
  });
}
