import 'staff_organization.dart';

/// The accountant's Organizations and the one the books screens work in.
class OrganizationContext {
  const OrganizationContext({required this.organizations, required this.selectedId});

  final List<StaffOrganization> organizations;
  final String? selectedId;

  StaffOrganization? get organization {
    for (final o in organizations) {
      if (o.organizationId == selectedId) return o;
    }
    return organizations.isEmpty ? null : organizations.first;
  }

  bool can(String permission) => organization?.can(permission) ?? false;
}
