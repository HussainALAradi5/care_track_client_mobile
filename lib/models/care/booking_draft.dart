import '../../constants/scheduling.dart';
import '../../utilities/time/dates.dart';
import 'time_slot.dart';

/// What the person has chosen so far in the booking wizard.
class BookingDraft {
  BookingDraft({
    this.step = 0,
    this.clinicianId,
    DateTime? day,
    this.durationMinutes = Scheduling.defaultDurationMinutes,
    this.slot,
  }) : day = day ?? startOfDay(DateTime.now());

  final int step;
  final String? clinicianId;
  final DateTime day;
  final int durationMinutes;
  final TimeSlot? slot;

  BookingDraft copyWith({
    int? step,
    String? Function()? clinicianId,
    DateTime? day,
    int? durationMinutes,
    TimeSlot? Function()? slot,
  }) => BookingDraft(
    step: step ?? this.step,
    clinicianId: clinicianId == null ? this.clinicianId : clinicianId(),
    day: day ?? this.day,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    slot: slot == null ? this.slot : slot(),
  );
}
