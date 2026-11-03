import 'package:flutter/material.dart';

import '../../../models/ui/timeline_entry.dart';
import '../../../utilities/time/dates.dart';
import '../../../utilities/ui/tone_palette.dart';
import '../motion/fade_slide_in.dart';
import 'timeline_marker.dart';

/// Vertical steps joined by a line; finished steps are filled, the next ones dashed.
class Timeline extends StatelessWidget {
  const Timeline({super.key, required this.entries});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          FadeSlideIn(
            index: i,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      TimelineMarker(entry: entries[i]),
                      if (i < entries.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: entries[i].done
                                ? toneColors(entries[i].tone, scheme).solid
                                : scheme.outlineVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entries[i].title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: entries[i].done ? null : scheme.onSurfaceVariant,
                            ),
                          ),
                          if (entries[i].detail != null)
                            Text(entries[i].detail!, style: theme.textTheme.bodySmall),
                          if (entries[i].at != null)
                            Text(
                              shortDateTime(entries[i].at!),
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
