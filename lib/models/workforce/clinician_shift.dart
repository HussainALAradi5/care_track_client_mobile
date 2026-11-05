/// Server ClinicianShiftDto: one clinician's working hours at a hospital.
class ClinicianShift {
  const ClinicianShift({
    required this.id,
    required this.code,
    required this.hospitalId,
    required this.clinicianId,
    required this.clinicianName,
    required this.startsAt,
    required this.endsAt,
  });

  final String id;
  final String code;
  final String hospitalId;
  final String clinicianId;
  final String clinicianName;
  final DateTime startsAt;
  final DateTime endsAt;

  /// Started shifts stay on record and can no longer be removed.
  bool startedAt(DateTime now) => !startsAt.isAfter(now);

  factory ClinicianShift.fromJson(Map<String, dynamic> json) => ClinicianShift(
    id: json['id'] as String,
    code: json['code'] as String,
    hospitalId: json['hospitalId'] as String,
    clinicianId: json['clinicianId'] as String,
    clinicianName: json['clinicianName'] as String,
    startsAt: DateTime.parse(json['startsAt'] as String).toLocal(),
    endsAt: DateTime.parse(json['endsAt'] as String).toLocal(),
  );
}
