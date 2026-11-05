import 'package:care_track_client_mobile/dtos/workforce/create_shift_request.dart';
import 'package:care_track_client_mobile/models/workforce/clinician_shift.dart';
import 'package:care_track_client_mobile/utilities/workforce/shift_interval.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses ClinicianShiftDto and knows when it has started', () {
    final shift = ClinicianShift.fromJson({
      'id': 's1',
      'code': 'CS-1',
      'hospitalId': 'h1',
      'clinicianId': 'c1',
      'clinicianName': 'Development Doctor',
      'startsAt': '2026-11-05T05:00:00Z',
      'endsAt': '2026-11-05T13:00:00Z',
    });
    expect(shift.clinicianName, 'Development Doctor');
    expect(shift.startedAt(DateTime.utc(2026, 11, 5, 4, 59)), isFalse);
    expect(shift.startedAt(DateTime.utc(2026, 11, 5, 5)), isTrue);
  });

  test('a night shift ends the next day', () {
    final interval = shiftInterval(DateTime(2026, 11, 5), const TimeOfDay(hour: 23, minute: 0), 8);
    expect(interval.startsAt, DateTime(2026, 11, 5, 23));
    expect(interval.endsAt, DateTime(2026, 11, 6, 7));
  });

  test('the create body sends UTC instants', () {
    final body = CreateShiftRequest(
      clinicianId: 'c1',
      startsAt: DateTime.utc(2026, 11, 5, 5),
      endsAt: DateTime.utc(2026, 11, 5, 13),
    ).toJson();
    expect(body, {'clinicianId': 'c1', 'startsAt': '2026-11-05T05:00:00.000Z', 'endsAt': '2026-11-05T13:00:00.000Z'});
  });

  test('quick-start matching compares hours and minutes', () {
    expect(sameTimeOfDay(const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 8, minute: 0)), isTrue);
    expect(sameTimeOfDay(const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 8, minute: 30)), isFalse);
  });
}
