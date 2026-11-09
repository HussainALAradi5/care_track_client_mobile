/// A message the sender sees at once, before the server has confirmed it.
class OutgoingMessage {
  const OutgoingMessage({
    required this.clientKey,
    required this.text,
    required this.replyToId,
    required this.replyText,
    this.attachmentIds = const [],
    this.failed = false,
  });

  final String clientKey;
  final String text;
  final String? replyToId;
  final String? replyText;
  final List<String> attachmentIds;
  final bool failed;

  /// What the server is sent, over the live channel or REST.
  Map<String, dynamic> toPayload() => {
    'text': text.isEmpty ? null : text,
    'replyToId': replyToId,
    'attachmentIds': attachmentIds,
  };

  OutgoingMessage copyWith({required bool failed}) => OutgoingMessage(
    clientKey: clientKey,
    text: text,
    replyToId: replyToId,
    replyText: replyText,
    attachmentIds: attachmentIds,
    failed: failed,
  );
}
