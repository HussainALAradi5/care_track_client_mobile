import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';
import '../../models/chat/message_history.dart';
import '../../utilities/time/dates.dart';

/// The earlier versions of a message, shown under it.
class EditHistory extends StatelessWidget {
  const EditHistory({super.key, required this.history});

  final MessageHistory history;

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.tiny),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ChatTexts.historyTitle, style: small?.copyWith(fontWeight: FontWeight.w700)),
          for (final edit in history.edits)
            Text('${shortDateTime(edit.editedAt.toLocal())} · ${edit.previousText ?? ''}', style: small),
        ],
      ),
    );
  }
}
