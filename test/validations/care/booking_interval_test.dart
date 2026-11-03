import 'package:care_track_client_mobile/validations/care/booking_interval.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 3, 8);
  DateTime at(int hour, [int minute = 0]) => DateTime(2026, 11, 3, hour, minute);

  test('accepts a future interval up to two hours', () {
    expect(isValidBookingInterval(at(9), at(9, 30), now), isTrue);
    expect(isValidBookingInterval(at(9), at(11), now), isTrue);
  });

  test('rejects past, empty, reversed and over-long intervals', () {
    expect(isValidBookingInterval(at(7), at(7, 30), now), isFalse);
    expect(isValidBookingInterval(at(9), at(9), now), isFalse);
    expect(isValidBookingInterval(at(10), at(9), now), isFalse);
    expect(isValidBookingInterval(at(9), at(11, 15), now), isFalse);
  });
}
