import '../../enums/chat/conversation_kind.dart';
import 'chat_participant.dart';

/// Server ConversationDto, for the signed-in member: it never carries message text.
class Conversation {
  const Conversation({
    required this.id,
    required this.kind,
    required this.lastSequence,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.lastReadSequence,
    required this.myUserId,
    required this.participants,
    this.muted = false,
  });

  final String id;
  final ConversationKind kind;
  final int lastSequence;
  final DateTime lastMessageAt;
  final int unreadCount;
  final int lastReadSequence;
  final String myUserId;
  final List<ChatParticipant> participants;
  final bool muted;

  /// Whether anyone else in the conversation is online now.
  bool get otherOnline => participants.any((p) => p.userId != myUserId && p.online);

  /// The other person's name, which is what the conversation is called for this member.
  String get title {
    for (final participant in participants) {
      if (participant.userId != myUserId) return participant.name;
    }
    return '';
  }

  Conversation copyWith({
    int? lastSequence,
    DateTime? lastMessageAt,
    int? unreadCount,
    int? lastReadSequence,
    List<ChatParticipant>? participants,
    bool? muted,
  }) => Conversation(
    id: id,
    kind: kind,
    lastSequence: lastSequence ?? this.lastSequence,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    unreadCount: unreadCount ?? this.unreadCount,
    lastReadSequence: lastReadSequence ?? this.lastReadSequence,
    myUserId: myUserId,
    participants: participants ?? this.participants,
    muted: muted ?? this.muted,
  );

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json['id'] as String,
    kind: ConversationKind.fromWire(json['kind'] as String),
    lastSequence: (json['lastSequence'] as num).toInt(),
    lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
    unreadCount: (json['unreadCount'] as num).toInt(),
    lastReadSequence: (json['lastReadSequence'] as num).toInt(),
    myUserId: json['myUserId'] as String,
    participants: (json['participants'] as List<dynamic>)
        .map((p) => ChatParticipant.fromJson(p as Map<String, dynamic>))
        .toList(),
    muted: json['muted'] as bool,
  );
}
