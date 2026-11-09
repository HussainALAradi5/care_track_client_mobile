import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../models/chat/reaction_group.dart';

/// The reactions under a message; tapping one takes it back or adds it.
class ReactionChips extends StatelessWidget {
  const ReactionChips({super.key, required this.groups, required this.onTap});

  final List<ReactionGroup> groups;
  final ValueChanged<ReactionGroup> onTap;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.tiny,
    children: [
      for (final g in groups)
        ActionChip(
          visualDensity: VisualDensity.compact,
          label: Text('${g.emoji} ${g.count}'),
          side: g.mine ? BorderSide(color: Theme.of(context).colorScheme.primary) : null,
          onPressed: () => onTap(g),
        ),
    ],
  );
}
