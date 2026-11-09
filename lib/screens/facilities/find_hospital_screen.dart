import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../../constants/texts/common_texts.dart';
import '../../constants/texts/hospital_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/facilities/public_hospitals_controller.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/facilities/hospital_summary.dart';
import '../../widgets/common/buttons/app_button.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/facilities/find_filters.dart';
import '../../widgets/facilities/hospital_card.dart';
import '../../widgets/facilities/register_here.dart';

/// The public hospital search: works signed out; signed-in people can register at a hospital from the results.
class FindHospitalScreen extends ConsumerWidget {
  const FindHospitalScreen({super.key});

  Widget _actionFor(BuildContext context, HospitalSummary hospital, bool signedIn) => signedIn
      ? RegisterHere(hospital: hospital)
      : AppButton(
          label: HospitalTexts.signInToBook,
          icon: Icons.event_available_rounded,
          variant: ButtonVariant.outlined,
          onPressed: () async => context.go(RoutePaths.signIn),
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(signedInUserIdProvider) != null;
    final controller = ref.read(publicHospitalsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(HospitalTexts.findTitle),
        actions: [
          TextButton(
            onPressed: () => context.go(signedIn ? RoutePaths.home : RoutePaths.signIn),
            child: Text(signedIn ? CareModeTexts.backToApp : CommonTexts.signIn),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.page,
        children: [
          const Text(HospitalTexts.findSubtitle),
          const SizedBox(height: AppSpacing.medium),
          const FindFilters(),
          const SizedBox(height: AppSpacing.large),
          PagedList<HospitalSummary>(
            value: ref.watch(publicHospitalsProvider),
            idOf: (h) => h.id,
            emptyIcon: Icons.travel_explore_rounded,
            emptyTitle: HospitalTexts.findEmpty,
            emptyHint: HospitalTexts.findEmptyHint,
            onRetry: controller.refresh,
            onLoadMore: controller.loadMore,
            itemBuilder: (h) => HospitalCard(hospital: h, action: _actionFor(context, h, signedIn)),
          ),
        ],
      ),
    );
  }
}
