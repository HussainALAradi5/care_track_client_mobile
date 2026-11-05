import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/care/appointment_status.dart';

/// The desk tab: visits waiting to arrive (SCHEDULED) or already checked in (CHECKED_IN).
class DeskFilterController extends Notifier<AppointmentStatus> {
  static const tabs = [AppointmentStatus.scheduled, AppointmentStatus.checkedIn];

  @override
  AppointmentStatus build() => tabs.first;

  void select(AppointmentStatus status) => state = status;
}

final deskFilterProvider = NotifierProvider<DeskFilterController, AppointmentStatus>(DeskFilterController.new);
