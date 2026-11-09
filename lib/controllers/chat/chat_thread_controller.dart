import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;

import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/outgoing_message.dart';
import '../../utilities/chat/client_key.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import '../ui/app_foreground_controller.dart';
import 'chat_conversations_controller.dart';

/// One open thread: pages of messages, optimistic sending with retry, replies, and the frames that reach it live.
class ChatThreadController extends Notifier<ChatThreadState> {
  ChatThreadController(this.conversationId);

  final String conversationId;
  KeepAliveLink? _hold;
  bool _onScreen = true;

  /// Whether someone is looking at this thread; it can stay alive without that while a send settles.
  bool get isOnScreen => _onScreen;

  @override
  ChatThreadState build() {
    _hold = null;
    _onScreen = true;
    if (ref.watch(signedInUserIdProvider) == null) return const ChatThreadState(loading: false);
    ref.onCancel(() => _onScreen = false);
    ref.onResume(() {
      _onScreen = true;
      reload();
    });
    ref.listen(appForegroundProvider, (_, foreground) {
      if (foreground) _reportSeen();
    });
    final open = ref.read(openChatThreadsProvider)..add(conversationId);
    ref.onDispose(() => open.remove(conversationId));
    Future.microtask(load);
    return const ChatThreadState();
  }

  Future<void> load() async {
    try {
      final page = await ref.read(chatServiceProvider).messages(conversationId);
      if (!ref.mounted) return;
      state = state.copyWith(
        messages: _ordered(page.items),
        loading: false,
        failed: false,
        hasOlder: page.hasMore,
        nextBefore: () => page.nextBefore,
      );
      _reportSeen();
    } catch (_) {
      if (ref.mounted) state = state.copyWith(loading: false, failed: true);
    }
  }

  /// The newest page again after the channel dropped: what is on screen stays, and only what was missed comes in.
  Future<void> reload() async {
    try {
      final page = await ref.read(chatServiceProvider).messages(conversationId);
      if (!ref.mounted) return;
      final newestShown = state.messages.isEmpty ? 0 : state.messages.last.sequence;
      final oldestOfPage = page.items.isEmpty ? newestShown : page.items.map((m) => m.sequence).reduce(min);
      final leavesGap = page.hasMore && oldestOfPage > newestShown + 1;
      state = leavesGap || state.messages.isEmpty
          ? state.copyWith(
              messages: _ordered(page.items),
              loading: false,
              failed: false,
              hasOlder: page.hasMore,
              nextBefore: () => page.nextBefore,
            )
          : state.copyWith(messages: _merge(state.messages, page.items), loading: false, failed: false);
      _reportSeen();
    } catch (_) {
      // What is on screen stays; the next reconnect or opening the thread reads it again.
    }
  }

  Future<void> loadOlder() async {
    final before = state.nextBefore;
    if (before == null || !state.hasOlder) return;
    final page = await ref.read(chatServiceProvider).messages(conversationId, before: before);
    state = state.copyWith(
      messages: _merge(state.messages, page.items),
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
    _syncHold();
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
      if (ref.mounted) applyNew(sent);
    } catch (_) {
      if (!ref.mounted) return;
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
    _syncHold();
    _reportSeen();
  }

  void applyEdited(ChatMessage message) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == message.id ? message : m]);
  }

  void applyDeleted(String messageId) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == messageId ? m.asDeleted() : m]);
  }

  /// Stays alive while anything is unsettled, so leaving the screen cannot lose a failed send or strand one in flight.
  void _syncHold() {
    if (state.outgoing.isEmpty) {
      _hold?.close();
      _hold = null;
    } else {
      _hold ??= ref.keepAlive();
    }
  }

  /// The thread is open and the app is on screen: the newest message counts as read, and only then.
  void _reportSeen() {
    if (state.messages.isEmpty || !_onScreen || !ref.read(appForegroundProvider)) return;
    final newest = state.messages.last.sequence;
    ref.read(chatConversationsProvider.notifier).markRead(conversationId, newest);
    ref.read(chatServiceProvider).markRead(conversationId, newest).catchError((_) {});
  }

  static List<ChatMessage> _ordered(List<ChatMessage> messages) =>
      ([...messages]..sort((a, b) => a.sequence.compareTo(b.sequence)));

  /// A page joined to what is held; the page wins for a message in both, since it is the newer copy.
  static List<ChatMessage> _merge(List<ChatMessage> held, List<ChatMessage> page) =>
      _ordered([...{for (final m in [...held, ...page]) m.id: m}.values]);
}

/// Conversations with a thread controller alive, for what must reach all of them at once, such as a reconnect.
final openChatThreadsProvider = Provider<Set<String>>((ref) => <String>{});

final chatThreadProvider = NotifierProvider.autoDispose.family<ChatThreadController, ChatThreadState, String>(
  ChatThreadController.new,
);
