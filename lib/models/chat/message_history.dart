import 'message_edit.dart';

/// The earlier versions of the message whose history is open.
class MessageHistory {
  const MessageHistory({required this.messageId, required this.edits});

  final String messageId;
  final List<MessageEdit> edits;
}
