/// One choosable consultation interval in the slot picker.
class TimeSlot {
  const TimeSlot({required this.startsAt, required this.endsAt, required this.past});

  final DateTime startsAt;
  final DateTime endsAt;
  final bool past;
}
