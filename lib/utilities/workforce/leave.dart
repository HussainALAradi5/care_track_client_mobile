import '../time/dates.dart';

/// Calendar days from the first to the last day, both included; 0 when the last is before the first.
int leaveDays(DateTime start, DateTime end) {
  final from = startOfDay(start);
  final to = startOfDay(end);
  return to.isBefore(from) ? 0 : DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays + 1;
}

/// How much of a yearly allowance is used, 0 to 1; null for no limit.
double? usedFraction(int? allowed, int taken, int waiting) {
  if (allowed == null || allowed == 0) return null;
  return ((taken + waiting) / allowed).clamp(0, 1).toDouble();
}
