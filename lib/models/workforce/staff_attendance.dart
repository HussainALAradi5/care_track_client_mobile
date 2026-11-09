import '../../enums/workforce/staff_attendance_status.dart';

/// Server StaffAttendanceDto: a clinician's clock-in and out of one shift.
class StaffAttendance {
  const StaffAttendance({
    required this.id,
    required this.code,
    required this.shiftId,
    required this.hospitalId,
    required this.clinicianId,
    required this.status,
    required this.isAbsent,
    required this.clockInAt,
    required this.version,
    this.clockOutAt,
  });

  final String id;
  final String code;
  final String shiftId;
  final String hospitalId;
  final String clinicianId;
  final StaffAttendanceStatus status;
  final bool isAbsent;
  final DateTime clockInAt;
  final DateTime? clockOutAt;
  final int version;

  factory StaffAttendance.fromJson(Map<String, dynamic> json) => StaffAttendance(
    id: json['id'] as String,
    code: json['code'] as String,
    shiftId: json['shiftId'] as String,
    hospitalId: json['hospitalId'] as String,
    clinicianId: json['clinicianId'] as String,
    status: StaffAttendanceStatus.fromWire(json['status'] as String),
    isAbsent: json['isAbsent'] as bool,
    clockInAt: DateTime.parse(json['clockInAt'] as String),
    clockOutAt: json['clockOutAt'] == null ? null : DateTime.parse(json['clockOutAt'] as String),
    version: (json['version'] as num).toInt(),
  );
}
