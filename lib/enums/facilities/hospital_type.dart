/// Server HospitalType.
enum HospitalType {
  public('PUBLIC'),
  private('PRIVATE');

  const HospitalType(this.wire);
  final String wire;

  static HospitalType fromWire(String value) => values.firstWhere((t) => t.wire == value);
}
