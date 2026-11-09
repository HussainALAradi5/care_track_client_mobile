import '../../enums/chat/chat_attachment_status.dart';

/// Server ChatAttachmentDto: status QUARANTINED means it cannot be downloaded yet.
class ChatAttachment {
  const ChatAttachment({required this.assetId, required this.contentType, required this.sizeBytes, required this.status});

  final String assetId;
  final String contentType;
  final int sizeBytes;
  final ChatAttachmentStatus status;

  factory ChatAttachment.fromJson(Map<String, dynamic> json) => ChatAttachment(
    assetId: json['assetId'] as String,
    contentType: json['contentType'] as String,
    sizeBytes: (json['sizeBytes'] as num).toInt(),
    status: ChatAttachmentStatus.fromWire(json['status'] as String),
  );
}
