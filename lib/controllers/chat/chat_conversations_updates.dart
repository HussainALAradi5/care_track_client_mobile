import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_receipt.dart';
import '../../models/chat/conversation.dart';
import '../../models/common/paged_items.dart';

/// Keeps the loaded conversations current from what happens elsewhere: live messages, presence, receipts and reads.
mixin ChatConversationsUpdates on AsyncNotifier<PagedItems<Conversation>> {
  /// A new message: bumps the conversation to the top and counts it unless it is mine or the thread is open.
  void applyMessage(ChatMessage message, {required bool isOpen}) {
    final paged = state.value;
    if (paged == null) return;
    final current = paged.items;
    final index = current.indexWhere((c) => c.id == message.conversationId);
    if (index < 0) {
      ref.invalidateSelf();
      return;
    }
    final conversation = current[index];
    // A sequence already seen is a replay, which must not count or move the row twice.
    if (message.sequence <= conversation.lastSequence) return;
    final fromOther = message.senderId != conversation.myUserId;
    final updated = conversation.copyWith(
      lastSequence: message.sequence,
      lastMessageAt: message.createdAt,
      unreadCount: conversation.unreadCount + (fromOther && !isOpen ? 1 : 0),
    );
    state = AsyncData(paged.copyWith(items: [updated, ...current.where((c) => c.id != conversation.id)]));
  }

  /// Someone came online or went offline.
  void applyPresence(String userId, bool online) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [
          for (final c in current.items)
            c.copyWith(participants: [for (final p in c.participants) p.userId == userId ? p.copyWith(online: online) : p]),
        ],
      ),
    );
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
    state = AsyncData(current.copyWith(items: [for (final c in current.items) c.id == id ? change(c) : c]));
  }
}
