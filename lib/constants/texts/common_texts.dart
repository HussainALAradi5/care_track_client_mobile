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
  };
}
