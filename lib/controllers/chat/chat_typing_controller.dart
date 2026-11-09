import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/chat_constants.dart';
import '../../constants/realtime.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// Typing in one thread: who else is typing now (an indicator with no refresh goes away), and telling the others.
class ChatTypingController extends Notifier<Set<String>> {
  ChatTypingController(this.conversationId);

  final String conversationId;
  final _displayTimers = <String, Timer>{};
  Timer? _idle;
  DateTime? _lastSentAt;

  @override
  Set<String> build() {
    ref.onDispose(_cancelTimers);
    ref.watch(signedInUserIdProvider);
    return const {};
  }

  void _cancelTimers() {
    for (final timer in _displayTimers.values) {
      timer.cancel();
    }
    _displayTimers.clear();
    _idle?.cancel();
    _idle = null;
  }

  /// A live frame: someone started or stopped typing.
  void applyTyping(String userId, bool typing) {
    _displayTimers.remove(userId)?.cancel();
    if (typing) {
      _displayTimers[userId] = Timer(ChatConstants.typingDisplay, () => _setTyping(userId, false));
    }
    _setTyping(userId, typing);
  }

  void _setTyping(String userId, bool typing) {
    if (!ref.mounted) return;
    state = typing ? {...state, userId} : ({...state}..remove(userId));
  }

  /// The draft changed: one frame per throttle window, and "stopped" after a pause.
  void onDraftChanged() {
    final now = DateTime.now();
    if (_lastSentAt == null || now.difference(_lastSentAt!) >= ChatConstants.typingThrottle) {
      _lastSentAt = now;
      _send(true);
    }
    _idle?.cancel();
    _idle = Timer(ChatConstants.typingIdle, stop);
  }

  void stop() {
    _idle?.cancel();
    _idle = null;
    _lastSentAt = null;
    if (ref.mounted) _send(false);
  }

  void _send(bool typing) {
    final sent = ref.read(realtimeChannelProvider).publish(Realtime.chatTyping, {
      'conversationId': conversationId,
      'typing': typing,
    });
    if (!sent) ref.read(chatServiceProvider).typing(conversationId, typing).catchError((_) {});
  }
}

final chatTypingProvider = NotifierProvider.autoDispose.family<ChatTypingController, Set<String>, String>(
  ChatTypingController.new,
);
