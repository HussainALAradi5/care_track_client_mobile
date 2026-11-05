import 'package:flutter/material.dart';

/// A new shift's local start and end: [day] at [time] for [hours] (it may end the next day).
({DateTime startsAt, DateTime endsAt}) shiftInterval(DateTime day, TimeOfDay time, int hours) {
  final startsAt = DateTime(day.year, day.month, day.day, time.hour, time.minute);
  return (startsAt: startsAt, endsAt: startsAt.add(Duration(hours: hours)));
}

/// Whether two times of day are the same minute (so the matching quick-start chip shows as picked).
bool sameTimeOfDay(TimeOfDay a, TimeOfDay b) => a.hour == b.hour && a.minute == b.minute;
