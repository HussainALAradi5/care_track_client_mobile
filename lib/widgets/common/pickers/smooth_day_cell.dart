import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/motion.dart';
import '../../../constants/picker_layout.dart';
import '../../../models/ui/range_draft.dart';
import '../../../utilities/time/dates.dart';

/// One day: the chosen day fills and the days of a range band together.
class SmoothDayCell extends StatelessWidget {
  const SmoothDayCell({
    super.key,
    required this.day,
    required this.isInMonth,
    required this.isToday,
    required this.isEnabled,
    required this.selection,
    required this.onTap,
  });

  final DateTime day;
  final bool isInMonth;
  final bool isToday;
  final bool isEnabled;
  final RangeDraft selection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final start = selection.start;
    final end = selection.end;
    final isChosen = (start != null && isSameDay(day, start)) || (end != null && isSameDay(day, end));
    final isInBand = start != null && end != null && !day.isBefore(start) && !day.isAfter(end);
    final color = isChosen ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      button: true,
      enabled: isEnabled,
      selected: isChosen,
      label: DateFormat.yMMMMd().format(day),
      excludeSemantics: true,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          height: PickerLayout.dayCellHeight,
          alignment: Alignment.center,
          color: isInBand && !isChosen ? scheme.primaryContainer.withValues(alpha: PickerLayout.rangeBandAlpha) : null,
          child: AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : Motion.fast,
            curve: Motion.standard,
            width: PickerLayout.dayCircle,
            height: PickerLayout.dayCircle,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChosen ? scheme.primary : null,
              border: isToday && !isChosen ? Border.all(color: scheme.primary) : null,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: isChosen || isToday ? FontWeight.w700 : FontWeight.w500,
                color: color.withValues(alpha: isEnabled && isInMonth ? 1 : PickerLayout.outsideMonthAlpha),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
