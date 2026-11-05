const _hourMinutes = 60;
const _dayMinutes = 24 * _hourMinutes;

/// "2 d 4 h", "3 h 10 min", "12 min", or null once the moment has passed.
String? remainingLabel(DateTime until, DateTime now) {
  final minutes = until.difference(now).inMinutes;
  if (minutes <= 0) return null;
  if (minutes >= _dayMinutes) return '${minutes ~/ _dayMinutes} d ${(minutes % _dayMinutes) ~/ _hourMinutes} h';
  if (minutes >= _hourMinutes) return '${minutes ~/ _hourMinutes} h ${minutes % _hourMinutes} min';
  return '$minutes min';
}

/// How much of [start, end) is left at [now], from 1 (all) to 0 (none).
double remainingFraction(DateTime start, DateTime end, DateTime now) {
  final total = end.difference(start).inMilliseconds;
  if (total <= 0) return 0;
  return (end.difference(now).inMilliseconds / total).clamp(0.0, 1.0);
}
