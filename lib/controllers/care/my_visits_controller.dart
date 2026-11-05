import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../models/care/appointment.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import 'staff_paged_controller.dart';

/// The clinician's own visits at the selected Hospital.
class MyVisitsController extends StaffPagedController<Appointment> {
  @override
  String get permission => PermissionCodes.clinicalHistoryWrite;

  @override
  Future<PageResult<Appointment>> fetch(String hospitalId, PageRequest request) =>
      ref.read(appointmentServiceProvider).clinicianMine(hospitalId, request);
}

final myVisitsProvider = AsyncNotifierProvider<MyVisitsController, PagedItems<Appointment>>(MyVisitsController.new);
