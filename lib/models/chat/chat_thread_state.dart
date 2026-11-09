import 'chat_message.dart';
import 'message_history.dart';
import 'outgoing_message.dart';

/// One open thread: its loaded messages (oldest first), what is still being sent, the reply or edit being written, and
/// the message whose earlier versions are open.
class ChatThreadState {
  const ChatThreadState({
    this.messages = const [],
    this.outgoing = const [],
    this.loading = true,
    this.failed = false,
    this.hasOlder = false,
    this.nextBefore,
    this.replyTo,
    this.editing,
    this.history,
  });

  final List<ChatMessage> messages;
  final List<OutgoingMessage> outgoing;
  final bool loading;
  final bool failed;
  final bool hasOlder;
  final int? nextBefore;
  final ChatMessage? replyTo;
  final ChatMessage? editing;
  final MessageHistory? history;

  ChatThreadState copyWith({
    List<ChatMessage>? messages,
    List<OutgoingMessage>? outgoing,
    bool? loading,
    bool? failed,
    bool? hasOlder,
    int? Function()? nextBefore,
    ChatMessage? Function()? replyTo,
    ChatMessage? Function()? editing,
    MessageHistory? Function()? history,
  }) => ChatThreadState(
    messages: messages ?? this.messages,
    outgoing: outgoing ?? this.outgoing,
    loading: loading ?? this.loading,
    failed: failed ?? this.failed,
    hasOlder: hasOlder ?? this.hasOlder,
    nextBefore: nextBefore == null ? this.nextBefore : nextBefore(),
    replyTo: replyTo == null ? this.replyTo : replyTo(),
    editing: editing == null ? this.editing : editing(),
    history: history == null ? this.history : history(),
  );
}
