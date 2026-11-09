import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/picker_layout.dart';
import '../../../constants/texts/picker_texts.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/ui/picker_style_controller.dart';
import '../../../enums/ui/picker_style.dart';
import '../feedback/app_snack.dart';
import '../inputs/choice_card.dart';

/// Opens the Picker style setting from the account menu.
Future<void> showPickerStyleSheet(BuildContext context) =>
    showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (_) => const PickerStyleSheet());

/// The person's own picker look, saved on their account when chosen.
class PickerStyleSheet extends ConsumerWidget {
  const PickerStyleSheet({super.key});

  Future<void> _save(BuildContext context, WidgetRef ref, PickerStyle? style) async {
    final navigator = Navigator.of(context);
    final messenger = context;
    try {
      await ref.read(authControllerProvider.notifier).setPickerStyle(style);
      if (messenger.mounted) AppSnack.success(messenger, PickerTexts.saved);
      navigator.pop();
    } catch (error) {
      if (messenger.mounted) AppSnack.error(messenger, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = ref.watch(chosenPickerStyleProvider);
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(PickerLayout.sheetPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(PickerTexts.pickerStyle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(PickerTexts.pickerStyleHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            ChoiceCard(
              title: PickerTexts.deviceDefault,
              subtitle: PickerTexts.deviceDefaultHint,
              icon: Icons.devices_rounded,
              selected: chosen == null,
              onTap: () => _save(context, ref, null),
            ),
            for (final style in PickerStyle.values) ...[
              const SizedBox(height: PickerLayout.headerGap),
              ChoiceCard(
                title: PickerTexts.label(style),
                subtitle: PickerTexts.hint(style),
                icon: Icons.event_rounded,
                selected: chosen == style,
                onTap: () => _save(context, ref, style),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
