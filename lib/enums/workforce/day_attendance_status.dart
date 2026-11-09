/// Server DayAttendanceStatus.
enum DayAttendanceStatus {
  present('PRESENT'),
  late('LATE'),
  absent('ABSENT'),
  onLeave('ON_LEAVE'),
  offDay('OFF_DAY'),
  notInYet('NOT_IN_YET'),
  noSchedule('NO_SCHEDULE');

  const DayAttendanceStatus(this.wire);
  final String wire;

  static DayAttendanceStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
