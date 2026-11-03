import 'package:flutter/material.dart';

import '../../../models/ui/timeline_entry.dart';
import '../../../utilities/ui/tone_palette.dart';

const _marker = 32.0;

/// The round icon marker of one timeline step.
class TimelineMarker extends StatelessWidget {
  const TimelineMarker({super.key, required this.entry});

  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = toneColors(entry.tone, scheme);
    return Container(
      width: _marker,
      height: _marker,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: entry.done ? colors.solid : null,
        border: entry.done ? null : Border.all(color: scheme.outline, width: 2),
      ),
      child: Icon(entry.icon, size: 17, color: entry.done ? Colors.white : scheme.onSurfaceVariant),
    );
  }
}
