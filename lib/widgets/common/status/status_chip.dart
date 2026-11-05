import 'package:flutter/material.dart';

import '../../../models/ui/status_style.dart';
import '../../../utilities/ui/tone_palette.dart';
import 'pulse_dot.dart';

/// Pill with icon (or a pulsing dot for waiting states) and label in its tone's colours.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.live = false});

  final StatusStyle status;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final colors = toneColors(status.tone, Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (live) PulseDot(color: colors.solid) else Icon(status.icon, size: 15, color: colors.foreground),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(color: colors.foreground, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
