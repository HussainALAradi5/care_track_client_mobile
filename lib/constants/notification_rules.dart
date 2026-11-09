import 'package:flutter/material.dart' show TimeOfDay;

/// Defaults of the notification settings.
class NotificationRules {
  const NotificationRules._();

  static const defaultQuietStart = TimeOfDay(hour: 22, minute: 0);
  static const defaultQuietEnd = TimeOfDay(hour: 7, minute: 0);
  static const toastSeconds = Duration(seconds: 6);
}
