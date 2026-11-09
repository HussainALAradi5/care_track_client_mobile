import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/controllers/ui/picker_style_controller.dart';
import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/screens/staff/leave_requests_screen.dart';
import 'package:care_track_client_mobile/screens/staff/leave_screen.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/smooth_calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/workforce/leave_models_test.dart' show leaveRequestJson;
import '../support/api_harness.dart';

Map<String, dynamic> myLeave({List<Map<String, dynamic>> requests = const [], int left = 10}) => {
  'year': DateTime.now().year,
  'employed': true,
  'balances': [
    {'leaveTypeId': 't1', 'name': 'Sick leave', 'paid': true, 'allowed': 14, 'taken': 2, 'waiting': 2, 'left': left},
  ],
  'requests': requests,
};

Object? leaveServer(RequestOptions r, {List<Map<String, dynamic>> queue = const []}) {
  if (r.path == '/organizations/o1/leave/mine') return myLeave();
  if (r.path == '/organizations/o1/leave/requests' && r.method == 'GET') return pageOf(queue);
  return leaveRequestJson();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('shows balances and cannot ask until a type and days are chosen', (tester) async {
    await pumpScreen(tester, const LeaveScreen(), leaveServer);
    expect(find.text('Sick leave'), findsOneWidget);
    expect(find.textContaining('10 left'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Ask for leave')).onPressed, isNull);
  });

  testWidgets('every date field opens through AppPickers', (tester) async {
    await pumpScreen(
      tester,
      const LeaveScreen(),
      leaveServer,
      overrides: [chosenPickerStyleProvider.overrideWithValue(PickerStyle.smooth)],
    );
    for (final field in ['First day', 'Last day']) {
      await tester.tap(find.text(field), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(SmoothCalendar), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Use for my leave attaches the note, fills its days and sends it', (tester) async {
    final server = await pumpScreen(tester, const LeaveScreen(sickNoteId: 'n1'), (r) {
      if (r.path == '/patients/me/documents/n1') {
        final today = DateTime.now();
        final day = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        return {
          'id': 'n1',
          'code': 'SN-1',
          'title': 'Sick note',
          'kind': 'SICK_LEAVE',
          'appointmentId': 'a1',
          'hospitalId': 'h1',
          'hospitalName': 'Dev Hospital',
          'authorId': 'd1',
          'authorName': 'Dr Sara',
          'issuedAt': '2026-11-01T09:00:00Z',
          'body': null,
          'restFrom': day,
          'restTo': day,
        };
      }
      return leaveServer(r);
    });
    await tester.pumpAndSettle();
    expect(find.text('Sick note from Dev Hospital, by Dr Sara'), findsOneWidget);
    expect(find.text('1 day'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Ask for leave'));
    await tester.pumpAndSettle();
    final ask = server.requests.lastWhere((r) => r.method == 'POST');
    expect((ask.data as Map)['sickNoteId'], 'n1');
    expect((ask.data as Map)['leaveTypeId'], 't1');
    expect(find.text('Your request was sent to your manager.'), findsOneWidget);
  });

  testWidgets('a server refusal while asking shows its message', (tester) async {
    await pumpScreen(tester, const LeaveScreen(sickNoteId: 'n1'), (r) {
      if (r.path == '/patients/me/documents/n1') return const Failure(404, 'SICK_NOTE_NOT_FOUND');
      return leaveServer(r);
    });
    await tester.pumpAndSettle();
    expect(find.text('This sick note was not found among your documents.'), findsOneWidget);
  });

  testWidgets('a manager rejects with a note and the lists reload', (tester) async {
    final server = await pumpScreen(tester, const LeaveScreen(), (r) => leaveServer(r, queue: [leaveRequestJson()]));
    expect(find.text('To decide'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Reject'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextField).last, 'Short staffed');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Reject').last);
    await tester.pumpAndSettle();
    final decision = server.lastTo('/organizations/o1/leave/requests/l1/decision');
    expect(decision.data, {'approve': false, 'note': 'Short staffed', 'expectedVersion': 4});
  });

  testWidgets('Leave requests is locked without LEAVE:READ_ALL and calls nothing', (tester) async {
    final server = await pumpScreen(tester, const LeaveRequestsScreen(), leaveServer);
    expect(find.text('This screen is not open to you here.'), findsOneWidget);
    expect(server.requests, isEmpty);
  });

  testWidgets('Leave requests filters by status and approves', (tester) async {
    final server = await pumpScreen(
      tester,
      const LeaveRequestsScreen(),
      (r) => leaveServer(r, queue: [leaveRequestJson()]),
      permissions: {PermissionCodes.leaveReadAll},
    );
    expect(server.requests.first.queryParameters['status'], 'REQUESTED');
    await tester.tap(find.text('Approved'));
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters['status'], 'APPROVED');
    await tester.tap(find.widgetWithText(FilledButton, 'Approve'));
    await tester.pumpAndSettle();
    expect(server.lastTo('/organizations/o1/leave/requests/l1/decision').data, {
      'approve': true,
      'note': null,
      'expectedVersion': 4,
    });
  });
}
