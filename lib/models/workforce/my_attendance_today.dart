import '../../enums/workforce/staff_attendance_status.dart';
import 'staff_attendance.dart';
import 'work_attendance.dart';
import 'work_schedule.dart';

/// Server MyAttendanceTodayDto: the caller's day at a Hospital and whether they may clock in or out now.
class MyAttendanceToday {
  const MyAttendanceToday({
    required this.workingDay,
    required this.canClockIn,
    required this.canClockOut,
    this.schedule,
    this.shiftStartsAt,
    this.leaveTypeName,
    this.today,
    this.shiftId,
    this.shiftAttendance,
  });

  final bool workingDay;
  final WorkSchedule? schedule;
  final DateTime? shiftStartsAt;
  final String? leaveTypeName;
  final WorkAttendance? today;
  final bool canClockIn;
  final bool canClockOut;
  final String? shiftId;

  /// Null until they clock in to today's shift.
  final StaffAttendance? shiftAttendance;

  bool get canClockInToShift => shiftId != null && shiftAttendance == null;
  bool get canClockOutOfShift => shiftId != null && shiftAttendance?.status == StaffAttendanceStatus.checkedIn;

  factory MyAttendanceToday.fromJson(Map<String, dynamic> json) => MyAttendanceToday(
    workingDay: json['workingDay'] as bool,
    schedule: json['schedule'] == null ? null : WorkSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
    shiftStartsAt: json['shiftStartsAt'] == null ? null : DateTime.parse(json['shiftStartsAt'] as String),
    leaveTypeName: json['leaveTypeName'] as String?,
    today: json['today'] == null ? null : WorkAttendance.fromJson(json['today'] as Map<String, dynamic>),
    canClockIn: json['canClockIn'] as bool,
    canClockOut: json['canClockOut'] as bool,
    shiftId: json['shiftId'] as String?,
    shiftAttendance: json['shiftAttendance'] == null
        ? null
        : StaffAttendance.fromJson(json['shiftAttendance'] as Map<String, dynamic>),
  );
}
