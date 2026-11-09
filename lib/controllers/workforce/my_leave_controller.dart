import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/leave_rules.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/workforce/leave_status.dart';
import '../../models/workforce/leave_request.dart';
import '../../models/workforce/my_leave.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';

/// The selected Hospital's Organization, whose leave this is; null signed out, so every leave list resets then.
final leaveOrganizationIdProvider = Provider<String?>(
  (ref) => ref.watch(selectedStaffHospitalProvider)?.organizationId,
);

/// The signed-in person's leave this year.
class MyLeaveController extends AsyncNotifier<MyLeave?> {
  @override
  Future<MyLeave?> build() async {
    final organizationId = ref.watch(leaveOrganizationIdProvider);
    if (organizationId == null) return null;
    return ref.read(leaveServiceProvider).mine(organizationId, DateTime.now().year);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final myLeaveProvider = AsyncNotifierProvider<MyLeaveController, MyLeave?>(MyLeaveController.new);

/// The people who report to the caller, waiting for a decision. Empty for anyone else.
final leaveToDecideProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final organizationId = ref.watch(leaveOrganizationIdProvider);
  if (organizationId == null) return const [];
  try {
    final page = await ref
        .read(leaveServiceProvider)
        .queue(
          organizationId,
          PageRequest(page: 0, pageSize: LeaveRules.decideQueueSize, filters: {'status': LeaveStatus.requested.wire}),
        );
    return page.items.where((r) => r.canDecide).toList();
  } catch (_) {
    // Someone who cannot decide anything gets a refusal, which is not an error here.
    return const [];
  }
});
