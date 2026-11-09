import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;

import '../../constants/chat_constants.dart';
import '../../constants/realtime.dart';
import '../../models/chat/chat_attachment.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_reaction.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/message_history.dart';
import '../../models/chat/outgoing_message.dart';
import '../../utilities/chat/attachment_files.dart';
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
  bool _loadingOlder = false;
  final _ackTimers = <String, Timer>{};

  /// Whether someone is looking at this thread; it can stay alive without that while a send settles.
  bool get isOnScreen => _onScreen;

  @override
  ChatThreadState build() {
    _hold = null;
    _onScreen = true;
    ref.onDispose(_cancelAckTimers);
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
    if (_loadingOlder || before == null || !state.hasOlder) return;
    _loadingOlder = true;
    try {
      final page = await ref.read(chatServiceProvider).messages(conversationId, before: before);
      if (!ref.mounted) return;
      state = state.copyWith(
        messages: _merge(state.messages, page.items),
        hasOlder: page.hasMore,
        nextBefore: () => page.nextBefore,
      );
    } catch (_) {
      // Nothing changes on screen and the button stays, so the same page can be tried again.
    } finally {
      _loadingOlder = false;
    }
  }

  void setReplyTo(ChatMessage? message) => state = state.copyWith(replyTo: () => message);

  void setEditing(ChatMessage? message) => state = state.copyWith(editing: () => message);

  /// Shows the message at once and sends it live, or over REST when the channel is down or no echo comes back. The
  /// server's key check means none of this can duplicate.
  Future<void> send(String text, {List<String> attachmentIds = const []}) async {
    final reply = state.replyTo;
    final outgoing = OutgoingMessage(
      clientKey: generateClientKey(),
      text: text,
      replyToId: reply?.id,
      replyText: reply?.text,
      attachmentIds: attachmentIds,
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
    final sentLive = ref.read(realtimeChannelProvider).publish(Realtime.chatSend, {
      'conversationId': conversationId,
      'clientKey': message.clientKey,
      ...message.toPayload(),
    });
    if (!sentLive) return _sendOverRest(message);
    _ackTimers[message.clientKey] = Timer(ChatConstants.ackTimeout, () {
      _ackTimers.remove(message.clientKey);
      _sendOverRest(message);
    });
  }

  Future<void> _sendOverRest(OutgoingMessage message) async {
    if (!ref.mounted) return;
    try {
      final sent = await ref
          .read(chatServiceProvider)
          .send(conversationId, body: message.toPayload(), clientKey: message.clientKey);
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
    _ackTimers.remove(message.clientKey)?.cancel();
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

  void applyReaction(String messageId, List<ChatReaction> reactions) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == messageId ? m.withReactions(reactions) : m]);
  }

  /// Live when the channel is up, in which case the frame brings the change back; over REST otherwise.
  Future<void> edit(ChatMessage message, String text) async {
    setEditing(null);
    final body = {'conversationId': conversationId, 'messageId': message.id, 'text': text};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatEdit, body)) return;
    applyEdited(await ref.read(chatServiceProvider).edit(conversationId, message.id, text));
  }

  Future<void> remove(ChatMessage message) async {
    final body = {'conversationId': conversationId, 'messageId': message.id};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatDelete, body)) return;
    await ref.read(chatServiceProvider).delete(conversationId, message.id);
    applyDeleted(message.id);
  }

  Future<void> react(ChatMessage message, String? emoji) async {
    final body = {'conversationId': conversationId, 'messageId': message.id, 'emoji': emoji};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatReact, body)) return;
    applyReaction(message.id, await ref.read(chatServiceProvider).react(conversationId, message.id, emoji));
  }

  Future<void> toggleHistory(ChatMessage message) async {
    if (state.history?.messageId == message.id) {
      state = state.copyWith(history: () => null);
      return;
    }
    final edits = await ref.read(chatServiceProvider).history(conversationId, message.id);
    if (ref.mounted) state = state.copyWith(history: () => MessageHistory(messageId: message.id, edits: edits));
  }

  /// Saves an available file; the server answers 409 MEDIA_UNAVAILABLE until a file check has passed it.
  Future<void> download(ChatAttachment attachment) async {
    final bytes = await ref.read(chatServiceProvider).download(conversationId, attachment.assetId);
    await ref.read(fileAccessProvider).save(downloadName(attachment.assetId, attachment.contentType), bytes);
  }

  void _cancelAckTimers() {
    for (final timer in _ackTimers.values) {
      timer.cancel();
    }
    _ackTimers.clear();
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
