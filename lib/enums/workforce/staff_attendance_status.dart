/// Server StaffAttendanceStatus.
enum StaffAttendanceStatus {
  checkedIn('CHECKED_IN'),
  checkedOut('CHECKED_OUT');

  const StaffAttendanceStatus(this.wire);
  final String wire;

  static StaffAttendanceStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
