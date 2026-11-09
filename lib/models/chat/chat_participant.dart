/// Server ParticipantDto: a member as the other members see them; inactive once they no longer belong to the Hospital.
class ChatParticipant {
  const ChatParticipant({
    required this.userId,
    required this.name,
    required this.lastReadSequence,
    required this.lastDeliveredSequence,
    required this.active,
    required this.online,
  });

  final String userId;
  final String name;
  final int lastReadSequence;
  final int lastDeliveredSequence;
  final bool active;
  final bool online;

  ChatParticipant copyWith({int? lastReadSequence, int? lastDeliveredSequence, bool? online}) => ChatParticipant(
    userId: userId,
    name: name,
    lastReadSequence: lastReadSequence ?? this.lastReadSequence,
    lastDeliveredSequence: lastDeliveredSequence ?? this.lastDeliveredSequence,
    active: active,
    online: online ?? this.online,
  );

  factory ChatParticipant.fromJson(Map<String, dynamic> json) => ChatParticipant(
    userId: json['userId'] as String,
    name: json['name'] as String,
    lastReadSequence: (json['lastReadSequence'] as num).toInt(),
    lastDeliveredSequence: (json['lastDeliveredSequence'] as num).toInt(),
    active: json['active'] as bool,
    online: json['online'] as bool,
  );
}
