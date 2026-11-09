import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'iphone_date_sheet.dart';
import 'wheel_time_sheet.dart';

/// The iPhone look: wheels in a sheet from the bottom.
Future<DateTime?> showIphoneDate(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) => showCupertinoModalPopup<DateTime>(
  context: context,
  builder: (_) => IphoneDateSheet(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate),
);

Future<TimeOfDay?> showIphoneTime(BuildContext context, {required TimeOfDay initialTime}) =>
    showCupertinoModalPopup<TimeOfDay>(context: context, builder: (_) => WheelTimeSheet(initialTime: initialTime));
