import 'chat_message.dart';
import 'outgoing_message.dart';

/// One open thread: its loaded messages (oldest first), what is still being sent, and the reply being written.
class ChatThreadState {
  const ChatThreadState({
    this.messages = const [],
    this.outgoing = const [],
    this.loading = true,
    this.failed = false,
    this.hasOlder = false,
    this.nextBefore,
    this.replyTo,
  });

  final List<ChatMessage> messages;
  final List<OutgoingMessage> outgoing;
  final bool loading;
  final bool failed;
  final bool hasOlder;
  final int? nextBefore;
  final ChatMessage? replyTo;

  ChatThreadState copyWith({
    List<ChatMessage>? messages,
    List<OutgoingMessage>? outgoing,
    bool? loading,
    bool? failed,
    bool? hasOlder,
    int? Function()? nextBefore,
    ChatMessage? Function()? replyTo,
  }) => ChatThreadState(
    messages: messages ?? this.messages,
    outgoing: outgoing ?? this.outgoing,
    loading: loading ?? this.loading,
    failed: failed ?? this.failed,
    hasOlder: hasOlder ?? this.hasOlder,
    nextBefore: nextBefore == null ? this.nextBefore : nextBefore(),
    replyTo: replyTo == null ? this.replyTo : replyTo(),
  );
}
