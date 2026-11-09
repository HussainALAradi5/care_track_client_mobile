import 'package:flutter/cupertino.dart';

import '../../../utilities/time/calendar.dart';
import 'picker_sheet_frame.dart';

/// Month, day and year wheels; nothing is kept until Done.
class IphoneDateSheet extends StatefulWidget {
  const IphoneDateSheet({super.key, required this.initialDate, required this.firstDate, required this.lastDate});

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<IphoneDateSheet> createState() => _IphoneDateSheetState();
}

class _IphoneDateSheetState extends State<IphoneDateSheet> {
  late DateTime _value = clampDay(widget.initialDate, widget.firstDate, widget.lastDate);

  @override
  Widget build(BuildContext context) => PickerSheetFrame(
    onDone: () => Navigator.pop(context, _value),
    child: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: _value,
      minimumDate: widget.firstDate,
      maximumDate: widget.lastDate,
      onDateTimeChanged: (value) => _value = value,
    ),
  );
}
