import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_conversations_controller.dart';
import '../../controllers/chat/chat_live_controller.dart';
import '../../controllers/chat/chat_thread_controller.dart';
import '../../models/chat/conversation.dart';
import '../../widgets/chat/composer.dart';
import '../../widgets/chat/reply_banner.dart';
import '../../widgets/chat/thread_messages.dart';

/// One conversation: its messages, what is being sent, and the composer. Long-press a message to reply.
class ChatThreadScreen extends ConsumerWidget {
  const ChatThreadScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatLiveProvider);
    final thread = ref.watch(chatThreadProvider(conversationId));
    final controller = ref.read(chatThreadProvider(conversationId).notifier);
    final conversations = ref.watch(chatConversationsProvider).value?.items ?? const <Conversation>[];
    final conversation = conversations.where((c) => c.id == conversationId).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(conversation?.title ?? ChatTexts.title)),
      body: Column(
        children: [
          Expanded(child: ThreadMessages(thread: thread, conversation: conversation, controller: controller)),
          if (thread.replyTo != null)
            ReplyBanner(quoted: thread.replyTo!.text ?? '', onCancel: () => controller.setReplyTo(null)),
          Composer(onSend: controller.send),
        ],
      ),
    );
  }
}
