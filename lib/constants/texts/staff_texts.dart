import '../../enums/identity/presence_verification_method.dart';

/// Text of the staff screens: the booking queue, the appointments desk and the staff overview.
class StaffTexts {
  const StaffTexts._();

  static const navQueue = 'Queue';
  static const navDesk = 'Desk';
  static const navShifts = 'Shifts';
  static const navMore = 'More';

  static const queueTitle = 'Booking queue';
  static const queueSubtitle = 'Requests waiting for a decision, oldest first.';
  static const queueEmpty = 'No requests are waiting.';
  static const queueEmptyHint = 'New booking requests from patients show up here.';
  static const confirm = 'Confirm';
  static const confirmed = 'Request confirmed. The patient now has an appointment.';
  static const reject = 'Decline';
  static const rejectTitle = 'Decline this request?';
  static const rejectBody = 'The patient sees your reason and can book another time.';
  static const rejectReason = 'Reason for the patient';
  static const rejected = 'Request declined.';
  static String withClinician(String clinician) => 'with $clinician';

  static const deskTitle = 'Appointments desk';
  static const deskSubtitle = 'Check patients in, and close visits that did not happen.';
  static const deskEmpty = 'Nothing here right now.';
  static const deskEmptyHint = 'Confirmed appointments show up here.';
  static const waitingToArrive = 'Waiting to arrive';
  static const checkedInTab = 'Checked in';
  static const checkIn = 'Check in';
  static const checkInTitle = 'How was the identity checked?';
  static const checkedIn = 'Patient checked in.';
  static const noShow = 'Did not arrive';
  static const noShowTitle = 'Record that the patient did not arrive?';
  static const noShowBody = 'The visit closes as missed and the patient sees your note.';
  static const noShowReason = 'Note';
  static const noShowDone = 'Recorded as missed.';
  static const notSeen = 'Not seen';
  static const notSeenTitle = 'Close this visit as not seen?';
  static const notSeenBody = 'The patient was checked in but the consultation never started.';
  static const notSeenReason = 'Reason';
  static const notSeenDone = 'Visit closed as not seen.';

  static const verification = {
    PresenceVerificationMethod.idCard: 'ID card',
    PresenceVerificationMethod.passport: 'Passport',
    PresenceVerificationMethod.hospitalRecord: 'Hospital record',
  };

  static const overviewTitle = 'Staff';
  static const noStaffHospital = 'You do not work at a hospital in CareTrack yet.';
  static const noStaffHospitalHint = 'Ask your administrator to give you a role at your hospital.';
  static const lockedTitle = 'This screen is not open to you here.';
  static const lockedHint = 'Pick another hospital, or ask your administrator for access.';
}
