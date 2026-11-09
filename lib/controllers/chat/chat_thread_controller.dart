import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chat/chat_thread_state.dart';
import '../../utilities/chat/message_order.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import '../ui/app_foreground_controller.dart';
import 'chat_conversations_controller.dart';
import 'chat_thread_actions.dart';
import 'chat_thread_sending.dart';

/// One open thread: its pages of messages and whether it is being read. Sending and per-message actions are mixed in.
class ChatThreadController extends Notifier<ChatThreadState> with ChatThreadSending, ChatThreadActions {
  ChatThreadController(this.conversationId);

  @override
  final String conversationId;
  bool _onScreen = true;
  bool _loadingOlder = false;

  /// Whether someone is looking at this thread; it can stay alive without that while a send settles.
  bool get isOnScreen => _onScreen;

  @override
  ChatThreadState build() {
    startSending();
    _onScreen = true;
    if (ref.watch(signedInUserIdProvider) == null) return const ChatThreadState(loading: false);
    ref.onCancel(() => _onScreen = false);
    ref.onResume(() {
      _onScreen = true;
      reload();
    });
    ref.listen(appForegroundProvider, (_, foreground) {
      if (foreground) reportSeen();
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
        messages: orderedMessages(page.items),
        loading: false,
        failed: false,
        hasOlder: page.hasMore,
        nextBefore: () => page.nextBefore,
      );
      reportSeen();
      _ensureConversation();
    } catch (_) {
      if (ref.mounted) state = state.copyWith(loading: false, failed: true);
    }
  }

  /// A thread opened from outside the loaded list (a deep link) still needs its members, for names and receipts.
  Future<void> _ensureConversation() async {
    final conversations = ref.read(chatConversationsProvider).value;
    if (conversations == null || conversations.items.any((c) => c.id == conversationId)) return;
    try {
      final conversation = await ref.read(chatServiceProvider).conversation(conversationId);
      if (ref.mounted) ref.read(chatConversationsProvider.notifier).upsert(conversation);
    } catch (_) {
      // The thread still works; only names and receipts wait for the next list reload.
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
              messages: orderedMessages(page.items),
              loading: false,
              failed: false,
              hasOlder: page.hasMore,
              nextBefore: () => page.nextBefore,
            )
          : state.copyWith(messages: mergedMessages(state.messages, page.items), loading: false, failed: false);
      reportSeen();
    } catch (_) {
      // What is on screen stays; the next reconnect or opening the thread reads it again.
    }
  }

  Future<void> loadOlder() async {
    final before = state.nextBefore;
    if (_loadingOlder || before == null || !state.hasOlder) return;
    _loadingOlder = true;
    try {
      final page = await ref.read(chatServiceProvider).messages(conversationId, before: before);
      if (!ref.mounted) return;
      state = state.copyWith(
        messages: mergedMessages(state.messages, page.items),
        hasOlder: page.hasMore,
        nextBefore: () => page.nextBefore,
      );
    } catch (_) {
      // Nothing changes on screen and the button stays, so the same page can be tried again.
    } finally {
      _loadingOlder = false;
    }
  }

  /// The thread is open and the app is on screen: the newest message counts as read, and only then.
  @override
  void reportSeen() {
    if (state.messages.isEmpty || !_onScreen || !ref.read(appForegroundProvider)) return;
    final newest = state.messages.last.sequence;
    ref.read(chatConversationsProvider.notifier).markRead(conversationId, newest);
    ref.read(chatServiceProvider).markRead(conversationId, newest).catchError((_) {});
  }
}

/// Conversations with a thread controller alive, for what must reach all of them at once, such as a reconnect.
final openChatThreadsProvider = Provider<Set<String>>((ref) => <String>{});

final chatThreadProvider = NotifierProvider.autoDispose.family<ChatThreadController, ChatThreadState, String>(
  ChatThreadController.new,
);
