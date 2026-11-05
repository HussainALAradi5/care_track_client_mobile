import '../../enums/identity/user_type.dart';

/// GET /api/hospitals/{hospitalId}/clinicians item: a doctor or nurse who can be given shifts.
class ShiftClinician {
  const ShiftClinician({required this.id, required this.code, required this.name, required this.userType});

  final String id;
  final String code;
  final String name;
  final UserType userType;

  factory ShiftClinician.fromJson(Map<String, dynamic> json) => ShiftClinician(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    userType: UserType.fromWire(json['userType'] as String),
  );
}
