import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/sign_up_texts.dart';
import '../../../controllers/identity/sign_up_form_controller.dart';
import '../../common/display/section_card.dart';
import '../../common/inputs/search_select_field.dart';

/// The home hospital, found by typing; it opens once a country is chosen.
class YourHospitalSection extends ConsumerWidget {
  const YourHospitalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signUpFormProvider);
    final form = ref.read(signUpFormProvider.notifier);
    return SectionCard(
      title: SignUpTexts.hospitalTitle,
      hint: SignUpTexts.hospitalLead,
      icon: Icons.local_hospital_rounded,
      children: [
        SearchSelectField(
          key: ValueKey('${draft.country?.id}-${draft.city?.id}'),
          label: SignUpTexts.hospital,
          placeholder: SignUpTexts.hospitalPlaceholder,
          icon: Icons.local_hospital_rounded,
          value: draft.hospital,
          enabled: draft.country != null,
          load: form.hospitalLoader,
          onChanged: form.setHospital,
          errorText: draft.tried && draft.hospital == null ? SignUpTexts.required : null,
        ),
      ],
    );
  }
}
