import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/create_staff_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/workforce/staff_request.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';

/// The signed-in person's requests to HR in the selected Hospital's Organization, newest first. Requests belong to
/// the Organization, so the id this list keys on is the Organization's; every staff member may open it.
class MyRequestsController extends HospitalPagedController<StaffRequest> {
  @override
  String? watchHospitalId() => ref.watch(selectedStaffHospitalProvider)?.organizationId;

  @override
  String? readHospitalId() => ref.read(selectedStaffHospitalProvider)?.organizationId;

  @override
  Future<PageResult<StaffRequest>> fetch(String hospitalId, PageRequest request) =>
      ref.read(staffRequestServiceProvider).mine(hospitalId, request);

  Future<void> add(CreateStaffRequest request) async {
    final organizationId = readHospitalId();
    if (organizationId == null) return;
    await ref.read(staffRequestServiceProvider).create(organizationId, request);
    await refresh();
  }

  Future<void> cancel(StaffRequest request) async {
    final organizationId = readHospitalId();
    if (organizationId == null) return;
    await changeThenRefresh(() => ref.read(staffRequestServiceProvider).cancel(organizationId, request));
  }
}

final myRequestsProvider = AsyncNotifierProvider<MyRequestsController, PagedItems<StaffRequest>>(
  MyRequestsController.new,
);
