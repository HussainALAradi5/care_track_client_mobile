import '../../models/chat/chat_reaction.dart';
import '../../models/chat/reaction_group.dart';

/// Reactions grouped by emoji, in the order first used.
List<ReactionGroup> groupReactions(List<ChatReaction> reactions, String? myUserId) {
  final groups = <String, ReactionGroup>{};
  for (final r in reactions) {
    final before = groups[r.emoji];
    groups[r.emoji] = ReactionGroup(
      emoji: r.emoji,
      count: (before?.count ?? 0) + 1,
      mine: (before?.mine ?? false) || r.userId == myUserId,
    );
  }
  return groups.values.toList();
}
