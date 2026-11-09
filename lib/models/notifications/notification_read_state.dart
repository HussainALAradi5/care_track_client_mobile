/// Another device read one notification (null: all of them), and the new unread total.
class NotificationReadState {
  const NotificationReadState({required this.notificationId, required this.unreadCount});

  final String? notificationId;
  final int unreadCount;

  factory NotificationReadState.fromJson(Map<String, dynamic> json) => NotificationReadState(
    notificationId: json['notificationId'] as String?,
    unreadCount: (json['unreadCount'] as num).toInt(),
  );
}
