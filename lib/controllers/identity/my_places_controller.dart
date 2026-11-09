import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/identity/place.dart';
import '../auth/auth_controller.dart';
import '../care/patient_context_controller.dart';
import 'care_mode_controller.dart';
import 'organization_context_controller.dart';
import 'staff_context_controller.dart';

/// Whether the person is on the accountant's side right now, or staff on "My care" is on the patient side.
final onAccountantSideProvider = Provider<bool>((ref) {
  final user = ref.watch(authControllerProvider).value;
  return user != null && user.userType.isAccountant && !ref.watch(careModeProvider);
});

/// Where the signed-in person belongs on the side they are on: Organizations, staff hospitals or enrolled hospitals.
final myPlacesProvider = Provider<AsyncValue<List<Place>>>((ref) {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return const AsyncData([]);
  if (ref.watch(onAccountantSideProvider)) {
    return ref
        .watch(organizationContextProvider)
        .whenData((c) => [for (final o in c.organizations) Place(id: o.organizationId, name: o.name)]);
  }
  if (user.userType.isStaff && !ref.watch(careModeProvider)) {
    return ref
        .watch(staffContextProvider)
        .whenData((c) => [for (final h in c.hospitals) Place(id: h.hospitalId, name: h.name)]);
  }
  return ref
      .watch(patientContextProvider)
      .whenData((c) => [for (final h in c.hospitals) Place(id: h.id, name: h.name)]);
});
