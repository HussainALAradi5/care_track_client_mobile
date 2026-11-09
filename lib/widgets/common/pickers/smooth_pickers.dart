import 'package:flutter/material.dart';

import 'smooth_date_sheet.dart';
import 'wheel_time_sheet.dart';

/// The Smooth look: CareTrack's animated calendar in a bottom sheet.
Future<DateTime?> showSmoothDate(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) => showModalBottomSheet<DateTime>(
  context: context,
  isScrollControlled: true,
  builder: (_) => SmoothDateSheet(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate),
);

Future<TimeOfDay?> showSmoothTime(BuildContext context, {required TimeOfDay initialTime}) =>
    showModalBottomSheet<TimeOfDay>(context: context, builder: (_) => WheelTimeSheet(initialTime: initialTime));
