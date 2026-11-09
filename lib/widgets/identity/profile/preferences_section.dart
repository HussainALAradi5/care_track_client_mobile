import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/picker_texts.dart';
import '../../../constants/texts/profile_texts.dart';
import '../../../controllers/ui/picker_style_controller.dart';
import '../../../controllers/ui/theme_controller.dart';
import '../../common/display/section_card.dart';
import '../../common/pickers/picker_style_sheet.dart';

/// Light or dark theme and the person's Picker style.
class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final chosen = ref.watch(chosenPickerStyleProvider);
    return SectionCard(
      title: ProfileTexts.preferencesTitle,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(ProfileTexts.theme),
          subtitle: const Text(ProfileTexts.themeHint),
          value: brightness == Brightness.dark,
          onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(brightness),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_rounded),
          title: const Text(PickerTexts.pickerStyle),
          subtitle: Text(chosen == null ? PickerTexts.deviceDefault : PickerTexts.label(chosen)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => showPickerStyleSheet(context),
        ),
      ],
    );
  }
}
