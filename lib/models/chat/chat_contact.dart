import '../../enums/chat/conversation_kind.dart';

/// Server ChatContactDto: someone the caller may start a conversation with.
class ChatContact {
  const ChatContact({required this.userId, required this.name, required this.kind});

  final String userId;
  final String name;
  final ConversationKind kind;

  factory ChatContact.fromJson(Map<String, dynamic> json) => ChatContact(
    userId: json['userId'] as String,
    name: json['name'] as String,
    kind: ConversationKind.fromWire(json['kind'] as String),
  );
}
