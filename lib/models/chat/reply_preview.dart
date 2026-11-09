/// The quoted message under a reply; no text once the original is deleted.
class ReplyPreview {
  const ReplyPreview({required this.messageId, required this.text, required this.deleted});

  final String messageId;
  final String? text;
  final bool deleted;

  factory ReplyPreview.fromJson(Map<String, dynamic> json) => ReplyPreview(
    messageId: json['messageId'] as String,
    text: json['text'] as String?,
    deleted: json['deleted'] as bool,
  );
}
