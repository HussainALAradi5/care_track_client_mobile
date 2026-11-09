/// Server StaffRequestType: what an employee asks HR for, other than leave.
enum StaffRequestType {
  employmentLetter('EMPLOYMENT_LETTER'),
  salaryCertificate('SALARY_CERTIFICATE'),
  dataCorrection('DATA_CORRECTION'),
  general('GENERAL');

  const StaffRequestType(this.wire);
  final String wire;

  static StaffRequestType fromWire(String value) => values.firstWhere((t) => t.wire == value);
}
