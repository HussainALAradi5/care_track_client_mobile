import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/workforce/staff_request_status.dart';

/// The status filter of Staff requests, waiting ones first; dropped when the screen closes.
class StaffRequestStatusFilterController extends Notifier<StaffRequestStatus?> {
  @override
  StaffRequestStatus? build() => StaffRequestStatus.requested;

  void set(StaffRequestStatus? value) => state = value;
}

final staffRequestStatusFilterProvider =
    NotifierProvider.autoDispose<StaffRequestStatusFilterController, StaffRequestStatus?>(
      StaffRequestStatusFilterController.new,
    );
