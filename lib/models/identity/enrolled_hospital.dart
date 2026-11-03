/// GET /api/patients/me/hospitals item (EnrolledHospitalDto).
class EnrolledHospital {
  const EnrolledHospital({required this.id, required this.code, required this.name, required this.timeZone, this.city});

  final String id;
  final String code;
  final String name;
  final String? city;
  final String timeZone;

  factory EnrolledHospital.fromJson(Map<String, dynamic> json) => EnrolledHospital(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    city: json['city'] as String?,
    timeZone: json['timeZone'] as String,
  );
}
