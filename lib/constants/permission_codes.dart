/// Server permission codes (PermissionCodes.java) the app uses to show staff screens and actions.
class PermissionCodes {
  const PermissionCodes._();

  static const bookingReadAll = 'BOOKING:READ_ALL';
  static const bookingConfirm = 'BOOKING:CONFIRM';
  static const appointmentReadAll = 'APPOINTMENT:READ_ALL';
  static const appointmentCheckIn = 'APPOINTMENT:CHECK_IN';
  static const appointmentNoShow = 'APPOINTMENT:NO_SHOW';
  static const shiftWrite = 'SHIFT:WRITE';
  static const leaveReadAll = 'LEAVE:READ_ALL';
  static const staffRequestHandle = 'STAFF_REQUEST:HANDLE';
  static const clinicalHistoryWrite = 'CLINICAL_HISTORY:WRITE';
  static const accountRead = 'ACCOUNT:READ';
  static const journalRead = 'JOURNAL:READ';
  static const financeReportRead = 'FINANCE_REPORT:READ';

  /// Header the server requires on retry-safe writes such as booking confirmation.
  static const idempotencyHeader = 'Idempotency-Key';
}
