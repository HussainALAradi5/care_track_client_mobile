import 'package:care_track_client_mobile/screens/staff/attendance_screen.dart';
import 'package:care_track_client_mobile/utilities/time/dates.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/workforce/attendance_models_test.dart' show shiftAttendanceJson, todayJson;
import '../support/api_harness.dart';

const today = '/hospitals/h1/attendance/me/today';
const clockIn = '/hospitals/h1/clinician-shifts/s1/clock-in';
const clockOut = '/hospitals/h1/clinician-shifts/s1/clock-out';
const shiftStart = '2026-11-09T05:00:00Z';
const clockedInAt = '2026-11-09T05:02:00Z';
const shiftEnd = '2026-11-09T13:00:00Z';

String local(String instant) => timeOfDayLabel(DateTime.parse(instant).toLocal());

/// The server's memory of one shift's attendance; a [Failure] in [refuse] answers that path instead.
class ShiftDesk {
  ShiftDesk({this.record, this.refuse = const {}});

  Map<String, dynamic>? record;
  final Map<String, Failure> refuse;

  Object? answer(RequestOptions r) {
    final refused = refuse[r.path];
    if (refused != null) return refused;
    return switch (r.path) {
      today => todayJson(shiftId: 's1', shiftStartsAt: shiftStart, shiftAttendance: record),
      '/hospitals/h1/attendance/me' => const [],
      '/hospitals/h1/attendance/day' => const Failure(403, 'FORBIDDEN'),
      clockIn => record = shiftAttendanceJson(),
      clockOut => record = shiftAttendanceJson(status: 'CHECKED_OUT', out: shiftEnd),
      _ => null,
    };
  }
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Finder button(String label) => find.widgetWithText(FilledButton, label);

  testWidgets('a shift today offers clock in, states the time, and no longer points elsewhere', (tester) async {
    await pumpScreen(tester, const AttendanceScreen(), ShiftDesk().answer);
    expect(find.text('You have a shift today at ${local(shiftStart)}.'), findsOneWidget);
    expect(find.textContaining('My visits'), findsNothing);
    expect(button('Clock in'), findsOneWidget);
    expect(button('Clock out'), findsNothing);
  });

  testWidgets('clocks in to the shift, then out, re-reading the day each time', (tester) async {
    final s = await pumpScreen(tester, const AttendanceScreen(), ShiftDesk().answer);
    int reads() => s.requests.where((r) => r.path == today).length;
    final before = reads();

    await tester.tap(button('Clock in'));
    await tester.pumpAndSettle();
    expect(find.text('Clocked in. Have a good day.'), findsOneWidget);
    expect(find.text('In at ${local(clockedInAt)}'), findsOneWidget);
    expect(button('Clock in'), findsNothing);
    expect(button('Clock out'), findsOneWidget);
    expect(reads(), before + 1);

    await tester.tap(button('Clock out'));
    await tester.pumpAndSettle();
    expect(s.lastTo(clockOut).data, {'expectedVersion': 4});
    expect(find.text('In at ${local(clockedInAt)} · Out at ${local(shiftEnd)}'), findsOneWidget);
    expect(button('Clock in'), findsNothing);
    expect(button('Clock out'), findsNothing);
    expect(reads(), before + 2);
  });

  testWidgets('a second tap while the first is running sends nothing more', (tester) async {
    final s = await pumpScreen(tester, const AttendanceScreen(), ShiftDesk().answer);
    await tester.tap(button('Clock in'));
    await tester.tap(button('Clock in'));
    await tester.pumpAndSettle();
    expect(s.requests.where((r) => r.path == clockIn), hasLength(1));
  });

  testWidgets('a clock-in outside the window shows why and keeps the button', (tester) async {
    final desk = ShiftDesk(refuse: {clockIn: const Failure(409, 'CLOCK_IN_WINDOW_CLOSED')});
    await pumpScreen(tester, const AttendanceScreen(), desk.answer);
    await tester.tap(button('Clock in'));
    await tester.pumpAndSettle();
    expect(find.text('Clock-in opens 30 minutes before the shift and closes when it ends.'), findsOneWidget);
    expect(button('Clock in'), findsOneWidget);
  });

  testWidgets('clocking out while still in a room says to leave it first', (tester) async {
    final desk = ShiftDesk(
      record: shiftAttendanceJson(),
      refuse: {clockOut: const Failure(409, 'ROOM_CHECK_OUT_REQUIRED')},
    );
    await pumpScreen(tester, const AttendanceScreen(), desk.answer);
    await tester.tap(button('Clock out'));
    await tester.pumpAndSettle();
    expect(find.text('Check out of your room first, then clock out.'), findsOneWidget);
    expect(button('Clock out'), findsOneWidget);
  });
}
