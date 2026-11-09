/// Text of the My leave and Leave requests screens.
class LeaveTexts {
  const LeaveTexts._();

  static const nav = 'Leave';
  static const navRequests = 'Leave requests';
  static const title = 'My leave';
  static const subtitle = 'Your leave this year, and asking for more. Your manager or HR decides.';
  static const notEmployed = 'Leave is for people employed in this organization.';
  static const noTypes = 'Your organization has no leave types yet. HR adds them.';
  static String allowed(int days) => '$days days a year';
  static const noLimit = 'No limit';
  static String taken(int days) => '$days taken';
  static String waiting(int days) => '$days waiting';
  static String left(int days) => '$days left';
  static const paid = 'Paid';
  static const unpaid = 'Unpaid';
  static const askTitle = 'Ask for leave';
  static const type = 'Leave type';
  static const start = 'First day';
  static const end = 'Last day';
  static const reason = 'Reason (optional)';
  static const chooseDay = 'Choose a day';
  static String days(int days) => days == 1 ? '1 day' : '$days days';
  static const tooLong = 'At most 90 days at a time.';
  static const oneYear = 'Keep the first and last day in the same year.';
  static String notEnough(int left) => 'Only $left days of this leave left this year.';
  static const ask = 'Ask for leave';
  static const asked = 'Your request was sent to your manager.';
  static String sickNoteAttached(String hospital, String doctor) => 'Sick note from $hospital, by $doctor';
  static const sickNoteHint = 'Your employer sees who issued it and the days, never its content.';
  static const removeSickNote = 'Remove';
  static const mineTitle = 'My requests';
  static const noRequests = 'No leave asked for this year.';
  static const toDecideTitle = 'To decide';
  static const toDecideLead = 'Requests from the people who report to you.';

  static const approve = 'Approve';
  static const reject = 'Reject';
  static const cancel = 'Cancel';
  static String approved(String name) => "$name's leave approved.";
  static String rejected(String name) => "$name's leave rejected.";
  static const cancelled = 'Leave cancelled.';
  static const rejectTitle = 'Reject this leave?';
  static String rejectMessage(String name, String days) => '$name asked for $days. Say why it is rejected.';
  static const rejectReason = 'Why';
  static const cancelTitle = 'Cancel this leave?';
  static String cancelMessage(String days) => 'The $days go back to the balance.';
  static String decidedBy(String name) => 'By $name';
  static String sickNote(String hospital, String doctor) => 'Sick note: $hospital · $doctor';

  static const requestsTitle = 'Leave requests';
  static const requestsSubtitle = "Everyone's leave in the organization. Approve or reject what is waiting.";
  static const status = 'Status';
  static const all = 'All';
  static const requestsEmpty = 'No leave requests here';
  static const requestsEmptyHint = 'Try another status.';
}
