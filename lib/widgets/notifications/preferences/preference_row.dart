import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/notification_texts.dart';
import '../../../models/notifications/notification_type_preference.dart';

/// One kind of notification and its three channels.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({super.key, required this.row, required this.onChanged});

  final NotificationTypePreference row;
  final ValueChanged<NotificationTypePreference> onChanged;

  Widget _chip(String label, bool value, ValueChanged<bool> toggle) =>
      FilterChip(label: Text(label), selected: value, onSelected: toggle);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(NotificationTexts.typeLabels[row.type] ?? row.type, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.tiny),
        Wrap(
          spacing: AppSpacing.small,
          children: [
            _chip(NotificationTexts.inApp, row.inApp, (v) => onChanged(row.copyWith(inApp: v))),
            _chip(NotificationTexts.push, row.push, (v) => onChanged(row.copyWith(push: v))),
            _chip(NotificationTexts.email, row.email, (v) => onChanged(row.copyWith(email: v))),
          ],
        ),
      ],
    ),
  );
}
