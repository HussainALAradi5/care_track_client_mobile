/// Mirrors the server's UserType.
enum UserType {
  patient('PATIENT'),
  doctor('DOCTOR'),
  nurse('NURSE'),
  pharmacist('PHARMACIST'),
  administrator('ADMINISTRATOR'),
  employee('EMPLOYEE');

  const UserType(this.wire);
  final String wire;

  static UserType fromWire(String value) => values.firstWhere((t) => t.wire == value);
}
