import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../models/care/appointment.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import 'hospital_paged_controller.dart';

class AppointmentsController extends HospitalPagedController<Appointment> {
  @override
  Future<PageResult<Appointment>> fetch(String hospitalId, PageRequest request) =>
      ref.read(appointmentServiceProvider).mine(hospitalId, request);

  Future<void> cancel(Appointment appointment, String reason) async {
    await ref.read(appointmentServiceProvider).cancel(appointment, reason);
    await refresh();
  }
}

final appointmentsProvider = AsyncNotifierProvider<AppointmentsController, PagedItems<Appointment>>(
  AppointmentsController.new,
);
