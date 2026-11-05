/// Mirrors the server's BookingStatus.
enum BookingStatus {
  requested('REQUESTED'),
  confirmed('CONFIRMED'),
  cancelled('CANCELLED'),
  rejected('REJECTED'),
  expired('EXPIRED');

  const BookingStatus(this.wire);
  final String wire;

  static BookingStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
