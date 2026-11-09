import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/decision_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/identity/staff_hospital.dart';
import '../../models/workforce/staff_request.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';
import 'staff_request_status_filter_controller.dart';

/// HR's list; it loads nothing without STAFF_REQUEST:HANDLE at the selected Hospital.
class StaffRequestsController extends HospitalPagedController<StaffRequest> {
  String? _organizationIdOf(StaffHospital? hospital) =>
      hospital != null && hospital.can(PermissionCodes.staffRequestHandle) ? hospital.organizationId : null;

  @override
  String? watchHospitalId() {
    ref.watch(staffRequestStatusFilterProvider);
    return _organizationIdOf(ref.watch(selectedStaffHospitalProvider));
  }

  @override
  String? readHospitalId() => _organizationIdOf(ref.read(selectedStaffHospitalProvider));

  @override
  Future<PageResult<StaffRequest>> fetch(String hospitalId, PageRequest request) {
    final filtered = PageRequest(
      page: request.page,
      pageSize: request.pageSize,
      filters: {'status': ref.read(staffRequestStatusFilterProvider)?.wire},
    );
    return ref.read(staffRequestServiceProvider).forHr(hospitalId, filtered);
  }

  Future<void> decide(StaffRequest request, {required bool approve, String? note}) async {
    final organizationId = readHospitalId();
    if (organizationId == null) return;
    await changeThenRefresh(
      () => ref
          .read(staffRequestServiceProvider)
          .decide(
            organizationId,
            request.id,
            DecisionRequest(approve: approve, expectedVersion: request.version, note: note),
          ),
    );
  }
}

final staffRequestsProvider = AsyncNotifierProvider.autoDispose<StaffRequestsController, PagedItems<StaffRequest>>(
  StaffRequestsController.new,
);
