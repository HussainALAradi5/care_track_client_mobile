import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../constants/error_codes.dart';
import '../../constants/hospital_styles.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../../constants/texts/hospital_texts.dart';
import '../../controllers/facilities/hospitals_near_controller.dart';
import '../../controllers/facilities/near_opening_filter_controller.dart';
import '../../models/facilities/hospital_summary.dart';
import '../../utilities/http/error_message.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/inputs/filter_chips.dart';
import '../../widgets/facilities/hospital_card.dart';
import '../../widgets/facilities/register_here.dart';

/// The person's nearby hospitals, filtered by whether they are open now; without a home address it points to the
/// search instead.
class HospitalsNearScreen extends ConsumerWidget {
  const HospitalsNearScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(hospitalsNearProvider);
    final controller = ref.read(hospitalsNearProvider.notifier);
    final noResidence = apiErrorCodeOf(value.error) == ErrorCodes.residenceRequired;
    return Scaffold(
      appBar: AppBar(
        title: const Text(HospitalTexts.nearTitle),
        actions: [
          TextButton(
            onPressed: () => context.push(RoutePaths.find),
            child: const Text(CareModeTexts.findHospitals),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.page,
        children: [
          const Text(HospitalTexts.nearSubtitle),
          const SizedBox(height: AppSpacing.medium),
          FilterChips(
            label: HospitalTexts.filterLabel,
            options: HospitalStyles.openingFilters,
            selected: ref.watch(nearOpeningFilterProvider),
            onSelected: ref.read(nearOpeningFilterProvider.notifier).set,
          ),
          const SizedBox(height: AppSpacing.medium),
          if (noResidence)
            const EmptyState(
              icon: Icons.travel_explore_rounded,
              title: CareModeTexts.noResidence,
              hint: CareModeTexts.noResidenceHint,
            )
          else
            PagedList<HospitalSummary>(
              value: value,
              idOf: (h) => h.id,
              emptyIcon: Icons.local_hospital_rounded,
              emptyTitle: HospitalTexts.emptyTitle,
              emptyHint: HospitalTexts.emptyHint,
              onRetry: controller.refresh,
              onLoadMore: controller.loadMore,
              itemBuilder: (h) => HospitalCard(hospital: h, action: RegisterHere(hospital: h)),
            ),
        ],
      ),
    );
  }
}
