/// Mirrors the server's AppointmentStatus.
enum AppointmentStatus {
  scheduled('SCHEDULED'),
  cancelled('CANCELLED'),
  checkedIn('CHECKED_IN'),
  noShow('NO_SHOW'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  notSeen('NOT_SEEN');

  const AppointmentStatus(this.wire);
  final String wire;

  static AppointmentStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
