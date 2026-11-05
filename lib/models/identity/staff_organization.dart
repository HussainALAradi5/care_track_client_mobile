/// GET /api/auth/me/organizations item (StaffOrganizationDto): an Organization where the caller holds
/// Organization-wide grants (the accountant's books).
class StaffOrganization {
  const StaffOrganization({
    required this.organizationId,
    required this.code,
    required this.name,
    required this.administrator,
    required this.permissions,
  });

  final String organizationId;
  final String code;
  final String name;
  final bool administrator;
  final Set<String> permissions;

  /// Decides what to show only; the server checks every call again.
  bool can(String permission) => administrator || permissions.contains(permission);

  factory StaffOrganization.fromJson(Map<String, dynamic> json) => StaffOrganization(
    organizationId: json['organizationId'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    administrator: json['administrator'] as bool,
    permissions: {for (final code in json['permissions'] as List<dynamic>) code as String},
  );
}
