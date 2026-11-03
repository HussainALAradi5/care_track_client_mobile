import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/identity/user_type.dart';
import '../../models/care/assigned_clinician.dart';
import '../core/service_providers.dart';
import 'patient_context_controller.dart';

/// The patient's care team at the selected Hospital.
final careTeamProvider = FutureProvider<List<AssignedClinician>>((ref) async {
  final hospital = ref.watch(selectedHospitalProvider);
  if (hospital == null) return const [];
  final page = await ref
      .read(careTeamServiceProvider)
      .myCareTeam(hospital.id, const PageRequest(page: 0, size: AppConstants.maxCareTeam));
  return page.items;
});

/// Clinician id → display name, for cards that only carry the id.
final clinicianNamesProvider = Provider<Map<String, String>>(
  (ref) => {for (final c in ref.watch(careTeamProvider).value ?? const <AssignedClinician>[]) c.id: c.name},
);

/// Only doctors take consultation bookings (the server rejects other clinicians).
final bookableDoctorsProvider = Provider<AsyncValue<List<AssignedClinician>>>(
  (ref) => ref.watch(careTeamProvider).whenData((team) => team.where((c) => c.userType == UserType.doctor).toList()),
);
