/// Server routes relative to `{apiUrl}/api`; keep in step with the Spring controllers.
class Endpoints {
  const Endpoints._();

  static const me = '/auth/me';
  static const myPickerStyle = '/auth/me/picker-style';
  static const notifications = '/notifications';
  static const notificationsUnreadCount = '/notifications/unread-count';
  static const notificationsReadAll = '/notifications/read-all';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const myStaffHospitals = '/auth/me/hospitals';
  static const myOrganizations = '/auth/me/organizations';
  static const myHospitals = '/patients/me/hospitals';
  static String myCareTeam(String hospitalId) => '/hospitals/$hospitalId/patients/me/care-team';
  static String myAppointments(String hospitalId) => '/hospitals/$hospitalId/patients/me/appointments';
  static String createBooking(String hospitalId) => '/hospitals/$hospitalId/bookings';
  static String myBookings(String hospitalId) => '/hospitals/$hospitalId/bookings/mine';
  static String cancelBooking(String hospitalId, String bookingId) =>
      '/hospitals/$hospitalId/bookings/$bookingId/cancel';
  static String cancelAppointment(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/cancel';

  // Staff
  static String hospitalBookings(String hospitalId) => '/hospitals/$hospitalId/bookings';
  static String confirmBooking(String hospitalId, String bookingId) =>
      '/hospitals/$hospitalId/bookings/$bookingId/confirm';
  static String rejectBooking(String hospitalId, String bookingId) =>
      '/hospitals/$hospitalId/bookings/$bookingId/reject';
  static String hospitalAppointments(String hospitalId) => '/hospitals/$hospitalId/appointments';
  static String checkIn(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/check-in';
  static String noShow(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/no-show';
  static String notSeen(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/not-seen';
  static String shifts(String hospitalId) => '/hospitals/$hospitalId/clinician-shifts';
  static String shift(String hospitalId, String shiftId) => '/hospitals/$hospitalId/clinician-shifts/$shiftId';
  static String clinicians(String hospitalId) => '/hospitals/$hospitalId/clinicians';
  static String clinicianAppointments(String hospitalId) => '/hospitals/$hospitalId/clinicians/me/appointments';

  // Staff requests (one Organization's)
  static String staffRequests(String organizationId) => '/organizations/$organizationId/staff-requests';
  static String myStaffRequests(String organizationId) => '${staffRequests(organizationId)}/mine';
  static String cancelStaffRequest(String organizationId, String requestId) =>
      '${staffRequests(organizationId)}/$requestId/cancel';

  // Documents
  static const myDocuments = '/patients/me/documents';
  static String myDocument(String documentId) => '/patients/me/documents/$documentId';
  static String visitDocuments(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/documents';
  static String visitDocument(String hospitalId, String appointmentId, String documentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/documents/$documentId';

  // Accounting (one Organization's books)
  static String _books(String organizationId) => '/organizations/$organizationId/accounting';
  static String accountingStatus(String organizationId) => '${_books(organizationId)}/status';
  static String monthSummary(String organizationId) => '${_books(organizationId)}/reports/month-summary';
  static String report(String organizationId, String kind) => '${_books(organizationId)}/reports/$kind';
  static String journal(String organizationId) => '${_books(organizationId)}/journal-entries';
  static String journalEntry(String organizationId, String entryId) =>
      '${_books(organizationId)}/journal-entries/$entryId';
}
