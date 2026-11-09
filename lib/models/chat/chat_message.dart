import 'reply_preview.dart';

/// Server MessageDto: a deleted message keeps its place with no text. clientKey ties it to the sender's retry.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sequence,
    required this.senderId,
    required this.text,
    required this.replyTo,
    required this.edited,
    required this.deleted,
    required this.createdAt,
    required this.clientKey,
    required this.attachmentCount,
  });

  final String id;
  final String conversationId;
  final int sequence;
  final String senderId;
  final String? text;
  final ReplyPreview? replyTo;
  final bool edited;
  final bool deleted;
  final DateTime createdAt;
  final String clientKey;
  final int attachmentCount;

  ChatMessage asDeleted() => ChatMessage(
    id: id,
    conversationId: conversationId,
    sequence: sequence,
    senderId: senderId,
    text: null,
    replyTo: null,
    edited: false,
    deleted: true,
    createdAt: createdAt,
    clientKey: clientKey,
    attachmentCount: 0,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    conversationId: json['conversationId'] as String,
    sequence: (json['sequence'] as num).toInt(),
    senderId: json['senderId'] as String,
    text: json['text'] as String?,
    replyTo: json['replyTo'] == null ? null : ReplyPreview.fromJson(json['replyTo'] as Map<String, dynamic>),
    edited: json['edited'] as bool,
    deleted: json['deleted'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
    clientKey: json['clientKey'] as String,
    attachmentCount: (json['attachments'] as List<dynamic>).length,
  );
}
