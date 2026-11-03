import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/motion.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/booking_texts.dart';
import '../../controllers/care/booking_draft_controller.dart';
import '../../controllers/care/care_team_controller.dart';
import '../../controllers/care/patient_context_controller.dart';
import '../../widgets/care/book/clinician_step.dart';
import '../../widgets/care/book/hospital_step.dart';
import '../../widgets/care/book/review_step.dart';
import '../../widgets/care/book/time_step.dart';
import '../../widgets/common/buttons/app_button.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/progress/step_progress.dart';
import '../../widgets/layout/patient_page.dart';

const _reviewStep = 3;

/// Four-step booking request with an animated step header; each step slides in.
class BookScreen extends ConsumerWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    // Watched so "Continue" re-evaluates when the Hospital or care team changes.
    ref.watch(selectedHospitalProvider);
    ref.watch(bookableDoctorsProvider);
    final controller = ref.read(bookingDraftProvider.notifier);
    final step = switch (draft.step) {
      0 => const HospitalStep(),
      1 => const ClinicianStep(),
      2 => const TimeStep(),
      _ => const ReviewStep(),
    };
    return PatientPage(
      title: BookingTexts.wizardTitle,
      onRefresh: () async => ref.invalidate(careTeamProvider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepProgress(steps: BookingTexts.steps, current: draft.step),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: Motion.medium,
            switchInCurve: Motion.standard,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(begin: const Offset(0.08, 0), end: Offset.zero).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(draft.step), child: step),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton.icon(
                onPressed: draft.step == 0 ? null : controller.back,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(BookingTexts.back),
              ),
              const Spacer(),
              if (draft.step < _reviewStep)
                FilledButton.icon(
                  onPressed: controller.canContinue ? controller.next : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  iconAlignment: IconAlignment.end,
                  label: const Text(BookingTexts.next),
                )
              else
                AppButton(
                  label: BookingTexts.submit,
                  icon: Icons.send_rounded,
                  onPressed: controller.submit,
                  onDone: () {
                    AppSnack.success(context, BookingTexts.submitted);
                    context.go(RoutePaths.requests);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
