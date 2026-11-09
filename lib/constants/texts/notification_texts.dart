import '../../enums/notifications/notification_link_type.dart';

/// Text of the notifications inbox.
class NotificationTexts {
  const NotificationTexts._();

  static const title = 'Notifications';
  static const empty = 'Nothing new';
  static const emptyHint = 'Updates about your bookings, visits and requests appear here.';
  static const markAllRead = 'Mark all as read';
  static const openInbox = 'Open notifications';
  static const unread = 'Unread';
  static const maxBadge = 99;

  static const preferencesTitle = 'Notifications';
  static const preferencesHint = 'Choose how each kind of news reaches you. Your inbox always keeps a copy.';
  static const preferencesProviderNote = 'In the app works now; push and email are saved for when they are connected.';
  static const inApp = 'In the app';
  static const push = 'Push';
  static const email = 'Email';
  static const quietHoursOn = 'Use quiet hours';
  static const quietHoursHint = 'During quiet hours nothing pops up; your inbox still fills. Times follow the hospital clock.';
  static const quietStart = 'From';
  static const quietEnd = 'To';
  static const preferencesSave = 'Save notification settings';
  static const preferencesSaved = 'Notification settings saved.';

  /// What each kind of notification is called, by the server's NotificationType.
  static const typeLabels = {
    'BOOKING_CONFIRMED': 'Booking confirmed',
    'BOOKING_REJECTED': 'Booking declined',
    'APPOINTMENT_CANCELLED': 'Appointment cancelled',
    'PRESCRIPTION_READY': 'Prescription ready',
    'PAYMENT_RECORDED': 'Payment recorded',
    'REFUND_RECORDED': 'Refund recorded',
    'LEAVE_APPROVED': 'Leave approved',
    'LEAVE_REJECTED': 'Leave declined',
    'STAFF_REQUEST_APPROVED': 'HR request approved',
    'STAFF_REQUEST_REJECTED': 'HR request declined',
    'PAYSLIP_APPROVED': 'Payslip approved',
    'CHAT_MESSAGE': 'New message',
  };

  /// What the action of a toast says, by where it opens.
  static const actionLabels = {
    NotificationLinkType.appointment: 'View appointment',
    NotificationLinkType.booking: 'View booking',
    NotificationLinkType.prescription: 'View visits',
    NotificationLinkType.payment: 'View visits',
    NotificationLinkType.refund: 'View visits',
    NotificationLinkType.leaveRequest: 'View leave',
    NotificationLinkType.staffRequest: 'View request',
    NotificationLinkType.payslips: 'View payslips',
    NotificationLinkType.chatConversation: 'Open conversation',
  };
}
