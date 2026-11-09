/// A message the sender sees at once, before the server has confirmed it.
class OutgoingMessage {
  const OutgoingMessage({
    required this.clientKey,
    required this.text,
    required this.replyToId,
    required this.replyText,
    this.failed = false,
  });

  final String clientKey;
  final String text;
  final String? replyToId;
  final String? replyText;
  final bool failed;

  OutgoingMessage copyWith({required bool failed}) => OutgoingMessage(
    clientKey: clientKey,
    text: text,
    replyToId: replyToId,
    replyText: replyText,
    failed: failed,
  );
}
