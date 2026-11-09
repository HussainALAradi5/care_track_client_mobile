/// Server routes relative to `{apiUrl}/api`; keep in step with the Spring controllers.
class Endpoints {
  const Endpoints._();

  static const me = '/auth/me';
  static const myPickerStyle = '/auth/me/picker-style';
  static const myPayslips = '/auth/me/payslips';
  static String myPayslip(String payslipId) => '/auth/me/payslips/$payslipId';
  static const myTeam = '/auth/me/team';
  static const myDepartments = '/auth/me/departments';
  static const signUp = '/auth/sign-up';
  static const linkInvitation = '/auth/link-invitation';

  // Public catalog (no sign-in needed)
  static const publicCountries = '/public/countries';
  static String publicCities(String countryId) => '/public/countries/$countryId/cities';
  static const publicAllCountries = '/public/places/countries';
  static String publicAllCities(String countryId) => '/public/places/countries/$countryId/cities';
  static const publicHospitals = '/public/hospitals';
  static const hospitalsNearMe = '/hospitals/matching-my-residence';

  static const chatConversations = '/chat/conversations';
  static String chatConversation(String id) => '/chat/conversations/$id';
  static String chatMessages(String id) => '/chat/conversations/$id/messages';
  static String chatRead(String id) => '/chat/conversations/$id/read';
  static String chatDelivered(String id) => '/chat/conversations/$id/delivered';
  static String chatMessage(String id, String messageId) => '${chatMessages(id)}/$messageId';
  static String chatMessageHistory(String id, String messageId) => '${chatMessage(id, messageId)}/history';
  static String chatReaction(String id, String messageId) => '${chatMessage(id, messageId)}/reaction';
  static String chatMute(String id) => '/chat/conversations/$id/mute';
  static String chatHide(String id) => '/chat/conversations/$id/hide';
  static String chatTyping(String id) => '/chat/conversations/$id/typing';
  static String chatAttachments(String id) => '/chat/conversations/$id/attachments';
  static String chatAttachmentDownload(String id, String assetId) => '${chatAttachments(id)}/$assetId/download';
  static const chatHospitals = '/chat/hospitals';
  static String chatContacts(String hospitalId) => '/chat/hospitals/$hospitalId/contacts';
  static const notifications = '/notifications';
  static const notificationsUnreadCount = '/notifications/unread-count';
  static const notificationsReadAll = '/notifications/read-all';
  static const notificationPreferences = '/notifications/preferences';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const myStaffHospitals = '/auth/me/hospitals';
  static const myOrganizations = '/auth/me/organizations';
  static const myHospitals = '/patients/me/hospitals';
  static const enrollMe = '/patients/me/hospitals';
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
  static String decideStaffRequest(String organizationId, String requestId) =>
      '${staffRequests(organizationId)}/$requestId/decision';
  static String cancelStaffRequest(String organizationId, String requestId) =>
      '${staffRequests(organizationId)}/$requestId/cancel';

  // Attendance
  static String attendanceToday(String hospitalId) => '/hospitals/$hospitalId/attendance/me/today';
  static String clockIn(String hospitalId) => '/hospitals/$hospitalId/attendance/me/clock-in';
  static String clockOut(String hospitalId) => '/hospitals/$hospitalId/attendance/me/clock-out';
  static String myAttendance(String hospitalId) => '/hospitals/$hospitalId/attendance/me';
  static String attendanceDay(String hospitalId) => '/hospitals/$hospitalId/attendance/day';

  // Leave (one Organization's)
  static String myLeave(String organizationId) => '/organizations/$organizationId/leave/mine';
  static String leaveRequests(String organizationId) => '/organizations/$organizationId/leave/requests';
  static String leaveDecision(String organizationId, String requestId) =>
      '${leaveRequests(organizationId)}/$requestId/decision';
  static String leaveCancel(String organizationId, String requestId) =>
      '${leaveRequests(organizationId)}/$requestId/cancel';

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
