import '../../enums/workforce/day_attendance_status.dart';

/// Server DayAttendanceRowDto: one person's day at the Hospital.
class DayAttendanceRow {
  const DayAttendanceRow({
    required this.userId,
    required this.userName,
    required this.status,
    required this.minutesLate,
    this.departmentName,
    this.positionName,
    this.expectedAt,
    this.clockInAt,
    this.clockOutAt,
    this.workedMinutes,
    this.leaveTypeName,
  });

  final String userId;
  final String userName;
  final String? departmentName;
  final String? positionName;
  final DayAttendanceStatus status;
  final DateTime? expectedAt;
  final DateTime? clockInAt;
  final DateTime? clockOutAt;
  final int minutesLate;
  final int? workedMinutes;
  final String? leaveTypeName;

  static DateTime? _time(Object? value) => value == null ? null : DateTime.parse(value as String);

  factory DayAttendanceRow.fromJson(Map<String, dynamic> json) => DayAttendanceRow(
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    departmentName: json['departmentName'] as String?,
    positionName: json['positionName'] as String?,
    status: DayAttendanceStatus.fromWire(json['status'] as String),
    expectedAt: _time(json['expectedAt']),
    clockInAt: _time(json['clockInAt']),
    clockOutAt: _time(json['clockOutAt']),
    minutesLate: (json['minutesLate'] as num).toInt(),
    workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
    leaveTypeName: json['leaveTypeName'] as String?,
  );
}
