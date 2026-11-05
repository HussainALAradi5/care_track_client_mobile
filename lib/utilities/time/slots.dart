import '../../constants/scheduling.dart';
import '../../models/care/time_slot.dart';
import 'dates.dart';

/// Candidate consultation intervals on one day, every slot step between opening and closing hour.
/// Past starts are flagged so the picker shows but disables them. The server still checks the doctor's shift.
List<TimeSlot> daySlots(DateTime day, int durationMinutes, DateTime now) {
  final open = startOfDay(day).add(const Duration(hours: Scheduling.dayStartHour));
  final close = startOfDay(day).add(const Duration(hours: Scheduling.dayEndHour));
  final length = Duration(minutes: durationMinutes);
  final slots = <TimeSlot>[];
  for (var start = open; !start.add(length).isAfter(close); start = start.add(const Duration(minutes: Scheduling.slotStepMinutes))) {
    slots.add(TimeSlot(startsAt: start, endsAt: start.add(length), past: !start.isAfter(now)));
  }
  return slots;
}
