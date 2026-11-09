import 'package:flutter/material.dart';

import '../../../constants/picker_layout.dart';
import '../../../models/ui/range_draft.dart';
import '../../../utilities/time/calendar.dart';
import 'smooth_calendar.dart';

/// A first and last day on the animated calendar; the second day closes the sheet.
class SmoothRangeSheet extends StatefulWidget {
  const SmoothRangeSheet({super.key, required this.firstDate, required this.lastDate, this.initialRange});

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialRange;

  @override
  State<SmoothRangeSheet> createState() => _SmoothRangeSheetState();
}

class _SmoothRangeSheetState extends State<SmoothRangeSheet> {
  late RangeDraft _draft = RangeDraft(start: widget.initialRange?.start, end: widget.initialRange?.end);

  void _tap(DateTime day) {
    final next = nextRange(_draft, day);
    final start = next.start;
    final end = next.end;
    if (start != null && end != null) {
      Navigator.pop(context, DateTimeRange(start: start, end: end));
      return;
    }
    setState(() => _draft = next);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(PickerLayout.sheetPadding),
      child: SmoothCalendar(
        initialMonth: clampDay(_draft.start ?? DateTime.now(), widget.firstDate, widget.lastDate),
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        selection: _draft,
        onDay: _tap,
      ),
    ),
  );
}
