import '../identity/staff_context_controller.dart';
import 'hospital_paged_controller.dart';

/// A paged list for the staff member's selected Hospital. It loads nothing where the Hospital does not grant
/// [permission], so a locked screen never calls the server.
abstract class StaffPagedController<T> extends HospitalPagedController<T> {
  /// The permission code the list needs at the Hospital.
  String get permission;

  @override
  String? watchHospitalId() {
    final hospital = ref.watch(selectedStaffHospitalProvider);
    return hospital != null && hospital.can(permission) ? hospital.hospitalId : null;
  }

  @override
  String? readHospitalId() {
    final hospital = ref.read(selectedStaffHospitalProvider);
    return hospital != null && hospital.can(permission) ? hospital.hospitalId : null;
  }
}
