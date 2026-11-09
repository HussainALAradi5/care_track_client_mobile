import '../../constants/texts/attendance_texts.dart';

/// "1 h 05 min", "45 min".
String minutesLabel(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return hours == 0 ? AttendanceTexts.minutes(rest) : AttendanceTexts.hoursMinutes(hours, rest.toString().padLeft(2, '0'));
}

/// "08:00:00" to "08:00".
String shortTime(String time) => time.substring(0, 5);

/// The working days in week order, runs joined: "Sun–Thu", "Sun, Tue".
String daysLabel(List<String> days) {
  const week = AttendanceTexts.weekWire;
  const labels = AttendanceTexts.weekDays;
  final runs = <String>[];
  var start = -1;
  for (var i = 0; i <= week.length; i++) {
    final on = i < week.length && days.contains(week[i]);
    if (on && start < 0) start = i;
    if (!on && start >= 0) {
      final end = i - 1;
      runs.add(end - start >= 2 ? '${labels[start]}–${labels[end]}' : labels.sublist(start, end + 1).join(', '));
      start = -1;
    }
  }
  return runs.join(', ');
}
