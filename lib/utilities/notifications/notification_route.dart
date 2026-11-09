import '../../constants/route_paths.dart';
import '../../enums/notifications/notification_link_type.dart';

/// The screen a notification opens; leave and payslips have no mobile screen yet, so those only mark as read.
String? notificationRoute(NotificationLinkType type, {required bool staff}) => switch (type) {
  NotificationLinkType.booking => staff ? RoutePaths.staffRequests : RoutePaths.requests,
  NotificationLinkType.appointment ||
  NotificationLinkType.prescription ||
  NotificationLinkType.payment ||
  NotificationLinkType.refund => staff ? RoutePaths.staffVisits : RoutePaths.visits,
  NotificationLinkType.staffRequest => RoutePaths.staffRequests,
  NotificationLinkType.leaveRequest || NotificationLinkType.payslips => null,
};
