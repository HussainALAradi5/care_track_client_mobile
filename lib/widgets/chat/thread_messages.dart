import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_thread_controller.dart';
import '../../enums/chat/receipt_state.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/conversation.dart';
import '../../utilities/chat/receipt_state_of.dart';
import 'message_bubble.dart';
import 'outgoing_bubble.dart';

/// The loaded messages of a thread, oldest first, then whatever is still being sent.
class ThreadMessages extends StatelessWidget {
  const ThreadMessages({super.key, required this.thread, required this.conversation, required this.controller});

  final ChatThreadState thread;
  final Conversation? conversation;
  final ChatThreadController controller;

  @override
  Widget build(BuildContext context) {
    if (thread.loading) return const Center(child: CircularProgressIndicator());
    if (thread.failed) return const Center(child: Text(ChatTexts.loadFailed));
    final myUserId = conversation?.myUserId;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (thread.hasOlder) TextButton(onPressed: controller.loadOlder, child: const Text(ChatTexts.loadOlder)),
        for (final message in thread.messages)
          MessageBubble(
            message: message,
            mine: message.senderId == myUserId,
            receipt: conversation == null ? ReceiptState.sent : receiptStateOf(message, conversation!),
            onReply: () => controller.setReplyTo(message),
          ),
        for (final outgoing in thread.outgoing)
          OutgoingBubble(message: outgoing, onRetry: () => controller.retry(outgoing)),
      ],
    );
  }
}
