import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/workforce/decision_request.dart';
import '../../models/workforce/leave_request.dart';
import '../core/service_providers.dart';
import 'leave_requests_controller.dart';
import 'my_leave_controller.dart';

/// The approve, reject and cancel steps every leave screen shares; each reloads whatever may have changed.
class LeaveActions {
  LeaveActions(this._ref);

  final Ref _ref;

  Future<void> decide(LeaveRequest request, {required bool approve, String? note}) => _change(
    (organizationId) => _ref
        .read(leaveServiceProvider)
        .decide(
          organizationId,
          request.id,
          DecisionRequest(approve: approve, expectedVersion: request.version, note: note),
        ),
  );

  Future<void> cancel(LeaveRequest request) =>
      _change((organizationId) => _ref.read(leaveServiceProvider).cancel(organizationId, request));

  Future<void> _change(Future<Object?> Function(String organizationId) call) async {
    final organizationId = _ref.read(leaveOrganizationIdProvider);
    if (organizationId == null) return;
    try {
      await call(organizationId);
    } finally {
      _ref
        ..invalidate(myLeaveProvider)
        ..invalidate(leaveToDecideProvider)
        ..invalidate(leaveRequestsProvider);
    }
  }
}

final leaveActionsProvider = Provider(LeaveActions.new);
