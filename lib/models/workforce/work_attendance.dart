/// Server WorkAttendanceDto: one of the caller's working days.
class WorkAttendance {
  const WorkAttendance({
    required this.id,
    required this.workDate,
    required this.clockInAt,
    required this.minutesLate,
    required this.version,
    this.clockOutAt,
    this.workedMinutes,
  });

  final String id;
  final DateTime workDate;
  final DateTime clockInAt;
  final DateTime? clockOutAt;
  final int? workedMinutes;
  final int minutesLate;
  final int version;

  factory WorkAttendance.fromJson(Map<String, dynamic> json) => WorkAttendance(
    id: json['id'] as String,
    workDate: DateTime.parse(json['workDate'] as String),
    clockInAt: DateTime.parse(json['clockInAt'] as String),
    clockOutAt: json['clockOutAt'] == null ? null : DateTime.parse(json['clockOutAt'] as String),
    workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
    minutesLate: (json['minutesLate'] as num).toInt(),
    version: (json['version'] as num).toInt(),
  );
}
