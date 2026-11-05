import 'staff_hospital.dart';

/// The staff member's hospitals and the one every staff screen works in.
class StaffContext {
  const StaffContext({required this.hospitals, required this.selectedId});

  final List<StaffHospital> hospitals;
  final String? selectedId;

  StaffHospital? get hospital {
    for (final h in hospitals) {
      if (h.hospitalId == selectedId) return h;
    }
    return hospitals.isEmpty ? null : hospitals.first;
  }

  bool can(String permission) => hospital?.can(permission) ?? false;
}
