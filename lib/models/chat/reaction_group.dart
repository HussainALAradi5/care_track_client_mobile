/// One emoji under a message with how many chose it and whether the viewer did.
class ReactionGroup {
  const ReactionGroup({required this.emoji, required this.count, required this.mine});

  final String emoji;
  final int count;
  final bool mine;
}
