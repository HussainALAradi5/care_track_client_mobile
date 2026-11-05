import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/booking_texts.dart';
import '../../../controllers/care/booking_draft_controller.dart';
import '../../../controllers/care/care_team_controller.dart';
import '../../../controllers/care/patient_context_controller.dart';
import '../../../utilities/time/dates.dart';
import '../../common/motion/fade_slide_in.dart';
import 'review_row.dart';

/// Step 4: what will be sent, and a note that staff still confirm it.
class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final hospital = ref.watch(selectedHospitalProvider);
    final names = ref.watch(clinicianNamesProvider);
    final slot = draft.slot;
    final scheme = Theme.of(context).colorScheme;
    final rows = [
      (Icons.local_hospital_rounded, BookingTexts.stepHospital, hospital?.name ?? ''),
      (Icons.person_rounded, BookingTexts.stepClinician, names[draft.clinicianId] ?? ''),
      (Icons.schedule_rounded, BookingTexts.stepTime, slot == null ? '' : visitTime(slot.startsAt, slot.endsAt)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++)
          FadeSlideIn(index: i, child: ReviewRow(icon: rows[i].$1, label: rows[i].$2, value: rows[i].$3)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(child: Text(BookingTexts.reviewNote, style: TextStyle(color: scheme.onSurfaceVariant))),
          ],
        ),
      ],
    );
  }
}
