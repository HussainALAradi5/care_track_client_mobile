import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/chat_constants.dart';
import '../../constants/texts/chat_texts.dart';
import '../../enums/chat/receipt_state.dart';
import '../../models/chat/chat_attachment.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/message_history.dart';
import '../../models/chat/reaction_group.dart';
import '../../utilities/time/dates.dart';
import 'attachment_tile.dart';
import 'edit_history.dart';
import 'reaction_chips.dart';
import 'receipt_ticks.dart';

/// One message: its text or deleted placeholder, the message it answers, attachments, reactions and the receipt on
/// mine. Long press opens its actions.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.mine,
    required this.receipt,
    this.reactions = const [],
    this.history,
    this.onLongPress,
    this.onReact,
    this.onDownload,
    this.onToggleHistory,
  });

  final ChatMessage message;
  final bool mine;
  final ReceiptState receipt;
  final List<ReactionGroup> reactions;
  final MessageHistory? history;
  final VoidCallback? onLongPress;
  final ValueChanged<ReactionGroup>? onReact;
  final ValueChanged<ChatAttachment>? onDownload;
  final VoidCallback? onToggleHistory;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: message.deleted ? null : onLongPress,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * ChatConstants.bubbleMaxWidthFraction),
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.tiny),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.small),
          decoration: BoxDecoration(
            color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.large),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.replyTo != null) ...[
                Text(
                  message.replyTo!.deleted ? ChatTexts.deleted : (message.replyTo!.text ?? ''),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: AppSpacing.tiny),
              ],
              if (message.deleted)
                Text(ChatTexts.deleted, style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic))
              else if (message.text != null)
                Text(message.text!, style: text.bodyMedium),
              for (final attachment in message.attachments)
                AttachmentTile(attachment: attachment, onDownload: () => onDownload?.call(attachment)),
              if (reactions.isNotEmpty) ReactionChips(groups: reactions, onTap: (g) => onReact?.call(g)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(shortDateTime(message.createdAt.toLocal()), style: text.labelSmall),
                  if (message.edited) ...[
                    const SizedBox(width: AppSpacing.tiny),
                    GestureDetector(onTap: onToggleHistory, child: Text(ChatTexts.edited, style: text.labelSmall)),
                  ],
                  if (mine && !message.deleted) ...[const SizedBox(width: AppSpacing.tiny), ReceiptTicks(state: receipt)],
                ],
              ),
              if (history != null) EditHistory(history: history!),
            ],
          ),
        ),
      ),
    );
  }
}
