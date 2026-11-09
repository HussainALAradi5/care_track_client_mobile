import 'package:flutter/material.dart' show TimeOfDay;
import 'package:intl/intl.dart';

DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// '2026-11-05': a calendar day as the server's LocalDate reads it.
String isoDay(DateTime value) => DateFormat('yyyy-MM-dd').format(value);

/// "Tue, 4 Nov · 09:30 – 10:00" in the device's locale and time zone.
String visitTime(DateTime startsAt, DateTime endsAt) {
  final time = DateFormat.Hm();
  return '${DateFormat('EEE, d MMM').format(startsAt)} · ${time.format(startsAt)} – ${time.format(endsAt)}';
}

String shortDateTime(DateTime value) => DateFormat('d MMM, HH:mm').format(value);

/// 'Thu, 5 Nov 2026' in the device's locale (a picked day in a form).
String longDate(DateTime value) => DateFormat('EEE, d MMM y').format(value);

/// '08:30': a time of day, always 24-hour.
String hourMinute(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
