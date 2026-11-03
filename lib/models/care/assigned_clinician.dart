import '../../enums/identity/user_type.dart';

/// GET /api/hospitals/{hospitalId}/patients/me/care-team item.
class AssignedClinician {
  const AssignedClinician({required this.id, required this.code, required this.name, required this.userType});

  final String id;
  final String code;
  final String name;
  final UserType userType;

  factory AssignedClinician.fromJson(Map<String, dynamic> json) => AssignedClinician(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    userType: UserType.fromWire(json['userType'] as String),
  );
}
