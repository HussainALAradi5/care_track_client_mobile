import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/identity_rules.dart';
import '../../../constants/texts/sign_up_texts.dart';
import '../../../controllers/identity/sign_up_form_controller.dart';
import '../../common/display/section_card.dart';
import '../../common/inputs/search_select_field.dart';

/// Nationality, country and city of residence, and the address.
class WhereYouLiveSection extends ConsumerWidget {
  const WhereYouLiveSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signUpFormProvider);
    final form = ref.read(signUpFormProvider.notifier);
    String? missing(Object? value) => draft.tried && value == null ? SignUpTexts.required : null;
    return SectionCard(
      title: SignUpTexts.homeTitle,
      icon: Icons.home_rounded,
      children: [
        SearchSelectField(
          label: SignUpTexts.nationality,
          placeholder: SignUpTexts.choose,
          icon: Icons.flag_rounded,
          value: draft.nationality,
          load: form.countryLoader,
          onChanged: form.setNationality,
          errorText: missing(draft.nationality),
        ),
        const SizedBox(height: AppSpacing.medium),
        SearchSelectField(
          label: SignUpTexts.residenceCountry,
          placeholder: SignUpTexts.choose,
          icon: Icons.public_rounded,
          value: draft.country,
          load: form.countryLoader,
          onChanged: form.setCountry,
          errorText: missing(draft.country),
        ),
        const SizedBox(height: AppSpacing.medium),
        SearchSelectField(
          key: ValueKey(draft.country?.id),
          label: SignUpTexts.residenceCity,
          placeholder: SignUpTexts.choose,
          icon: Icons.location_city_rounded,
          value: draft.city,
          enabled: draft.country != null,
          load: form.cityLoader,
          onChanged: form.setCity,
          errorText: missing(draft.city),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          maxLength: IdentityRules.addressMax,
          decoration: InputDecoration(
            labelText: SignUpTexts.address,
            prefixIcon: const Icon(Icons.signpost_rounded),
            errorText: draft.tried && draft.address.trim().isEmpty ? SignUpTexts.addressInvalid : null,
          ),
          onChanged: form.setAddress,
        ),
      ],
    );
  }
}
