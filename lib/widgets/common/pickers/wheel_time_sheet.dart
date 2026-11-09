import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import 'picker_sheet_frame.dart';

/// 24-hour hour and minute wheels (the iPhone and Smooth looks); nothing is kept until Done.
class WheelTimeSheet extends StatefulWidget {
  const WheelTimeSheet({super.key, required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<WheelTimeSheet> createState() => _WheelTimeSheetState();
}

class _WheelTimeSheetState extends State<WheelTimeSheet> {
  late TimeOfDay _value = widget.initialTime;

  @override
  Widget build(BuildContext context) => PickerSheetFrame(
    onDone: () => Navigator.pop(context, _value),
    child: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      use24hFormat: true,
      initialDateTime: DateTime(2000, 1, 1, widget.initialTime.hour, widget.initialTime.minute),
      onDateTimeChanged: (value) => _value = TimeOfDay(hour: value.hour, minute: value.minute),
    ),
  );
}
