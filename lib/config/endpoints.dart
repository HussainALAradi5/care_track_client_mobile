/// Server routes relative to `{apiUrl}/api`; keep in step with the Spring controllers.
class Endpoints {
  const Endpoints._();

  static const me = '/auth/me';
  static const myHospitals = '/patients/me/hospitals';
  static String myCareTeam(String hospitalId) => '/hospitals/$hospitalId/patients/me/care-team';
  static String myAppointments(String hospitalId) => '/hospitals/$hospitalId/patients/me/appointments';
  static String createBooking(String hospitalId) => '/hospitals/$hospitalId/bookings';
  static String myBookings(String hospitalId) => '/hospitals/$hospitalId/bookings/mine';
  static String cancelBooking(String hospitalId, String bookingId) =>
      '/hospitals/$hospitalId/bookings/$bookingId/cancel';
  static String cancelAppointment(String hospitalId, String appointmentId) =>
      '/hospitals/$hospitalId/appointments/$appointmentId/cancel';
}
