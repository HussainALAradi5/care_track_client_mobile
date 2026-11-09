import 'package:care_track_client_mobile/enums/workforce/day_attendance_status.dart';
import 'package:care_track_client_mobile/models/workforce/day_attendance_row.dart';
import 'package:care_track_client_mobile/models/workforce/my_attendance_today.dart';
import 'package:care_track_client_mobile/models/workforce/work_attendance.dart';
import 'package:care_track_client_mobile/models/workforce/work_schedule.dart';
import 'package:care_track_client_mobile/utilities/workforce/attendance.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> attendanceJson({String? out}) => {
  'id': 'a1',
  'workDate': '2026-11-09',
  'clockInAt': '2026-11-09T05:00:00Z',
  'clockOutAt': out,
  'workedMinutes': out == null ? null : 480,
  'minutesLate': 5,
  'version': 3,
};

Map<String, dynamic> todayJson({bool canIn = false, bool canOut = false, Map<String, dynamic>? today}) => {
  'date': '2026-11-09',
  'workingDay': true,
  'schedule': {
    'hospitalId': 'h1',
    'workingDays': ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY'],
    'startTime': '08:00:00',
    'endTime': '16:00:00',
    'graceMinutes': 15,
    'version': 1,
  },
  'shiftStartsAt': null,
  'leaveTypeName': null,
  'today': today,
  'canClockIn': canIn,
  'canClockOut': canOut,
};

void main() {
  test('parses MyAttendanceTodayDto', () {
    final day = MyAttendanceToday.fromJson(todayJson(canOut: true, today: attendanceJson()));
    expect(day.today!.version, 3);
    expect(day.today!.clockOutAt, isNull);
    expect(day.canClockOut, isTrue);
    expect(day.schedule!.endTime, '16:00:00');
  });

  test('parses WorkAttendanceDto once out', () {
    final day = WorkAttendance.fromJson(attendanceJson(out: '2026-11-09T13:00:00Z'));
    expect(day.workedMinutes, 480);
    expect(day.clockOutAt, DateTime.utc(2026, 11, 9, 13));
  });

  test('parses DayAttendanceRowDto', () {
    final row = DayAttendanceRow.fromJson({
      'userId': 'u1',
      'userName': 'Sam',
      'departmentName': 'ICU',
      'positionName': 'Nurse',
      'status': 'ON_LEAVE',
      'source': 'DAILY',
      'expectedAt': null,
      'clockInAt': null,
      'clockOutAt': null,
      'minutesLate': 0,
      'workedMinutes': null,
      'leaveTypeName': 'Annual',
    });
    expect(row.status, DayAttendanceStatus.onLeave);
    expect(row.leaveTypeName, 'Annual');
  });

  test('labels minutes and working days', () {
    expect(minutesLabel(65), '1 h 05 min');
    expect(minutesLabel(45), '45 min');
    expect(shortTime('08:00:00'), '08:00');
    expect(daysLabel(WorkSchedule.fromJson(todayJson()['schedule'] as Map<String, dynamic>).workingDays), 'Sun–Thu');
    expect(daysLabel(['SUNDAY', 'TUESDAY']), 'Sun, Tue');
  });
}
