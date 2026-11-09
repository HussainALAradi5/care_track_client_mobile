import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/route_paths.dart';
import '../../models/notifications/app_notification.dart';
import '../../utilities/notifications/notification_route.dart';
import '../auth/auth_controller.dart';
import '../care/patient_context_controller.dart';
import '../identity/care_mode_controller.dart';
import '../identity/staff_context_controller.dart';
import 'notification_inbox_controller.dart';

/// What opening a notification does, from the inbox or a toast: picks its Hospital, marks it read, and says where to go.
class NotificationOpener {
  NotificationOpener(this._ref);

  final Ref _ref;

  Future<String?> open(AppNotification notification) async {
    final user = _ref.read(authControllerProvider).value;
    final staffSide = (user?.userType.isStaff ?? false) && !_ref.read(careModeProvider);
    final path = notificationRoute(notification.linkType, staff: staffSide, linkId: notification.linkId);
    _selectHospital(notification.hospitalId, staffSide);
    await _ref.read(notificationInboxProvider.notifier).markRead(notification);
    // A work notification opened from My care goes back to work.
    if (path != null && path.startsWith(RoutePaths.staff) && (user?.userType.isStaff ?? false)) {
      await _ref.read(careModeProvider.notifier).set(false);
    }
    return path;
  }

  void _selectHospital(String? hospitalId, bool staffSide) {
    if (hospitalId == null) return;
    if (staffSide) {
      final known = _ref.read(staffContextProvider).value?.hospitals.any((h) => h.hospitalId == hospitalId) ?? false;
      if (known) _ref.read(staffContextProvider.notifier).select(hospitalId);
    } else {
      final known = _ref.read(patientContextProvider).value?.hospitals.any((h) => h.id == hospitalId) ?? false;
      if (known) _ref.read(patientContextProvider.notifier).select(hospitalId);
    }
  }
}

final notificationOpenerProvider = Provider(NotificationOpener.new);
