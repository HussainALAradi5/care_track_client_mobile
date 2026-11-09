import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/leave_texts.dart';
import '../../../models/documents/written_document.dart';

/// The sick note going with this request; removing it leaves the rest of the form.
class SickNoteBanner extends StatelessWidget {
  const SickNoteBanner({super.key, required this.note, required this.onRemove});

  final WrittenDocument note;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.medium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LeaveTexts.sickNoteAttached(note.hospitalName, note.authorName), style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.tiny),
                Text(LeaveTexts.sickNoteHint, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          TextButton(onPressed: onRemove, child: const Text(LeaveTexts.removeSickNote)),
        ],
      ),
    );
  }
}
