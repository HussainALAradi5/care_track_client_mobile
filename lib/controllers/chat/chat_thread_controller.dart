import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/outgoing_message.dart';
import '../../utilities/chat/client_key.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import 'chat_conversations_controller.dart';

/// One open thread: pages of messages, optimistic sending with retry, replies, and the frames that reach it live.
class ChatThreadController extends Notifier<ChatThreadState> {
  ChatThreadController(this.conversationId);

  final String conversationId;

  @override
  ChatThreadState build() {
    if (ref.watch(signedInUserIdProvider) == null) return const ChatThreadState(loading: false);
    Future.microtask(load);
    return const ChatThreadState();
  }

  Future<void> load() async {
    try {
      final page = await ref.read(chatServiceProvider).messages(conversationId);
      state = state.copyWith(
        messages: _ordered(page.items),
        loading: false,
        failed: false,
        hasOlder: page.hasMore,
        nextBefore: () => page.nextBefore,
      );
      _reportSeen();
    } catch (_) {
      state = state.copyWith(loading: false, failed: true);
    }
  }

  Future<void> loadOlder() async {
    final before = state.nextBefore;
    if (before == null || !state.hasOlder) return;
    final page = await ref.read(chatServiceProvider).messages(conversationId, before: before);
    state = state.copyWith(
      messages: _ordered([...state.messages, ...page.items]),
      hasOlder: page.hasMore,
      nextBefore: () => page.nextBefore,
    );
  }

  void setReplyTo(ChatMessage? message) => state = state.copyWith(replyTo: () => message);

  /// Shows the message at once and sends it over REST with a key the server uses to refuse duplicates.
  Future<void> send(String text) async {
    final reply = state.replyTo;
    final outgoing = OutgoingMessage(
      clientKey: generateClientKey(),
      text: text,
      replyToId: reply?.id,
      replyText: reply?.text,
    );
    state = state.copyWith(outgoing: [...state.outgoing, outgoing], replyTo: () => null);
    await _deliver(outgoing);
  }

  Future<void> retry(OutgoingMessage message) async {
    state = state.copyWith(
      outgoing: [for (final o in state.outgoing) o.clientKey == message.clientKey ? o.copyWith(failed: false) : o],
    );
    await _deliver(message);
  }

  Future<void> _deliver(OutgoingMessage message) async {
    try {
      final sent = await ref
          .read(chatServiceProvider)
          .send(conversationId, text: message.text, clientKey: message.clientKey, replyToId: message.replyToId);
      applyNew(sent);
    } catch (_) {
      state = state.copyWith(
        outgoing: [for (final o in state.outgoing) o.clientKey == message.clientKey ? o.copyWith(failed: true) : o],
      );
    }
  }

  /// A confirmed or live message: replaces its optimistic copy, once, wherever it came from.
  void applyNew(ChatMessage message) {
    state = state.copyWith(
      messages: _ordered([...state.messages.where((m) => m.id != message.id), message]),
      outgoing: state.outgoing.where((o) => o.clientKey != message.clientKey).toList(),
    );
    _reportSeen();
  }

  void applyEdited(ChatMessage message) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == message.id ? message : m]);
  }

  void applyDeleted(String messageId) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == messageId ? m.asDeleted() : m]);
  }

  /// The thread is open and reaching the screen: the newest message counts as read.
  void _reportSeen() {
    if (state.messages.isEmpty) return;
    final newest = state.messages.last.sequence;
    ref.read(chatConversationsProvider.notifier).markRead(conversationId, newest);
    ref.read(chatServiceProvider).markRead(conversationId, newest).catchError((_) {});
  }

  static List<ChatMessage> _ordered(List<ChatMessage> messages) =>
      ([...messages]..sort((a, b) => a.sequence.compareTo(b.sequence)));
}

final chatThreadProvider = NotifierProvider.autoDispose.family<ChatThreadController, ChatThreadState, String>(
  ChatThreadController.new,
);
