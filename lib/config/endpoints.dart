/// Server routes relative to `{apiUrl}/api`; keep in step with the Spring controllers.
class Endpoints {
  const Endpoints._();

  static const me = '/auth/me';
  static const myStaffHospitals = '/auth/me/hospitals';
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
}
