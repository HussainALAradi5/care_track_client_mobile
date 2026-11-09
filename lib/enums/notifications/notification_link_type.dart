/// Server NotificationLinkType: what a notification opens.
enum NotificationLinkType {
  appointment('APPOINTMENT'),
  booking('BOOKING'),
  prescription('PRESCRIPTION'),
  payment('PAYMENT'),
  refund('REFUND'),
  leaveRequest('LEAVE_REQUEST'),
  staffRequest('STAFF_REQUEST'),
  payslips('PAYSLIPS');

  const NotificationLinkType(this.wire);
  final String wire;

  static NotificationLinkType fromWire(String value) => values.firstWhere((t) => t.wire == value);
}
