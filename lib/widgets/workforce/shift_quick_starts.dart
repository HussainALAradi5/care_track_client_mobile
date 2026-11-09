import 'package:flutter/material.dart';

import '../../constants/shift_rules.dart';
import '../../utilities/time/dates.dart';
import '../../utilities/workforce/shift_interval.dart';

/// One-tap usual shift starts (morning, day, evening, night); the chip matching [selected] shows as picked.
class ShiftQuickStarts extends StatelessWidget {
  const ShiftQuickStarts({super.key, required this.selected, required this.onPick});

  final TimeOfDay selected;
  final ValueChanged<TimeOfDay> onPick;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final q in ShiftRules.quickStarts)
        ChoiceChip(
          avatar: Icon(q.icon, size: 18),
          label: Text('${q.label} ${hourMinute(q.time)}'),
          selected: sameTimeOfDay(q.time, selected),
          showCheckmark: false,
          onSelected: (_) => onPick(q.time),
        ),
    ],
  );
}
