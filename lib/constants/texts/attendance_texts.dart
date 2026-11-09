/// Text of the Attendance screen.
class AttendanceTexts {
  const AttendanceTexts._();

  static const nav = 'Attendance';
  static const title = 'Attendance';
  static const subtitle = 'Clock in when you start and out when you leave, at the hospital you work at.';
  static const notAssigned = 'You do not work at this hospital, so there is nothing to clock in to here.';
  static String hours(String days, String start, String end) => '$days · $start–$end';
  static const noHours = 'Your hospital has not set its working hours yet.';
  static const offDay = 'Today is not a working day here.';
  static String onShift(String time) => 'You have a shift today at $time. Clock in to it on My visits or Shifts.';
  static String onLeave(String type) => 'You are on $type today.';
  static const clockIn = 'Clock in';
  static const clockOut = 'Clock out';
  static const clockedIn = 'Clocked in. Have a good day.';
  static const clockedOut = 'Clocked out. See you next time.';
  static String inAt(String time) => 'In at $time';
  static String outAt(String time) => 'Out at $time';
  static String late(String minutes) => '$minutes late';
  static String worked(String minutes) => '$minutes worked';
  static const historyTitle = 'Last two weeks';
  static const noHistory = 'No days yet.';
  static const teamTitle = 'My team today';
  static const teamLead = 'The people who report to you at this hospital.';
  static String expected(String time) => 'Expected $time';
  static String hoursMinutes(int hours, String rest) => '$hours h $rest min';
  static String minutes(int minutes) => '$minutes min';

  static const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const weekWire = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
}
