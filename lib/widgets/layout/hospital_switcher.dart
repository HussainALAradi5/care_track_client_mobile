import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/care/patient_context_controller.dart';
import 'hospital_menu.dart';

/// Patient app bar title: the selected Hospital, switchable when the patient is enrolled at several.
class HospitalSwitcher extends ConsumerWidget {
  const HospitalSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientContextProvider).value;
    final hospital = patient?.hospital;
    return HospitalMenu(
      selectedName: hospital?.name,
      selectedId: hospital?.id,
      options: {for (final h in patient?.hospitals ?? const []) h.id: h.name},
      onSelect: (id) => ref.read(patientContextProvider.notifier).select(id),
    );
  }
}
