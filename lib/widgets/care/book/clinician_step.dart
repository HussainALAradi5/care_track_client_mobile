import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/booking_texts.dart';
import '../../../controllers/care/booking_draft_controller.dart';
import '../../../controllers/care/care_team_controller.dart';
import '../../../utilities/text/initials.dart';
import '../../common/feedback/async_body.dart';
import '../../common/feedback/empty_state.dart';
import '../../common/inputs/choice_card.dart';
import '../../common/motion/fade_slide_in.dart';

/// Step 2: a doctor or nurse from the patient's care team at that Hospital.
class ClinicianStep extends ConsumerWidget {
  const ClinicianStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(bookableDoctorsProvider);
    final chosen = ref.watch(bookingDraftProvider.select((d) => d.clinicianId));
    return AsyncBody(
      value: team,
      skeletonRows: 3,
      onRetry: () => ref.invalidate(careTeamProvider),
      data: (clinicians) => clinicians.isEmpty
          ? const EmptyState(icon: Icons.group_off_rounded, title: BookingTexts.noCareTeam, hint: BookingTexts.noCareTeamHint)
          : Column(
              children: [
                for (var i = 0; i < clinicians.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FadeSlideIn(
                      index: i,
                      child: ChoiceCard(
                        initials: initialsOf(clinicians[i].name),
                        title: clinicians[i].name,
                        subtitle: clinicians[i].code,
                        selected: clinicians[i].id == chosen,
                        onTap: () => ref.read(bookingDraftProvider.notifier).chooseClinician(clinicians[i].id),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
