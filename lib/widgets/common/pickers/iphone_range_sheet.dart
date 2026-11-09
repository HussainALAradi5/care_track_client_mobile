import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DateTimeRange;

import '../../../constants/texts/picker_texts.dart';
import '../../../enums/ui/range_edge.dart';
import '../../../utilities/time/calendar.dart';
import 'picker_sheet_frame.dart';

/// Wheels for a first and last day, with a Start/End switch; the last day can never be before the first.
class IphoneRangeSheet extends StatefulWidget {
  const IphoneRangeSheet({super.key, required this.firstDate, required this.lastDate, this.initialRange});

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialRange;

  @override
  State<IphoneRangeSheet> createState() => _IphoneRangeSheetState();
}

class _IphoneRangeSheetState extends State<IphoneRangeSheet> {
  RangeEdge _edge = RangeEdge.start;
  late DateTime _start = clampDay(widget.initialRange?.start ?? DateTime.now(), widget.firstDate, widget.lastDate);
  late DateTime _end = clampDay(widget.initialRange?.end ?? _start, _start, widget.lastDate);

  void _changed(DateTime value) {
    if (_edge == RangeEdge.end) {
      _end = value;
      return;
    }
    _start = value;
    if (_end.isBefore(_start)) _end = _start;
  }

  @override
  Widget build(BuildContext context) {
    final isStart = _edge == RangeEdge.start;
    return PickerSheetFrame(
      onDone: () => Navigator.pop(context, DateTimeRange(start: _start, end: _end)),
      header: CupertinoSlidingSegmentedControl<RangeEdge>(
        groupValue: _edge,
        onValueChanged: (edge) => setState(() => _edge = edge ?? _edge),
        children: const {
          RangeEdge.start: Text(PickerTexts.start),
          RangeEdge.end: Text(PickerTexts.end),
        },
      ),
      child: CupertinoDatePicker(
        key: ValueKey(_edge),
        mode: CupertinoDatePickerMode.date,
        initialDateTime: isStart ? _start : _end,
        minimumDate: isStart ? widget.firstDate : _start,
        maximumDate: widget.lastDate,
        onDateTimeChanged: _changed,
      ),
    );
  }
}
