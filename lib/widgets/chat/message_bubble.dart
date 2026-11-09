import 'package:flutter/material.dart';

import '../../constants/chat_constants.dart';
import '../../constants/texts/chat_texts.dart';
import '../../enums/chat/receipt_state.dart';
import '../../models/chat/chat_message.dart';
import '../../utilities/time/dates.dart';
import 'receipt_ticks.dart';

/// One message: its text or deleted placeholder, the message it answers, and the receipt on mine.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.mine, required this.receipt, this.onReply});

  final ChatMessage message;
  final bool mine;
  final ReceiptState receipt;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: message.deleted ? null : onReply,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * ChatConstants.bubbleMaxWidthFraction),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
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
                const SizedBox(height: 4),
              ],
              if (message.deleted)
                Text(ChatTexts.deleted, style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic))
              else if (message.text != null)
                Text(message.text!, style: text.bodyMedium),
              if (message.attachmentCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${ChatTexts.attachments} (${message.attachmentCount})', style: text.bodySmall),
                ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(shortDateTime(message.createdAt.toLocal()), style: text.labelSmall),
                  if (message.edited) ...[
                    const SizedBox(width: 6),
                    Text(ChatTexts.edited, style: text.labelSmall),
                  ],
                  if (mine && !message.deleted) ...[const SizedBox(width: 6), ReceiptTicks(state: receipt)],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
