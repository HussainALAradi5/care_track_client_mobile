import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/identity/staff_context.dart';
import '../../models/identity/staff_hospital.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The staff member's hospitals with their permission codes, and the selected one, remembered between launches.
/// Patients get an empty context without a call.
class StaffContextController extends AsyncNotifier<StaffContext> {
  @override
  Future<StaffContext> build() async {
    final user = await ref.watch(authControllerProvider.future);
    if (user == null || !user.userType.isStaff) return const StaffContext(hospitals: [], selectedId: null);
    final page = await ref
        .read(staffHospitalServiceProvider)
        .myHospitals(const PageRequest(page: 0, pageSize: AppConstants.maxStaffHospitals));
    final stored = ref.read(sharedPreferencesProvider).getString(AppConstants.staffHospitalKey);
    return StaffContext(hospitals: page.items, selectedId: stored);
  }

  Future<void> select(String hospitalId) async {
    final current = state.value;
    if (current == null || current.selectedId == hospitalId) return;
    state = AsyncData(StaffContext(hospitals: current.hospitals, selectedId: hospitalId));
    await ref.read(sharedPreferencesProvider).setString(AppConstants.staffHospitalKey, hospitalId);
  }
}

final staffContextProvider = AsyncNotifierProvider<StaffContextController, StaffContext>(StaffContextController.new);

/// The hospital every staff screen works in (null while loading or when the person works nowhere).
final selectedStaffHospitalProvider = Provider<StaffHospital?>(
  (ref) => ref.watch(staffContextProvider).value?.hospital,
);
