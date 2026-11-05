import 'appointment.dart';

/// What the overview shows, derived from the latest requests and appointments.
class HomeSummary {
  const HomeSummary({
    required this.openRequests,
    required this.upcoming,
    required this.completed,
    required this.next,
  });

  final int openRequests;
  final int upcoming;
  final int completed;
  final Appointment? next;
}
