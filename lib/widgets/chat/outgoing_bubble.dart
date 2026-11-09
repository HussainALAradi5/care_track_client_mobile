import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';
import '../../models/chat/outgoing_message.dart';

/// A message on its way: shown at once, and marked with a retry when sending failed.
class OutgoingBubble extends StatelessWidget {
  const OutgoingBubble({super.key, required this.message, required this.onRetry});

  final OutgoingMessage message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text, style: text.bodyMedium),
            if (message.failed)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ChatTexts.notSent, style: text.labelSmall?.copyWith(color: scheme.error)),
                  TextButton(onPressed: onRetry, child: const Text(ChatTexts.retry)),
                ],
              )
            else
              Text(ChatTexts.sending, style: text.labelSmall),
          ],
        ),
      ),
    );
  }
}
