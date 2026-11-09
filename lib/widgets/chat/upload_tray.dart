import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';
import '../../models/chat/chat_upload.dart';

/// The files going with the next message, each with its progress.
class UploadTray extends StatelessWidget {
  const UploadTray({super.key, required this.uploads, required this.onRemove});

  final List<ChatUpload> uploads;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        children: [
          for (final u in uploads)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                      if (u.failed)
                        Text(ChatTexts.uploadFailed, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error))
                      else if (u.isBusy)
                        LinearProgressIndicator(value: u.progress),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: ChatTexts.removeUpload,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => onRemove(u.id),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
