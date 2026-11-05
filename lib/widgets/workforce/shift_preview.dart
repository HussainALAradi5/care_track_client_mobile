import 'package:flutter/material.dart';

import '../../constants/motion.dart';
import '../../constants/texts/shift_texts.dart';
import '../../utilities/time/dates.dart';

/// The new shift as it will be saved, or a warning when its start has already passed.
class ShiftPreview extends StatelessWidget {
  const ShiftPreview({super.key, required this.startsAt, required this.endsAt, required this.inPast});

  final DateTime startsAt;
  final DateTime endsAt;
  final bool inPast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = inPast ? scheme.onErrorContainer : scheme.onSecondaryContainer;
    return AnimatedContainer(
      duration: Motion.medium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: inPast ? scheme.errorContainer : scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(inPast ? Icons.error_outline_rounded : Icons.event_rounded, size: 20, color: foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              inPast ? ShiftTexts.inPast : '${ShiftTexts.preview}: ${visitTime(startsAt, endsAt)}',
              style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
