import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/care/patient_context.dart';
import '../../models/identity/enrolled_hospital.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The patient's Hospitals and the selected one, remembered between launches.
class PatientContextController extends AsyncNotifier<PatientContext> {
  @override
  Future<PatientContext> build() async {
    final user = await ref.watch(authControllerProvider.future);
    if (user == null) return const PatientContext(hospitals: [], selectedId: null);
    final page = await ref
        .read(enrollmentServiceProvider)
        .myHospitals(const PageRequest(page: 0, size: AppConstants.maxEnrollments));
    final stored = ref.read(sharedPreferencesProvider).getString(AppConstants.hospitalKey);
    return PatientContext(hospitals: page.items, selectedId: stored);
  }

  Future<void> select(String hospitalId) async {
    final current = state.value;
    if (current == null || current.selectedId == hospitalId) return;
    state = AsyncData(PatientContext(hospitals: current.hospitals, selectedId: hospitalId));
    await ref.read(sharedPreferencesProvider).setString(AppConstants.hospitalKey, hospitalId);
  }
}

final patientContextProvider = AsyncNotifierProvider<PatientContextController, PatientContext>(
  PatientContextController.new,
);

/// The Hospital every patient screen works in (null while loading or when not enrolled).
final selectedHospitalProvider = Provider<EnrolledHospital?>((ref) => ref.watch(patientContextProvider).value?.hospital);
