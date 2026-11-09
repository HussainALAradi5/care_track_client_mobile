import '../../enums/workforce/staff_request_type.dart';

/// Text of the My requests screen.
class StaffRequestTexts {
  const StaffRequestTexts._();

  static const nav = 'Requests';
  static const title = 'My requests';
  static const subtitle = 'Ask HR for a letter, a certificate, a correction or anything else that is not leave.';
  static const newRequest = 'New request';
  static const type = 'What do you need?';
  static const details = 'Details';
  static const detailsHint = 'For example who the letter is for, or what should be corrected.';
  static const send = 'Send to HR';
  static const sent = 'Your request was sent to HR.';
  static const empty = 'No requests yet.';
  static const emptyHint = 'Your requests to HR show up here.';
  static const cancel = 'Cancel request';
  static const cancelTitle = 'Cancel this request?';
  static const cancelBody = 'HR will no longer see it as waiting.';
  static const cancelled = 'Request cancelled.';
  static String raised(String when) => 'Raised $when';
  static String decidedBy(String name) => 'By $name';

  static const types = {
    StaffRequestType.employmentLetter: 'Employment letter',
    StaffRequestType.salaryCertificate: 'Salary certificate',
    StaffRequestType.dataCorrection: 'Data correction',
    StaffRequestType.general: 'General HR request',
  };
}
