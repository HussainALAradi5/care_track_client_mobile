/// Server ReactionDto: one member's reaction.
class ChatReaction {
  const ChatReaction({required this.userId, required this.emoji});

  final String userId;
  final String emoji;

  factory ChatReaction.fromJson(Map<String, dynamic> json) =>
      ChatReaction(userId: json['userId'] as String, emoji: json['emoji'] as String);
}
