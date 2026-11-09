/// Server MessageEditDto: one earlier version of a message.
class MessageEdit {
  const MessageEdit({required this.previousText, required this.editedAt});

  final String? previousText;
  final DateTime editedAt;

  factory MessageEdit.fromJson(Map<String, dynamic> json) => MessageEdit(
    previousText: json['previousText'] as String?,
    editedAt: DateTime.parse(json['editedAt'] as String),
  );
}
