import 'package:care_track_client_mobile/constants/scheduling.dart';
import 'package:care_track_client_mobile/utilities/time/slots.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final day = DateTime(2026, 11, 4);

  test('steps through opening hours and keeps every slot inside them', () {
    final slots = daySlots(day, 30, DateTime(2026, 11, 3));
    const hours = Scheduling.dayEndHour - Scheduling.dayStartHour;
    expect(slots.length, (hours * 60 - 30) ~/ Scheduling.slotStepMinutes + 1);
    expect(slots.first.startsAt.hour, Scheduling.dayStartHour);
    expect(slots.last.endsAt.hour, Scheduling.dayEndHour);
    expect(slots.every((s) => !s.past), isTrue);
  });

  test('flags starts that are not after now as past', () {
    final slots = daySlots(day, 15, DateTime(2026, 11, 4, 9));
    expect(slots.where((s) => s.past).length, 5);
    expect(slots.firstWhere((s) => !s.past).startsAt, DateTime(2026, 11, 4, 9, 15));
  });
}
