import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;

import '../../constants/chat_constants.dart';
import '../../constants/realtime.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/outgoing_message.dart';
import '../../utilities/chat/client_key.dart';
import '../../utilities/chat/message_order.dart';
import '../core/service_providers.dart';

/// A thread's optimistic sending: the copy shown at once, live delivery with a REST fallback, retry, and settling.
mixin ChatThreadSending on Notifier<ChatThreadState> {
  KeepAliveLink? _hold;
  final _ackTimers = <String, Timer>{};

  String get conversationId;

  /// The newest message counts as read when the thread is being looked at.
  void reportSeen();

  /// Called from each build: nothing is held yet, and the timers end with the provider.
  void startSending() {
    _hold = null;
    ref.onDispose(_cancelAckTimers);
  }

  void setReplyTo(ChatMessage? message) => state = state.copyWith(replyTo: () => message);

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

  /// A confirmed or live message: replaces its optimistic copy, once, wherever it came from.
  void applyNew(ChatMessage message) {
    _ackTimers.remove(message.clientKey)?.cancel();
    state = state.copyWith(
      messages: orderedMessages([...state.messages.where((m) => m.id != message.id), message]),
      outgoing: state.outgoing.where((o) => o.clientKey != message.clientKey).toList(),
    );
    _syncHold();
    reportSeen();
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
}
