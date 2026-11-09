import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/hospital_styles.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../../controllers/care/patient_context_controller.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/facilities/hospital_summary.dart';
import '../common/buttons/app_button.dart';
import '../common/feedback/app_snack.dart';
import '../common/status/status_chip.dart';

/// On a hospital card: register as a patient there, or "Registered here" once done. Anyone signed in can, staff of
/// another hospital (or this one) included.
class RegisterHere extends ConsumerWidget {
  const RegisterHere({super.key, required this.hospital});

  final HospitalSummary hospital;

  Future<void> _register(BuildContext context, WidgetRef ref) async {
    final enrolled = await ref.read(patientContextProvider.notifier).register(hospital.id);
    if (context.mounted) AppSnack.success(context, CareModeTexts.done(enrolled.name));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitals = ref.watch(patientContextProvider).value?.hospitals ?? const [];
    if (hospitals.any((h) => h.id == hospital.id)) {
      return const Align(alignment: Alignment.centerLeft, child: StatusChip(status: HospitalStyles.registered));
    }
    return AppButton(
      label: CareModeTexts.register,
      icon: Icons.how_to_reg_rounded,
      variant: ButtonVariant.tonal,
      onPressed: () => _register(context, ref),
    );
  }
}
