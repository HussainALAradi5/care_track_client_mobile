/// Shared UI text; widgets import it instead of hardcoding strings.
class CommonTexts {
  const CommonTexts._();

  static const loading = 'Loading…';
  static const retry = 'Try again';
  static const genericError = 'Something went wrong. Please try again.';
  static const offline = 'You appear to be offline. Check your connection.';
  static const sessionExpired = 'Your session expired. Please sign in again.';
  static const forbidden = 'You do not have access to this.';
  static const signIn = 'Sign in';
  static const signOut = 'Sign out';
  static const signInIntro = 'Sign in with your hospital account to see and book your visits.';
  static const signInFailed = 'Sign-in did not complete. Please try again.';
  static const keep = 'Keep it';
  static const toggleTheme = 'Switch light or dark theme';
  static const hospital = 'Hospital';
  static const loadMore = 'Load more';

  static const navHome = 'Overview';
  static const navBook = 'Book';
  static const navRequests = 'Requests';
  static const navVisits = 'Visits';

  static const errorCodes = <String, String>{
    'SCHEDULING_NOT_READY': 'This hospital does not take online bookings yet.',
    'BOOKING_INTERVAL_INVALID': 'Choose a future time of at most two hours.',
    'CLINICIAN_NOT_ASSIGNED': 'This doctor is not on your care team any more.',
    'CLINICIAN_HOSPITAL_ROLE_REQUIRED': 'This doctor cannot take bookings here right now.',
    'CANCELLATION_WINDOW_CLOSED': 'The cancellation window for this appointment has closed.',
    'VERSION_CONFLICT': 'This changed meanwhile. The latest version is now shown.',
    'BOOKING_STATE_INVALID': 'This request can no longer be changed.',
    'APPOINTMENT_STATE_INVALID': 'This appointment can no longer be changed.',
    'BOOKING_OVERLAP': 'You already have a waiting request at this time.',
    'SLOT_UNAVAILABLE': 'This time is already taken. Please choose another.',
    'CHECK_IN_WINDOW_CLOSED': 'Check-in opens 30 minutes before the visit and closes when it ends.',
    'NO_SHOW_TOO_EARLY': 'A missed visit can be recorded 30 minutes after it ends.',
    'NOT_SEEN_TOO_EARLY': 'The consultation can still start; try again after the late-start grace.',
    'CLINICIAN_OFF_SHIFT': 'The doctor has no shift covering this time. Add one on the Shifts tab first, or decline.',
    'CARE_ASSIGNMENT_ENDED': "This doctor is no longer on the patient's care team.",
    'CLINICIAN_ROLE_ENDED': 'This doctor no longer takes consultations here.',
    'PATIENT_ACCOUNT_INACTIVE': "The patient's account is not active.",
    'IDEMPOTENCY_CONFLICT': 'This request was already decided by someone else.',
    'IDEMPOTENCY_KEY_INVALID': 'The request could not be sent safely. Please try again.',
    'SHIFT_OVERLAP': 'This person already has a shift that overlaps this time.',
    'SHIFT_INTERVAL_INVALID': 'A shift must start in the future and last at most 24 hours.',
    'SHIFT_STARTED': 'This shift has already started, so it stays on record.',
    'SHIFT_IN_USE': 'Visits or room cover are booked in this shift. Move or cancel them first.',
    'CLINICIAN_NOT_FOUND': 'This person is not an active doctor or nurse.',
  };
}
