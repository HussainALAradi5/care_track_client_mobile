class RoutePaths {
  const RoutePaths._();

  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const book = '/book';
  static const requests = '/requests';
  static const visits = '/visits';
  static const documents = '/documents';
  static const find = '/find';
  static const hospitals = '/hospitals';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const chat = '/chat';
  static String chatThread(String id) => '/chat/$id';

  static const staff = '/staff';
  static const staffQueue = '/staff/queue';
  static const staffDesk = '/staff/desk';
  static const staffShifts = '/staff/shifts';
  static const staffVisits = '/staff/visits';
  static const staffRequests = '/staff/requests';
  static const staffLeave = '/staff/leave';
  static String staffLeaveWithSickNote(String documentId) => '/staff/leave?sickNote=$documentId';
  static const staffLeaveRequests = '/staff/leave-requests';

  static const books = '/books';
  static const booksJournal = '/books/journal';
  static const booksReports = '/books/reports';
}
