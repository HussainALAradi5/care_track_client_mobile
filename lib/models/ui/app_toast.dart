import '../notifications/app_notification.dart';

/// A message floated over any screen: a plain [message], or a live [notification] with an action that opens it.
class AppToast {
  const AppToast({required this.message, this.actionLabel, this.notification});

  final String message;
  final String? actionLabel;
  final AppNotification? notification;
}
