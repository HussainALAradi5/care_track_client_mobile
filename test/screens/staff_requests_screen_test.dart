import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/models/workforce/staff_request.dart';
import 'package:care_track_client_mobile/screens/staff/staff_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/api_harness.dart';

Map<String, dynamic> hrRequest({bool canDecide = true, String status = 'REQUESTED'}) => {
  'id': 'r1',
  'code': 'SR-1',
  'userId': 'u1',
  'userName': 'Sam Employee',
  'type': 'SALARY_CERTIFICATE',
  'details': 'For the bank',
  'status': status,
  'requestedAt': '2026-11-05T09:00:00Z',
  'decidedByName': null,
  'decidedAt': null,
  'decisionNote': null,
  'version': 7,
  'canDecide': canDecide,
  'canCancel': false,
};

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  const hr = {PermissionCodes.staffRequestHandle};
  Object? respond(dynamic r) => (r.method as String) == 'POST' ? hrRequest(canDecide: false) : pageOf([hrRequest()]);

  test('parses the HR fields of StaffRequestDto', () {
    final r = StaffRequest.fromJson(hrRequest());
    expect(r.userName, 'Sam Employee');
    expect(r.canDecide, isTrue);
    expect(r.version, 7);
  });

  testWidgets('is locked without STAFF_REQUEST:HANDLE and calls nothing', (tester) async {
    final server = await pumpScreen(tester, const StaffRequestsScreen(), respond);
    expect(find.text('This screen is not open to you here.'), findsOneWidget);
    expect(server.requests, isEmpty);
  });

  testWidgets('lists waiting requests first and filters by status', (tester) async {
    final server = await pumpScreen(tester, const StaffRequestsScreen(), respond, permissions: hr);
    expect(server.requests.first.path, '/organizations/o1/staff-requests');
    expect(server.requests.first.queryParameters['status'], 'REQUESTED');
    expect(find.text('Sam Employee'), findsOneWidget);
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters.containsKey('status'), isFalse);
  });

  testWidgets('approves with the version it saw', (tester) async {
    final server = await pumpScreen(tester, const StaffRequestsScreen(), respond, permissions: hr);
    await tester.tap(find.widgetWithText(FilledButton, 'Approve'));
    await tester.pumpAndSettle();
    expect(server.lastTo('/organizations/o1/staff-requests/r1/decision').data, {
      'approve': true,
      'note': null,
      'expectedVersion': 7,
    });
    expect(find.text("Sam Employee's request approved."), findsOneWidget);
  });

  testWidgets('rejecting needs a note; a refused decision shows why', (tester) async {
    await pumpScreen(
      tester,
      const StaffRequestsScreen(),
      (r) => r.method == 'POST' ? const Failure(409, 'STAFF_REQUEST_STATE_INVALID') : pageOf([hrRequest()]),
      permissions: hr,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Reject'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextField).last, 'Not possible');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Reject').last);
    await tester.pumpAndSettle();
    expect(find.text('This staff request can no longer be changed.'), findsOneWidget);
  });
}
