import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/chat_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_receipt.dart';
import '../../models/chat/conversation.dart';
import '../core/service_providers.dart';

/// The member's conversations, newest activity first, kept current from the live channel.
class ChatConversationsController extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() => _fetch();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<List<Conversation>> _fetch() async {
    final page = await ref
        .read(chatServiceProvider)
        .conversations(const PageRequest(page: 0, pageSize: ChatConstants.pageSize));
    return page.items;
  }

  /// A new message: bumps the conversation to the top and counts it unless it is mine or the thread is open.
  void applyMessage(ChatMessage message, {required bool isOpen}) {
    final current = state.value;
    if (current == null) return;
    final index = current.indexWhere((c) => c.id == message.conversationId);
    if (index < 0) {
      ref.invalidateSelf();
      return;
    }
    final conversation = current[index];
    final fromOther = message.senderId != conversation.myUserId;
    final updated = conversation.copyWith(
      lastSequence: message.sequence > conversation.lastSequence ? message.sequence : conversation.lastSequence,
      lastMessageAt: message.createdAt,
      unreadCount: conversation.unreadCount + (fromOther && !isOpen ? 1 : 0),
    );
    state = AsyncData([updated, ...current.where((c) => c.id != conversation.id)]);
  }

  void markRead(String conversationId, int sequence) {
    _update(conversationId, (c) => c.copyWith(lastReadSequence: sequence, unreadCount: 0));
  }

  void applyReceipt(String conversationId, ChatReceipt receipt) {
    _update(
      conversationId,
      (c) => c.copyWith(
        participants: [
          for (final p in c.participants)
            if (p.userId == receipt.userId)
              p.copyWith(
                lastReadSequence: receipt.readSequence > p.lastReadSequence ? receipt.readSequence : p.lastReadSequence,
                lastDeliveredSequence: receipt.deliveredSequence > p.lastDeliveredSequence
                    ? receipt.deliveredSequence
                    : p.lastDeliveredSequence,
              )
            else
              p,
        ],
      ),
    );
  }

  void _update(String id, Conversation Function(Conversation) change) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([for (final c in current) c.id == id ? change(c) : c]);
  }
}

final chatConversationsProvider = AsyncNotifierProvider<ChatConversationsController, List<Conversation>>(
  ChatConversationsController.new,
);

final chatUnreadTotalProvider = Provider<int>((ref) {
  final conversations = ref.watch(chatConversationsProvider).value ?? const <Conversation>[];
  return conversations.fold(0, (total, c) => total + c.unreadCount);
});
