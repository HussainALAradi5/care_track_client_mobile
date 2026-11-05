import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/motion.dart';
import '../../models/care/time_slot.dart';

/// One start time; past times are struck through and disabled, the chosen one grows and fills.
class SlotChip extends StatelessWidget {
  const SlotChip({super.key, required this.slot, required this.selected, required this.onTap});

  final TimeSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: Motion.fast,
      child: ChoiceChip(
        label: Text(
          DateFormat.Hm().format(slot.startsAt),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: slot.past ? TextDecoration.lineThrough : null,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        selected: selected,
        showCheckmark: false,
        selectedColor: scheme.primary,
        labelStyle: TextStyle(color: selected ? scheme.onPrimary : null),
        onSelected: slot.past ? null : (_) => onTap(),
      ),
    );
  }
}
