/// GET /api/auth/me/hospitals item (StaffHospitalDto): a hospital where the caller works and what they may do there.
class StaffHospital {
  const StaffHospital({
    required this.hospitalId,
    required this.organizationId,
    required this.code,
    required this.name,
    required this.administrator,
    required this.permissions,
  });

  final String hospitalId;
  final String organizationId;
  final String code;
  final String name;

  /// An organization platform administrator passes every check whatever [permissions] lists.
  final bool administrator;
  final Set<String> permissions;

  /// Decides what to show only; the server checks every call again.
  bool can(String permission) => administrator || permissions.contains(permission);

  factory StaffHospital.fromJson(Map<String, dynamic> json) => StaffHospital(
    hospitalId: json['hospitalId'] as String,
    organizationId: json['organizationId'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    administrator: json['administrator'] as bool,
    permissions: {for (final code in json['permissions'] as List<dynamic>) code as String},
  );
}
