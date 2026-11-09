/// Server ChatHospitalDto: a Hospital where the caller may chat and whether as staff, patient or both.
class ChatHospital {
  const ChatHospital({required this.hospitalId, required this.name, required this.staff, required this.patient});

  final String hospitalId;
  final String name;
  final bool staff;
  final bool patient;

  factory ChatHospital.fromJson(Map<String, dynamic> json) => ChatHospital(
    hospitalId: json['hospitalId'] as String,
    name: json['name'] as String,
    staff: json['staff'] as bool,
    patient: json['patient'] as bool,
  );
}
