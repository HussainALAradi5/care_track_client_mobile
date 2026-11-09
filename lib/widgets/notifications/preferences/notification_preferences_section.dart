import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/notification_texts.dart';
import '../../../controllers/notifications/notification_preferences_controller.dart';
import '../../../models/notifications/notification_preferences.dart';
import '../../common/buttons/app_button.dart';
import '../../common/display/section_card.dart';
import '../../common/feedback/app_snack.dart';
import '../../common/feedback/async_body.dart';
import 'preference_row.dart';
import 'quiet_hours_fields.dart';

/// On My profile: how each kind of news reaches the person, and the quiet-hours window.
class NotificationPreferencesSection extends ConsumerWidget {
  const NotificationPreferencesSection({super.key});

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    await ref.read(notificationPreferencesProvider.notifier).save();
    if (context.mounted) AppSnack.success(context, NotificationTexts.preferencesSaved);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(notificationPreferencesProvider.notifier);
    return SectionCard(
      title: NotificationTexts.preferencesTitle,
      hint: NotificationTexts.preferencesHint,
      children: [
        Text(NotificationTexts.preferencesProviderNote, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.medium),
        AsyncBody<NotificationPreferences?>(
          value: ref.watch(notificationPreferencesProvider),
          skeletonRows: 2,
          onRetry: () => ref.invalidate(notificationPreferencesProvider),
          data: (preferences) {
            if (preferences == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final row in preferences.types) PreferenceRow(row: row, onChanged: controller.setType),
                const Divider(),
                QuietHoursFields(preferences: preferences),
                const SizedBox(height: AppSpacing.medium),
                AppButton(
                  label: NotificationTexts.preferencesSave,
                  icon: Icons.save_rounded,
                  expand: true,
                  onPressed: () => _save(context, ref),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
