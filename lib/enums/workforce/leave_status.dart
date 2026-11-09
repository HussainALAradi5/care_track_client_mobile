/// Server LeaveStatus.
enum LeaveStatus {
  requested('REQUESTED'),
  approved('APPROVED'),
  rejected('REJECTED'),
  cancelled('CANCELLED');

  const LeaveStatus(this.wire);
  final String wire;

  static LeaveStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
