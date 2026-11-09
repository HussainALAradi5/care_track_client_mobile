import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/chat_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_receipt.dart';
import '../../models/chat/conversation.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The member's conversations, newest activity first, kept current from the live channel.
class ChatConversationsController extends AsyncNotifier<PagedItems<Conversation>> {
  @override
  Future<PagedItems<Conversation>> build() async {
    if (ref.watch(signedInUserIdProvider) == null) {
      return const PagedItems<Conversation>(items: [], nextPage: 0, hasNext: false);
    }
    return _toItems(await _fetch(0), const []);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(_toItems(await _fetch(current.nextPage), current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  Future<PageResult<Conversation>> _fetch(int page) =>
      ref.read(chatServiceProvider).conversations(PageRequest(page: page, pageSize: ChatConstants.pageSize));

  /// A later page joined to what is held; a live bump can shift a row onto the next page, so repeats are dropped.
  PagedItems<Conversation> _toItems(PageResult<Conversation> page, List<Conversation> before) {
    final known = {for (final c in before) c.id};
    return PagedItems(
      items: [...before, ...page.items.where((c) => !known.contains(c.id))],
      nextPage: page.page + 1,
      hasNext: page.hasNext,
    );
  }

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

  /// A conversation just started or changed: put at the top when new, replaced in place otherwise.
  void upsert(Conversation conversation) {
    final current = state.value;
    if (current == null) return;
    final known = current.items.any((c) => c.id == conversation.id);
    state = AsyncData(
      current.copyWith(
        items: known
            ? [for (final c in current.items) c.id == conversation.id ? conversation : c]
            : [conversation, ...current.items],
      ),
    );
  }

  Future<void> toggleMute(Conversation conversation) async =>
      upsert(await ref.read(chatServiceProvider).mute(conversation.id, !conversation.muted));

  /// Hidden from this member's list until something new arrives there.
  Future<void> hide(Conversation conversation) async {
    await ref.read(chatServiceProvider).hide(conversation.id, true);
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(items: current.items.where((c) => c.id != conversation.id).toList()));
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

final chatConversationsProvider = AsyncNotifierProvider<ChatConversationsController, PagedItems<Conversation>>(
  ChatConversationsController.new,
);

final chatUnreadTotalProvider = Provider<int>((ref) {
  final conversations = ref.watch(chatConversationsProvider).value?.items ?? const <Conversation>[];
  return conversations.fold(0, (total, c) => total + c.unreadCount);
});
