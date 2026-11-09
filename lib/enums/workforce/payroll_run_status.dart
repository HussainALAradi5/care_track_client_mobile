/// Server PayrollRunStatus.
enum PayrollRunStatus {
  draft('DRAFT'),
  approved('APPROVED'),
  paid('PAID');

  const PayrollRunStatus(this.wire);
  final String wire;

  static PayrollRunStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
