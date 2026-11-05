import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/common/sort_direction.dart';
import '../../enums/identity/presence_verification_method.dart';
import '../../models/care/appointment.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import 'desk_filter_controller.dart';
import 'staff_paged_controller.dart';

/// Appointments desk: the selected Hospital's visits in the chosen tab, soonest first.
class DeskController extends StaffPagedController<Appointment> {
  @override
  String get permission => PermissionCodes.appointmentReadAll;

  @override
  Future<PagedItems<Appointment>> build() {
    ref.watch(deskFilterProvider);
    return super.build();
  }

  @override
  Future<PageResult<Appointment>> fetch(String hospitalId, PageRequest request) => ref
      .read(appointmentServiceProvider)
      .list(
        hospitalId,
        PageRequest(
          page: request.page,
          pageSize: request.pageSize,
          sortDirection: SortDirection.ascending,
          filters: {'status': ref.read(deskFilterProvider).wire},
        ),
      );

  Future<void> checkIn(Appointment appointment, PresenceVerificationMethod method) =>
      changeThenRefresh(() => ref.read(appointmentServiceProvider).checkIn(appointment, method));

  Future<void> markNoShow(Appointment appointment, String reason) =>
      changeThenRefresh(() => ref.read(appointmentServiceProvider).markNoShow(appointment, reason));

  Future<void> markNotSeen(Appointment appointment, String reason) =>
      changeThenRefresh(() => ref.read(appointmentServiceProvider).markNotSeen(appointment, reason));
}

final deskProvider = AsyncNotifierProvider<DeskController, PagedItems<Appointment>>(DeskController.new);
