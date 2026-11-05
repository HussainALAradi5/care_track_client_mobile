import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/shift_rules.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/create_shift_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/workforce/clinician_shift.dart';
import '../../models/workforce/shift_clinician.dart';
import '../care/staff_paged_controller.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';
import 'shift_filter_controller.dart';

/// Shifts at the selected Hospital that have not ended yet, soonest first, optionally for one person.
class ShiftsController extends StaffPagedController<ClinicianShift> {
  @override
  String get permission => PermissionCodes.shiftWrite;

  @override
  Future<PagedItems<ClinicianShift>> build() {
    ref.watch(shiftFilterProvider);
    return super.build();
  }

  @override
  Future<PageResult<ClinicianShift>> fetch(String hospitalId, PageRequest request) => ref
      .read(shiftServiceProvider)
      .list(
        hospitalId,
        PageRequest(
          page: request.page,
          pageSize: request.pageSize,
          filters: {'clinicianId': ref.read(shiftFilterProvider)},
        ),
      );

  Future<void> add(CreateShiftRequest request) async {
    final hospitalId = readHospitalId();
    if (hospitalId == null) return;
    await ref.read(shiftServiceProvider).create(hospitalId, request);
    await refresh();
  }

  Future<void> remove(ClinicianShift shift) => changeThenRefresh(() => ref.read(shiftServiceProvider).remove(shift));
}

final shiftsProvider = AsyncNotifierProvider<ShiftsController, PagedItems<ClinicianShift>>(ShiftsController.new);

/// The doctors and nurses a shift can be given to at the selected Hospital, by name.
final shiftCliniciansProvider = FutureProvider<List<ShiftClinician>>((ref) async {
  final hospital = ref.watch(selectedStaffHospitalProvider);
  if (hospital == null || !hospital.can(PermissionCodes.shiftWrite)) return const [];
  final page = await ref
      .read(shiftServiceProvider)
      .clinicians(hospital.hospitalId, const PageRequest(page: 0, pageSize: ShiftRules.maxClinicians));
  return page.items;
});
