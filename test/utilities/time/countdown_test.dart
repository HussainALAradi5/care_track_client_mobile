import 'package:care_track_client_mobile/utilities/time/countdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 3, 8);

  test('labels days, hours and minutes left', () {
    expect(remainingLabel(DateTime.utc(2026, 11, 5, 12, 30), now), '2 d 4 h');
    expect(remainingLabel(DateTime.utc(2026, 11, 3, 11, 10), now), '3 h 10 min');
    expect(remainingLabel(DateTime.utc(2026, 11, 3, 8, 12), now), '12 min');
    expect(remainingLabel(DateTime.utc(2026, 11, 3, 7, 59), now), isNull);
  });

  test('drains from 1 to 0 and clamps outside the window', () {
    final start = DateTime.utc(2026, 11, 3, 6);
    final end = DateTime.utc(2026, 11, 3, 10);
    expect(remainingFraction(start, end, now), 0.5);
    expect(remainingFraction(start, end, DateTime.utc(2026, 11, 3, 5)), 1);
    expect(remainingFraction(start, end, DateTime.utc(2026, 11, 3, 11)), 0);
    expect(remainingFraction(end, start, now), 0);
  });
}
