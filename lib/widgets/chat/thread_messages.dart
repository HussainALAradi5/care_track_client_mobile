import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_thread_controller.dart';
import '../../enums/chat/receipt_state.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/conversation.dart';
import '../../utilities/chat/reactions.dart';
import '../../utilities/chat/receipt_state_of.dart';
import 'chat_action.dart';
import 'message_actions_sheet.dart';
import 'message_bubble.dart';
import 'outgoing_bubble.dart';

/// The loaded messages of a thread, oldest first, then whatever is still being sent.
class ThreadMessages extends StatelessWidget {
  const ThreadMessages({super.key, required this.thread, required this.conversation, required this.controller});

  final ChatThreadState thread;
  final Conversation? conversation;
  final ChatThreadController controller;

  Widget _bubble(BuildContext context, ChatMessage message) {
    final myUserId = conversation?.myUserId;
    final mine = message.senderId == myUserId;
    final history = thread.history?.messageId == message.id ? thread.history : null;
    return MessageBubble(
      message: message,
      mine: mine,
      receipt: conversation == null ? ReceiptState.sent : receiptStateOf(message, conversation!),
      reactions: groupReactions(message.reactions, myUserId),
      history: history,
      onLongPress: () => showMessageActions(
        context,
        message: message,
        mine: mine,
        myReaction: message.reactions.where((r) => r.userId == myUserId).firstOrNull?.emoji,
        controller: controller,
      ),
      onReact: (group) => runChatAction(context, () => controller.react(message, group.mine ? null : group.emoji)),
      onToggleHistory: () => runChatAction(context, () => controller.toggleHistory(message)),
      onDownload: (attachment) => runChatAction(context, () => controller.download(attachment)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (thread.loading) return const Center(child: CircularProgressIndicator());
    if (thread.failed) return const Center(child: Text(ChatTexts.loadFailed));
    final olderCount = thread.hasOlder ? 1 : 0;
    final messageCount = thread.messages.length;
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: olderCount + messageCount + thread.outgoing.length,
      itemBuilder: (context, index) {
        if (index < olderCount) {
          return TextButton(onPressed: controller.loadOlder, child: const Text(ChatTexts.loadOlder));
        }
        final position = index - olderCount;
        if (position >= messageCount) {
          final outgoing = thread.outgoing[position - messageCount];
          return OutgoingBubble(message: outgoing, onRetry: () => controller.retry(outgoing));
        }
        return _bubble(context, thread.messages[position]);
      },
    );
  }
}
