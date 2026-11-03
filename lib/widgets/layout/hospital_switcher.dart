import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../controllers/care/patient_context_controller.dart';

/// App bar title: the selected Hospital, with a menu to switch when the patient is enrolled at several.
class HospitalSwitcher extends ConsumerWidget {
  const HospitalSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientContextProvider).value;
    final hospital = patient?.hospital;
    final theme = Theme.of(context);
    final title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_hospital_rounded, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Flexible(
          child: Text(hospital?.name ?? AppConstants.appName, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
        ),
      ],
    );
    if (patient == null || patient.hospitals.length < 2) return title;
    return PopupMenuButton<String>(
      initialValue: hospital?.id,
      onSelected: (id) => ref.read(patientContextProvider.notifier).select(id),
      itemBuilder: (_) => [
        for (final h in patient.hospitals) PopupMenuItem(value: h.id, child: Text(h.name)),
      ],
      child: Row(mainAxisSize: MainAxisSize.min, children: [Flexible(child: title), const Icon(Icons.expand_more_rounded)]),
    );
  }
}
