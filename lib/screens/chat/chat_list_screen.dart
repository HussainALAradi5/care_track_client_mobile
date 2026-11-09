import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_conversations_controller.dart';
import '../../controllers/chat/chat_live_controller.dart';
import '../../models/chat/conversation.dart';
import '../../widgets/chat/conversation_tile.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';

/// The member's conversations, newest activity first, live while open.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatLiveProvider);
    final controller = ref.read(chatConversationsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text(ChatTexts.title)),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: AsyncBody<List<Conversation>>(
          value: ref.watch(chatConversationsProvider),
          onRetry: controller.refresh,
          data: (conversations) => conversations.isEmpty
              ? ListView(
                  children: const [
                    EmptyState(icon: Icons.forum_outlined, title: ChatTexts.empty, hint: ChatTexts.emptyHint),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: conversations.length,
                  itemBuilder: (_, index) => ConversationTile(
                    conversation: conversations[index],
                    onTap: () => context.push(RoutePaths.chatThread(conversations[index].id)),
                  ),
                ),
        ),
      ),
    );
  }
}
