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
    final olderCount = thread.hasOlder ? 1 : 0;
    final messageCount = thread.messages.length;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: olderCount + messageCount + thread.outgoing.length,
      itemBuilder: (_, index) {
        if (index < olderCount) {
          return TextButton(onPressed: controller.loadOlder, child: const Text(ChatTexts.loadOlder));
        }
        final position = index - olderCount;
        if (position >= messageCount) {
          final outgoing = thread.outgoing[position - messageCount];
          return OutgoingBubble(message: outgoing, onRetry: () => controller.retry(outgoing));
        }
        final message = thread.messages[position];
        return MessageBubble(
          message: message,
          mine: message.senderId == myUserId,
          receipt: conversation == null ? ReceiptState.sent : receiptStateOf(message, conversation!),
          onReply: () => controller.setReplyTo(message),
        );
      },
    );
  }
}
