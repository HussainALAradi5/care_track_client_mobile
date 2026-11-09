import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/hospital_styles.dart';
import '../../constants/texts/hospital_texts.dart';
import '../../constants/texts/search_select_texts.dart';
import '../../controllers/facilities/hospital_search_controller.dart';
import '../common/inputs/filter_chips.dart';
import '../common/inputs/search_select_field.dart';

/// Country, city, public or private, and opening state of the public search.
class FindFilters extends ConsumerWidget {
  const FindFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(hospitalSearchProvider);
    final controller = ref.read(hospitalSearchProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchSelectField(
          label: HospitalTexts.country,
          placeholder: HospitalTexts.anyCountry,
          clearLabel: HospitalTexts.anyCountry,
          icon: Icons.public_rounded,
          value: filters.country,
          load: controller.countryLoader,
          onChanged: controller.setCountry,
        ),
        const SizedBox(height: AppSpacing.medium),
        SearchSelectField(
          key: ValueKey(filters.country?.id),
          label: HospitalTexts.city,
          placeholder: filters.country == null ? SearchSelectTexts.search : HospitalTexts.anyCity,
          clearLabel: HospitalTexts.anyCity,
          icon: Icons.location_city_rounded,
          value: filters.city,
          enabled: filters.country != null,
          load: controller.cityLoader,
          onChanged: controller.setCity,
        ),
        const SizedBox(height: AppSpacing.medium),
        FilterChips(
          label: HospitalTexts.typeLabel,
          options: HospitalStyles.typeFilters,
          selected: filters.type,
          onSelected: controller.setType,
        ),
        const SizedBox(height: AppSpacing.medium),
        FilterChips(
          label: HospitalTexts.filterLabel,
          options: HospitalStyles.openingFilters,
          selected: filters.openingState,
          onSelected: controller.setOpeningState,
        ),
      ],
    );
  }
}
