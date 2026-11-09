import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/workforce/leave_status.dart';

/// The status filter of Leave requests, waiting ones first; dropped when the screen closes.
class LeaveStatusFilterController extends Notifier<LeaveStatus?> {
  @override
  LeaveStatus? build() => LeaveStatus.requested;

  void set(LeaveStatus? value) => state = value;
}

final leaveStatusFilterProvider = NotifierProvider.autoDispose<LeaveStatusFilterController, LeaveStatus?>(
  LeaveStatusFilterController.new,
);
