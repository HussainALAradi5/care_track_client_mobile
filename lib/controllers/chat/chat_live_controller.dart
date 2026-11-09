import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/realtime.dart';
import '../../enums/chat/chat_event_type.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_reaction.dart';
import '../../models/chat/chat_receipt.dart';
import '../../constants/texts/chat_texts.dart';
import '../../utilities/http/error_message.dart';
import '../../models/ui/app_toast.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import '../ui/app_foreground_controller.dart';
import '../ui/app_toast_controller.dart';
import 'chat_conversations_controller.dart';
import 'chat_thread_controller.dart';
import 'chat_typing_controller.dart';

/// Feeds the chat queue into the conversation list and any open thread while someone is signed in.
/// After a reconnect the list and open threads are read again, since messages sent during the gap are gone.
final chatLiveProvider = Provider<void>((ref) {
  final signedIn = ref.watch(authControllerProvider.select((auth) => auth.value != null));
  if (!signedIn) return;
  final channel = ref.read(realtimeChannelProvider);
  final frames = channel.watch(Realtime.chatQueue).listen((frame) => _receive(ref, frame));
  final refusals = channel.watch(Realtime.chatErrorsQueue).listen((frame) => _refused(ref, frame));
  final reconnects = channel.opened.listen((_) {
    ref.invalidate(chatConversationsProvider);
    for (final conversationId in ref.read(openChatThreadsProvider)) {
      final thread = ref.read(chatThreadProvider(conversationId).notifier);
      if (thread.isOnScreen) thread.reload();
    }
  });
  channel.connect();
  ref.onDispose(() {
    frames.cancel();
    refusals.cancel();
    reconnects.cancel();
  });
});

/// The server refused a live action; only its code comes back, so the send's own timeout marks it failed.
void _refused(Ref ref, Map<String, dynamic> frame) {
  final code = frame['code'] as String? ?? '';
  ref.read(appToastProvider.notifier).show(AppToast(message: ChatTexts.errors[code] ?? messageForCode(code)));
}

void _receive(Ref ref, Map<String, dynamic> frame) {
  final type = ChatEventType.fromWire(frame['type'] as String);
  final conversationId = frame['conversationId'] as String?;
  final data = frame['data'];
  if (type == null || data is! Map<String, dynamic>) return;
  // Presence is about a person, not a conversation.
  if (type == ChatEventType.presence) {
    ref.read(chatConversationsProvider.notifier).applyPresence(data['userId'] as String, data['online'] as bool);
    return;
  }
  if (conversationId == null) return;
  final threadProvider = chatThreadProvider(conversationId);
  final thread = ref.exists(threadProvider) ? ref.read(threadProvider.notifier) : null;
  final isOpen = thread != null && thread.isOnScreen && ref.read(appForegroundProvider);
  final conversations = ref.read(chatConversationsProvider.notifier);
  switch (type) {
    case ChatEventType.messageNew:
      _newMessage(ref, ChatMessage.fromJson(data), conversations, thread, isOpen: isOpen);
    case ChatEventType.messageEdited:
      thread?.applyEdited(ChatMessage.fromJson(data));
    case ChatEventType.messageDeleted:
      thread?.applyDeleted(data['messageId'] as String);
    case ChatEventType.receipt:
      conversations.applyReceipt(conversationId, ChatReceipt.fromJson(data));
    case ChatEventType.reaction:
      thread?.applyReaction(data['messageId'] as String, [
        for (final r in data['reactions'] as List<dynamic>) ChatReaction.fromJson(r as Map<String, dynamic>),
      ]);
    case ChatEventType.typing:
      final typingProvider = chatTypingProvider(conversationId);
      if (ref.exists(typingProvider)) {
        ref.read(typingProvider.notifier).applyTyping(data['userId'] as String, data['typing'] as bool);
      }
    case ChatEventType.presence:
      break;
  }
}

void _newMessage(
  Ref ref,
  ChatMessage message,
  ChatConversationsController conversations,
  ChatThreadController? thread, {
  required bool isOpen,
}) {
  conversations.applyMessage(message, isOpen: isOpen);
  thread?.applyNew(message);
  if (!isOpen) ref.read(chatServiceProvider).markDelivered(message.conversationId, message.sequence).catchError((_) {});
}
