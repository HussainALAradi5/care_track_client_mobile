import '../../constants/scheduling.dart';

/// Same rule as the server: a future interval of at most the maximum consultation length.
bool isValidBookingInterval(DateTime startsAt, DateTime endsAt, DateTime now) {
  final minutes = endsAt.difference(startsAt).inMinutes;
  return startsAt.isAfter(now) && minutes > 0 && minutes <= Scheduling.maxConsultationMinutes;
}
