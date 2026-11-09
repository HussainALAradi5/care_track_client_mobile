import 'app_notification.dart';

/// A message on the user's queue; [quiet] means it arrived in quiet hours: it counts, but does not interrupt.
class LiveNotification {
  const LiveNotification({required this.notification, required this.quiet});

  final AppNotification notification;
  final bool quiet;

  factory LiveNotification.fromJson(Map<String, dynamic> json) => LiveNotification(
    notification: AppNotification.fromJson(json['notification'] as Map<String, dynamic>),
    quiet: json['quiet'] as bool,
  );
}
