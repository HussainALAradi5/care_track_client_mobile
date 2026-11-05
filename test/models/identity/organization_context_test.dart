import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/models/identity/organization_context.dart';
import 'package:care_track_client_mobile/models/identity/staff_organization.dart';
import 'package:flutter_test/flutter_test.dart';

StaffOrganization organization(String id, List<String> permissions, {bool administrator = false}) =>
    StaffOrganization.fromJson({
      'organizationId': id,
      'code': id,
      'name': 'Organization $id',
      'administrator': administrator,
      'permissions': permissions,
    });

void main() {
  test('parses StaffOrganizationDto and checks its permission codes', () {
    final o = organization('o1', [PermissionCodes.journalRead]);
    expect(o.name, 'Organization o1');
    expect(o.can(PermissionCodes.journalRead), isTrue);
    expect(o.can(PermissionCodes.financeReportRead), isFalse);
    expect(organization('o2', const [], administrator: true).can(PermissionCodes.accountRead), isTrue);
  });

  test('the selected organization falls back to the first one', () {
    final context = OrganizationContext(
      organizations: [organization('o1', const []), organization('o2', const [])],
      selectedId: 'gone',
    );
    expect(context.organization?.organizationId, 'o1');
    expect(const OrganizationContext(organizations: [], selectedId: null).organization, isNull);
  });

  test('accountants are their own account type', () {
    expect(UserType.fromWire('ACCOUNTANT'), UserType.accountant);
    expect(UserType.accountant.isAccountant, isTrue);
    expect(UserType.doctor.isAccountant, isFalse);
  });
}
