import 'package:flutter/material.dart';

import '../../../constants/picker_layout.dart';
import '../../../models/ui/range_draft.dart';
import '../../../utilities/time/calendar.dart';
import '../../../utilities/time/dates.dart';
import 'smooth_day_cell.dart';

/// One month's six weeks, under a row of weekday letters in the device's week order.
class SmoothMonthGrid extends StatelessWidget {
  const SmoothMonthGrid({
    super.key,
    required this.month,
    required this.firstDate,
    required this.lastDate,
    required this.selection,
    required this.onDay,
  });

  final DateTime month;
  final DateTime firstDate;
  final DateTime lastDate;
  final RangeDraft selection;
  final ValueChanged<DateTime> onDay;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final firstWeekday = localizations.firstDayOfWeekIndex;
    final letters = localizations.narrowWeekdays;
    final cells = monthCells(month, firstWeekday);
    final today = startOfDay(DateTime.now());
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (var i = 0; i < PickerLayout.daysPerWeek; i++)
              Expanded(
                child: Center(
                  child: Text(letters[(firstWeekday + i) % PickerLayout.daysPerWeek], style: TextStyle(color: muted)),
                ),
              ),
          ],
        ),
        for (var week = 0; week < PickerLayout.weeksInGrid; week++)
          Row(
            children: [
              for (final day in cells.skip(week * PickerLayout.daysPerWeek).take(PickerLayout.daysPerWeek))
                Expanded(
                  child: SmoothDayCell(
                    day: day,
                    isInMonth: day.month == month.month,
                    isToday: isSameDay(day, today),
                    isEnabled: isDayWithin(day, firstDate, lastDate),
                    selection: selection,
                    onTap: () => onDay(day),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
