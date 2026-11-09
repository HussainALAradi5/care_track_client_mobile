import 'package:flutter/material.dart';

/// The Android look: Material's calendar and clock.
Future<DateTime?> showAndroidDate(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) => showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);

Future<TimeOfDay?> showAndroidTime(BuildContext context, {required TimeOfDay initialTime}) => showTimePicker(
  context: context,
  initialTime: initialTime,
  builder: (context, child) =>
      MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
);
