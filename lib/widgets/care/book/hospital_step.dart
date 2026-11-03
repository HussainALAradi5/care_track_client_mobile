import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/care/booking_draft_controller.dart';
import '../../../controllers/care/patient_context_controller.dart';
import '../../common/inputs/choice_card.dart';
import '../../common/motion/fade_slide_in.dart';

/// Step 1: which Hospital (pre-selected when the patient is enrolled at only one).
class HospitalStep extends ConsumerWidget {
  const HospitalStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitals = ref.watch(patientContextProvider).value?.hospitals ?? const [];
    final selected = ref.watch(selectedHospitalProvider);
    return Column(
      children: [
        for (var i = 0; i < hospitals.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FadeSlideIn(
              index: i,
              child: ChoiceCard(
                icon: Icons.local_hospital_rounded,
                title: hospitals[i].name,
                subtitle: hospitals[i].city,
                selected: hospitals[i].id == selected?.id,
                onTap: () => ref.read(bookingDraftProvider.notifier).chooseHospital(hospitals[i].id),
              ),
            ),
          ),
      ],
    );
  }
}
