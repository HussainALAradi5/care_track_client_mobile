import 'package:flutter/material.dart';

import '../../../constants/picker_layout.dart';
import '../../../models/ui/range_draft.dart';
import '../../../utilities/time/calendar.dart';
import 'smooth_calendar.dart';

/// One day on the animated calendar; choosing a day closes the sheet with it.
class SmoothDateSheet extends StatelessWidget {
  const SmoothDateSheet({super.key, required this.initialDate, required this.firstDate, required this.lastDate});

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    final initial = clampDay(initialDate, firstDate, lastDate);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(PickerLayout.sheetPadding),
        child: SmoothCalendar(
          initialMonth: initial,
          firstDate: firstDate,
          lastDate: lastDate,
          selection: RangeDraft(start: initial, end: initial),
          onDay: (day) => Navigator.pop(context, day),
        ),
      ),
    );
  }
}
