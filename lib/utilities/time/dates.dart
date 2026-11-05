import 'package:intl/intl.dart';

DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// "Tue, 4 Nov · 09:30 – 10:00" in the device's locale and time zone.
String visitTime(DateTime startsAt, DateTime endsAt) {
  final time = DateFormat.Hm();
  return '${DateFormat('EEE, d MMM').format(startsAt)} · ${time.format(startsAt)} – ${time.format(endsAt)}';
}

String shortDateTime(DateTime value) => DateFormat('d MMM, HH:mm').format(value);
