/// Server WrittenDocumentDto; [body] is null in lists.
class WrittenDocument {
  const WrittenDocument({
    required this.id,
    required this.title,
    required this.kind,
    required this.appointmentId,
    required this.hospitalId,
    required this.hospitalName,
    required this.authorName,
    required this.issuedAt,
    this.body,
  });

  final String id;
  final String title;
  final String kind;
  final String appointmentId;
  final String hospitalId;
  final String hospitalName;
  final String authorName;
  final DateTime issuedAt;
  final String? body;

  factory WrittenDocument.fromJson(Map<String, dynamic> json) => WrittenDocument(
    id: json['id'] as String,
    title: json['title'] as String,
    kind: json['kind'] as String,
    appointmentId: json['appointmentId'] as String,
    hospitalId: json['hospitalId'] as String,
    hospitalName: json['hospitalName'] as String,
    authorName: json['authorName'] as String,
    issuedAt: DateTime.parse(json['issuedAt'] as String).toLocal(),
    body: json['body'] as String?,
  );
}
