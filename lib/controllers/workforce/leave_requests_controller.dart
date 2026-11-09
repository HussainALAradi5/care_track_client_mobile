import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/identity/staff_hospital.dart';
import '../../models/workforce/leave_request.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';
import 'leave_status_filter_controller.dart';

/// Everyone's leave in the Organization; it loads nothing without LEAVE:READ_ALL at the selected Hospital.
class LeaveRequestsController extends HospitalPagedController<LeaveRequest> {
  String? _organizationIdOf(StaffHospital? hospital) =>
      hospital != null && hospital.can(PermissionCodes.leaveReadAll) ? hospital.organizationId : null;

  @override
  String? watchHospitalId() {
    ref.watch(leaveStatusFilterProvider);
    return _organizationIdOf(ref.watch(selectedStaffHospitalProvider));
  }

  @override
  String? readHospitalId() => _organizationIdOf(ref.read(selectedStaffHospitalProvider));

  @override
  Future<PageResult<LeaveRequest>> fetch(String hospitalId, PageRequest request) {
    final filtered = PageRequest(
      page: request.page,
      pageSize: request.pageSize,
      filters: {'status': ref.read(leaveStatusFilterProvider)?.wire},
    );
    return ref.read(leaveServiceProvider).queue(hospitalId, filtered);
  }
}

final leaveRequestsProvider = AsyncNotifierProvider.autoDispose<LeaveRequestsController, PagedItems<LeaveRequest>>(
  LeaveRequestsController.new,
);
