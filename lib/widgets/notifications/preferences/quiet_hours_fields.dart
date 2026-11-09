import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/notification_texts.dart';
import '../../../controllers/notifications/notification_preferences_controller.dart';
import '../../../models/notifications/notification_preferences.dart';
import '../../../utilities/time/dates.dart';
import '../../common/inputs/picker_field.dart';
import '../../common/pickers/app_pickers.dart';

/// The quiet-hours switch and, while on, its start and end times.
class QuietHoursFields extends ConsumerWidget {
  const QuietHoursFields({super.key, required this.preferences});

  final NotificationPreferences preferences;

  Future<void> _pick(BuildContext context, TimeOfDay current, ValueChanged<TimeOfDay> onPicked) async {
    final picked = await AppPickers.time(context, initialTime: current);
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(notificationPreferencesProvider.notifier);
    final p = preferences;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(NotificationTexts.quietHoursOn),
          subtitle: const Text(NotificationTexts.quietHoursHint),
          value: p.quietOn,
          onChanged: controller.setQuietOn,
        ),
        if (p.quietOn) ...[
          PickerField(
            label: NotificationTexts.quietStart,
            value: hourMinute(p.quietStart),
            icon: Icons.bedtime_rounded,
            onTap: () => _pick(context, p.quietStart, controller.setQuietStart),
          ),
          const SizedBox(height: AppSpacing.medium),
          PickerField(
            label: NotificationTexts.quietEnd,
            value: hourMinute(p.quietEnd),
            icon: Icons.wb_sunny_rounded,
            onTap: () => _pick(context, p.quietEnd, controller.setQuietEnd),
          ),
        ],
      ],
    );
  }
}
