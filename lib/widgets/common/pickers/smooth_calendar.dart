import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/motion.dart';
import '../../../constants/picker_layout.dart';
import '../../../constants/texts/picker_texts.dart';
import '../../../models/ui/range_draft.dart';
import 'smooth_month_grid.dart';

/// CareTrack's animated calendar: months slide in the way they were turned, unless the device asks for less motion.
class SmoothCalendar extends StatefulWidget {
  const SmoothCalendar({
    super.key,
    required this.initialMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selection,
    required this.onDay,
  });

  final DateTime initialMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final RangeDraft selection;
  final ValueChanged<DateTime> onDay;

  @override
  State<SmoothCalendar> createState() => _SmoothCalendarState();
}

class _SmoothCalendarState extends State<SmoothCalendar> {
  late DateTime _month = DateTime(widget.initialMonth.year, widget.initialMonth.month);
  int _direction = 1;

  DateTime _shifted(int months) => DateTime(_month.year, _month.month + months);

  bool _canShow(DateTime month) {
    final firstMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    return !month.isBefore(firstMonth) && !month.isAfter(widget.lastDate);
  }

  void _turn(int months) => setState(() {
    _direction = months.sign;
    _month = _shifted(months);
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: PickerTexts.previousMonth,
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: _canShow(_shifted(-1)) ? () => _turn(-1) : null,
            ),
            Expanded(
              child: Text(
                DateFormat('MMMM y').format(_month),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              tooltip: PickerTexts.nextMonth,
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _canShow(_shifted(1)) ? () => _turn(1) : null,
            ),
          ],
        ),
        const SizedBox(height: PickerLayout.headerGap),
        AnimatedSwitcher(
          duration: reduced ? Duration.zero : Motion.medium,
          switchInCurve: Motion.standard,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: Offset(_direction * PickerLayout.slideOffset, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: SmoothMonthGrid(
            key: ValueKey(_month),
            month: _month,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            selection: widget.selection,
            onDay: widget.onDay,
          ),
        ),
      ],
    );
  }
}
