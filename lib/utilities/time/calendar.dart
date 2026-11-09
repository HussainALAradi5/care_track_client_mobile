import '../../constants/picker_layout.dart';
import '../../models/ui/range_draft.dart';
import 'dates.dart';

/// Six weeks of days around [month], starting on [firstWeekday] (0 is Sunday, as Material counts).
List<DateTime> monthCells(DateTime month, int firstWeekday) {
  final first = DateTime(month.year, month.month);
  final offset = (first.weekday % PickerLayout.daysPerWeek - firstWeekday) % PickerLayout.daysPerWeek;
  return List.generate(
    PickerLayout.weeksInGrid * PickerLayout.daysPerWeek,
    (i) => DateTime(first.year, first.month, 1 - offset + i),
  );
}

/// The day itself, or the nearest day inside [first] and [last].
DateTime clampDay(DateTime day, DateTime first, DateTime last) {
  final value = startOfDay(day);
  if (value.isBefore(startOfDay(first))) return startOfDay(first);
  if (value.isAfter(startOfDay(last))) return startOfDay(last);
  return value;
}

bool isDayWithin(DateTime day, DateTime first, DateTime last) =>
    !startOfDay(day).isBefore(startOfDay(first)) && !startOfDay(day).isAfter(startOfDay(last));

/// The range after a tap: the first tap starts it, a later day ends it, an earlier day or a tap on a finished range
/// starts over, so a range is never backwards.
RangeDraft nextRange(RangeDraft draft, DateTime tapped) {
  final start = draft.start;
  if (start == null || draft.end != null || tapped.isBefore(start)) return RangeDraft(start: tapped);
  return RangeDraft(start: start, end: tapped);
}
