import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../enums/care/appointment_status.dart';
import '../../enums/care/booking_status.dart';
import '../../models/care/home_summary.dart';
import '../core/service_providers.dart';
import 'patient_context_controller.dart';

/// Counts are exact server totals (one-row pages); the next visit is the soonest open one.
final homeSummaryProvider = FutureProvider<HomeSummary>((ref) async {
  final hospital = ref.watch(selectedHospitalProvider);
  if (hospital == null) return const HomeSummary(openRequests: 0, upcoming: 0, completed: 0, next: null);
  final bookings = ref.read(bookingServiceProvider);
  final appointments = ref.read(appointmentServiceProvider);
  PageRequest countOnly(Map<String, Object?> filters) => PageRequest(page: 0, pageSize: 1, filters: filters);
  final (waiting, upcoming, completed) = await (
    bookings.mine(hospital.id, countOnly({'status': BookingStatus.requested.wire})),
    appointments.mine(hospital.id, countOnly({'upcoming': true})),
    appointments.mine(hospital.id, countOnly({'status': AppointmentStatus.completed.wire})),
  ).wait;
  return HomeSummary(
    openRequests: waiting.totalItems,
    upcoming: upcoming.totalItems,
    completed: completed.totalItems,
    next: upcoming.items.isEmpty ? null : upcoming.items.first,
  );
});
