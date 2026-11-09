import 'package:care_track_client_mobile/screens/staff/attendance_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/workforce/attendance_models_test.dart' show attendanceJson, todayJson;
import '../support/api_harness.dart';

Object? server(RequestOptions r, {Object? today, Object? day}) => switch (r.path) {
  '/hospitals/h1/attendance/me/today' => today ?? todayJson(canIn: true),
  '/hospitals/h1/attendance/me' => [attendanceJson(out: '2026-11-08T13:00:00Z')],
  '/hospitals/h1/attendance/day' => day ?? const Failure(403, 'FORBIDDEN'),
  '/hospitals/h1/attendance/me/clock-in' => todayJson(canOut: true, today: attendanceJson()),
  '/hospitals/h1/attendance/me/clock-out' => todayJson(today: attendanceJson(out: '2026-11-09T13:00:00Z')),
  _ => null,
};

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('clocks in, then offers clock out, with two weeks of history', (tester) async {
    final s = await pumpScreen(tester, const AttendanceScreen(), server);
    expect(find.text('Last two weeks'), findsOneWidget);
    expect(find.text('My team today'), findsNothing, reason: 'the server refuses non-managers, quietly');
    await tester.tap(find.widgetWithText(FilledButton, 'Clock in'));
    await tester.pumpAndSettle();
    expect(find.text('Clocked in. Have a good day.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Clock out'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Clock out'));
    await tester.pumpAndSettle();
    expect(s.lastTo('/hospitals/h1/attendance/me/clock-out').data, {'expectedVersion': 3});
  });

  testWidgets('a manager sees their people today', (tester) async {
    await pumpScreen(tester, const AttendanceScreen(), (r) => server(r, day: {
      'date': '2026-11-09',
      'workingDay': true,
      'schedule': null,
      'counts': {'LATE': 1},
      'rows': [
        {
          'userId': 'u9',
          'userName': 'Mona Nurse',
          'departmentName': null,
          'positionName': null,
          'status': 'LATE',
          'source': 'DAILY',
          'expectedAt': null,
          'clockInAt': '2026-11-09T05:30:00Z',
          'clockOutAt': null,
          'minutesLate': 30,
          'workedMinutes': null,
          'leaveTypeName': null,
        },
      ],
    }));
    expect(find.text('My team today'), findsOneWidget);
    expect(find.text('Mona Nurse'), findsOneWidget);
    expect(find.text('Late'), findsOneWidget);
  });

  testWidgets('someone not working here is told so, without an error', (tester) async {
    await pumpScreen(tester, const AttendanceScreen(), (r) => r.path.endsWith('/today')
        ? const Failure(422, 'ATTENDANCE_NOT_ASSIGNED')
        : server(r));
    expect(find.text('You do not work at this hospital, so there is nothing to clock in to here.'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('a refused clock-in shows the reason', (tester) async {
    await pumpScreen(tester, const AttendanceScreen(), (r) => r.path.endsWith('/clock-in')
        ? const Failure(409, 'ATTENDANCE_ALREADY_IN')
        : server(r));
    await tester.tap(find.widgetWithText(FilledButton, 'Clock in'));
    await tester.pumpAndSettle();
    expect(find.text('You already clocked in today.'), findsOneWidget);
  });
}
