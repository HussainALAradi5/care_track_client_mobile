import '../../constants/route_paths.dart';
import '../../enums/notifications/notification_link_type.dart';

/// The screen a notification opens.
String? notificationRoute(NotificationLinkType type, {required bool staff, String? linkId}) => switch (type) {
  NotificationLinkType.booking => staff ? RoutePaths.staffQueue : RoutePaths.requests,
  NotificationLinkType.appointment ||
  NotificationLinkType.prescription ||
  NotificationLinkType.payment ||
  NotificationLinkType.refund => staff ? RoutePaths.staffVisits : RoutePaths.visits,
  NotificationLinkType.staffRequest => RoutePaths.staffRequests,
  NotificationLinkType.leaveRequest => RoutePaths.staffLeave,
  NotificationLinkType.payslips => RoutePaths.staffPayslips,
  NotificationLinkType.chatConversation => linkId == null ? RoutePaths.chat : RoutePaths.chatThread(linkId),
};
