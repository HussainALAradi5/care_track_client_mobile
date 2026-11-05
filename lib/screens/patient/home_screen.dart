import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/booking_texts.dart';
import '../../constants/texts/home_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/care/care_team_controller.dart';
import '../../controllers/care/home_summary_controller.dart';
import '../../controllers/ui/clock_controller.dart';
import '../../utilities/care/journey.dart';
import '../../widgets/care/appointment_card.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/motion/fade_slide_in.dart';
import '../../widgets/common/progress/stat_tile.dart';
import '../../widgets/common/progress/timeline.dart';
import '../../widgets/layout/patient_page.dart';

/// Overview: greeting, counts, the next visit with its cancellation window, and that visit's journey.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final summary = ref.watch(homeSummaryProvider);
    final names = ref.watch(clinicianNamesProvider);
    final now = ref.watch(nowProvider);
    final theme = Theme.of(context);
    Future<void> refresh() => ref.refresh(homeSummaryProvider.future);
    return PatientPage(
      title: HomeTexts.greeting(user?.firstName ?? ''),
      subtitle: HomeTexts.subtitle,
      onRefresh: refresh,
      child: AsyncBody(
        value: summary,
        onRetry: refresh,
        skeletonRows: 3,
        data: (s) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: FadeSlideIn(
                    child: StatTile(label: HomeTexts.openRequests, value: s.openRequests, icon: Icons.hourglass_top_rounded),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FadeSlideIn(
                    index: 1,
                    child: StatTile(label: HomeTexts.upcoming, value: s.upcoming, icon: Icons.event_rounded),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FadeSlideIn(
                    index: 2,
                    child: StatTile(label: HomeTexts.completed, value: s.completed, icon: Icons.task_alt_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(HomeTexts.nextVisit, style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            if (s.next == null)
              EmptyState(
                icon: Icons.upcoming_rounded,
                title: HomeTexts.noNextVisit,
                hint: HomeTexts.noNextVisitHint,
                action: FilledButton.tonal(onPressed: () => context.go(RoutePaths.book), child: const Text(BookingTexts.bookNow)),
              )
            else ...[
              FadeSlideIn(
                index: 3,
                child: AppointmentCard(
                  appointment: s.next!,
                  clinicianName: names[s.next!.clinicianId] ?? '',
                  now: now,
                  highlight: true,
                ),
              ),
              const SizedBox(height: 24),
              Text(HomeTexts.journey, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Timeline(entries: appointmentJourney(s.next!)),
            ],
          ],
        ),
      ),
    );
  }
}
