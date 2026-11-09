import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_conversations_controller.dart';
import '../../controllers/chat/chat_live_controller.dart';
import '../../controllers/chat/chat_thread_controller.dart';
import '../../controllers/chat/chat_typing_controller.dart';
import '../../controllers/chat/chat_uploads_controller.dart';
import '../../enums/chat/thread_menu_action.dart';
import '../../models/chat/conversation.dart';
import '../../widgets/chat/chat_action.dart';
import '../../widgets/chat/composer.dart';
import '../../widgets/chat/presence_dot.dart';
import '../../widgets/chat/reply_banner.dart';
import '../../widgets/chat/thread_menu.dart';
import '../../widgets/chat/thread_messages.dart';
import '../../widgets/chat/typing_indicator.dart';
import '../../widgets/chat/upload_tray.dart';

/// One conversation: its messages, what is being sent, who is typing, and the composer. Long-press a message for its
/// actions.
class ChatThreadScreen extends ConsumerWidget {
  const ChatThreadScreen({super.key, required this.conversationId});

  final String conversationId;

  void _menu(BuildContext context, WidgetRef ref, ThreadMenuAction action, Conversation conversation) {
    final conversations = ref.read(chatConversationsProvider.notifier);
    switch (action) {
      case ThreadMenuAction.mute:
        runChatAction(context, () => conversations.toggleMute(conversation));
      case ThreadMenuAction.hide:
        runChatAction(context, () async {
          await conversations.hide(conversation);
          if (context.mounted) context.pop();
        });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatLiveProvider);
    final thread = ref.watch(chatThreadProvider(conversationId));
    final controller = ref.read(chatThreadProvider(conversationId).notifier);
    final typing = ref.watch(chatTypingProvider(conversationId));
    final typingNotifier = ref.read(chatTypingProvider(conversationId).notifier);
    final uploads = ref.watch(chatUploadsProvider(conversationId));
    final uploader = ref.read(chatUploadsProvider(conversationId).notifier);
    final conversations = ref.watch(chatConversationsProvider).value?.items ?? const <Conversation>[];
    final conversation = conversations.where((c) => c.id == conversationId).firstOrNull;
    final ready = uploads.where((u) => u.assetId != null).toList();
    final typingNames = [
      for (final p in conversation?.participants ?? const [])
        if (typing.contains(p.userId)) p.name as String,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (conversation != null) ...[
              PresenceDot(online: conversation.otherOnline),
              const SizedBox(width: AppSpacing.small),
            ],
            Flexible(child: Text(conversation?.title ?? ChatTexts.title)),
          ],
        ),
        actions: [
          if (conversation != null)
            ThreadMenu(conversation: conversation, onSelected: (a) => _menu(context, ref, a, conversation)),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ThreadMessages(thread: thread, conversation: conversation, controller: controller)),
          if (typingNames.isNotEmpty) TypingIndicator(names: typingNames),
          if (thread.replyTo != null)
            ReplyBanner(quoted: thread.replyTo!.text ?? '', onCancel: () => controller.setReplyTo(null)),
          if (uploads.isNotEmpty) UploadTray(uploads: uploads, onRemove: uploader.remove),
          Composer(
            editingText: thread.editing?.text,
            canSendEmpty: ready.isNotEmpty,
            blocked: uploads.any((u) => u.isBusy),
            onChanged: typingNotifier.onDraftChanged,
            onAttach: () => runChatAction(context, uploader.pickAndUpload),
            onSend: (text) {
              typingNotifier.stop();
              if (thread.editing != null) {
                runChatAction(context, () => controller.edit(thread.editing!, text));
              } else {
                controller.send(text, attachmentIds: [for (final u in ready) u.assetId!]);
                uploader.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
