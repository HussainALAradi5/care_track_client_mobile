import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/identity_rules.dart';
import '../../../constants/texts/sign_up_texts.dart';
import '../../../controllers/identity/sign_up_form_controller.dart';
import '../../../enums/identity/gender.dart';
import '../../../enums/identity/marital_status.dart';
import '../../../models/ui/filter_option.dart';
import '../../../utilities/time/dates.dart';
import '../../../validations/identity/phone.dart';
import '../../common/display/section_card.dart';
import '../../common/inputs/filter_chips.dart';
import '../../common/inputs/picker_field.dart';
import '../../common/pickers/app_pickers.dart';

/// Gender, marital status, and the optional birth date and mobile number.
class AboutYouSection extends ConsumerWidget {
  const AboutYouSection({super.key});

  Future<void> _pickBirthDate(BuildContext context, SignUpFormController form, DateTime? current) async {
    final today = startOfDay(DateTime.now());
    final picked = await AppPickers.date(
      context,
      initialDate: current ?? DateTime(today.year - IdentityRules.defaultBirthYearsAgo),
      firstDate: DateTime(IdentityRules.firstBirthYear),
      lastDate: today.subtract(const Duration(days: 1)),
    );
    if (picked != null) form.setDateOfBirth(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signUpFormProvider);
    final form = ref.read(signUpFormProvider.notifier);
    return SectionCard(
      title: SignUpTexts.aboutTitle,
      icon: Icons.person_rounded,
      children: [
        FilterChips<Gender>(
          label: SignUpTexts.gender,
          options: const [
            FilterOption(value: Gender.female, label: SignUpTexts.female, icon: Icons.female_rounded),
            FilterOption(value: Gender.male, label: SignUpTexts.male, icon: Icons.male_rounded),
          ],
          selected: draft.gender,
          onSelected: form.setGender,
          errorText: draft.tried && draft.gender == null ? SignUpTexts.required : null,
        ),
        const SizedBox(height: AppSpacing.medium),
        FilterChips<MaritalStatus>(
          label: SignUpTexts.maritalStatus,
          options: const [
            FilterOption(value: MaritalStatus.single, label: SignUpTexts.single, icon: Icons.person_rounded),
            FilterOption(value: MaritalStatus.married, label: SignUpTexts.married, icon: Icons.group_rounded),
          ],
          selected: draft.maritalStatus,
          onSelected: form.setMaritalStatus,
          errorText: draft.tried && draft.maritalStatus == null ? SignUpTexts.required : null,
        ),
        const SizedBox(height: AppSpacing.medium),
        PickerField(
          label: SignUpTexts.dateOfBirth,
          helperText: SignUpTexts.dateOfBirthHint,
          value: draft.dateOfBirth == null ? '' : longDate(draft.dateOfBirth!),
          icon: Icons.cake_rounded,
          onTap: () => _pickBirthDate(context, form, draft.dateOfBirth),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: SignUpTexts.phone,
            helperText: SignUpTexts.phoneHint,
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.smartphone_rounded),
            errorText: isValidOptionalPhone(draft.phone) ? null : SignUpTexts.phoneInvalid,
          ),
          onChanged: form.setPhone,
        ),
      ],
    );
  }
}
