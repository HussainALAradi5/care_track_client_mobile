/// Server StaffRequestStatus.
enum StaffRequestStatus {
  requested('REQUESTED'),
  approved('APPROVED'),
  rejected('REJECTED'),
  cancelled('CANCELLED');

  const StaffRequestStatus(this.wire);
  final String wire;

  static StaffRequestStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
