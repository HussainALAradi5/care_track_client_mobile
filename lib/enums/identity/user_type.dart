/// Mirrors the server's UserType.
enum UserType {
  patient('PATIENT'),
  doctor('DOCTOR'),
  nurse('NURSE'),
  pharmacist('PHARMACIST'),
  administrator('ADMINISTRATOR'),
  employee('EMPLOYEE'),
  accountant('ACCOUNTANT');

  const UserType(this.wire);
  final String wire;

  /// Every account type except patients works at a hospital and gets the staff screens.
  bool get isStaff => this != patient;

  /// Accountants work across an Organization's books and get the books screens instead.
  bool get isAccountant => this == accountant;

  static UserType fromWire(String value) => values.firstWhere((t) => t.wire == value);
}
