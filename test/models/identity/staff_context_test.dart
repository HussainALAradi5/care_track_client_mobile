import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/models/identity/staff_context.dart';
import 'package:care_track_client_mobile/models/identity/staff_hospital.dart';
import 'package:flutter_test/flutter_test.dart';

StaffHospital hospital(String id, List<String> permissions, {bool administrator = false}) => StaffHospital.fromJson({
  'hospitalId': id,
  'organizationId': 'o1',
  'code': id,
  'name': 'Hospital $id',
  'administrator': administrator,
  'permissions': permissions,
});

void main() {
  test('parses StaffHospitalDto and checks its permission codes', () {
    final h = hospital('h1', [PermissionCodes.bookingReadAll]);
    expect(h.name, 'Hospital h1');
    expect(h.can(PermissionCodes.bookingReadAll), isTrue);
    expect(h.can(PermissionCodes.shiftWrite), isFalse);
  });

  test('an administrator passes every check', () {
    expect(hospital('h1', const [], administrator: true).can(PermissionCodes.shiftWrite), isTrue);
  });

  test('the selected hospital falls back to the first one', () {
    final hospitals = [
      hospital('h1', const []),
      hospital('h2', [PermissionCodes.shiftWrite]),
    ];
    expect(StaffContext(hospitals: hospitals, selectedId: 'h2').can(PermissionCodes.shiftWrite), isTrue);
    expect(StaffContext(hospitals: hospitals, selectedId: 'gone').hospital?.hospitalId, 'h1');
    expect(const StaffContext(hospitals: [], selectedId: null).can(PermissionCodes.shiftWrite), isFalse);
  });
}
