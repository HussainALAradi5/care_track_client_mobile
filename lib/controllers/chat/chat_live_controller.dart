import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/realtime.dart';
import '../../enums/chat/chat_event_type.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_receipt.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import 'chat_conversations_controller.dart';
import 'chat_thread_controller.dart';

/// Feeds the chat queue into the conversation list and any open thread while someone is signed in.
/// After a reconnect the list and open threads are read again, since messages sent during the gap are gone.
final chatLiveProvider = Provider<void>((ref) {
  final signedIn = ref.watch(authControllerProvider.select((auth) => auth.value != null));
  if (!signedIn) return;
  final channel = ref.read(realtimeChannelProvider);
  final frames = channel.watch(Realtime.chatQueue).listen((frame) => _receive(ref, frame));
  final reconnects = channel.opened.listen((_) => ref.invalidate(chatConversationsProvider));
  channel.connect();
  ref.onDispose(() {
    frames.cancel();
    reconnects.cancel();
  });
});

void _receive(Ref ref, Map<String, dynamic> frame) {
  final type = ChatEventType.fromWire(frame['type'] as String);
  final conversationId = frame['conversationId'] as String?;
  final data = frame['data'];
  if (type == null || conversationId == null || data is! Map<String, dynamic>) return;
  final isOpen = ref.exists(chatThreadProvider(conversationId));
  final thread = isOpen ? ref.read(chatThreadProvider(conversationId).notifier) : null;
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
    case ChatEventType.reaction || ChatEventType.typing || ChatEventType.presence:
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
