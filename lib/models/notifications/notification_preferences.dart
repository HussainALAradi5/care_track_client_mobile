import 'package:flutter/material.dart' show TimeOfDay;

import '../../constants/notification_rules.dart';
import '../../utilities/time/dates.dart';
import 'notification_type_preference.dart';

/// Server NotificationPreferencesDto: each type's channels, and quiet hours (both times, or neither on the wire).
class NotificationPreferences {
  const NotificationPreferences({
    required this.types,
    required this.quietOn,
    this.quietStart = NotificationRules.defaultQuietStart,
    this.quietEnd = NotificationRules.defaultQuietEnd,
  });

  final List<NotificationTypePreference> types;
  final bool quietOn;
  final TimeOfDay quietStart;
  final TimeOfDay quietEnd;

  NotificationPreferences copyWith({
    List<NotificationTypePreference>? types,
    bool? quietOn,
    TimeOfDay? quietStart,
    TimeOfDay? quietEnd,
  }) => NotificationPreferences(
    types: types ?? this.types,
    quietOn: quietOn ?? this.quietOn,
    quietStart: quietStart ?? this.quietStart,
    quietEnd: quietEnd ?? this.quietEnd,
  );

  /// SaveNotificationPreferencesRequest body.
  Map<String, dynamic> toSaveJson() => {
    'types': [for (final t in types) t.toJson()],
    'quietHoursStart': quietOn ? hourMinute(quietStart) : null,
    'quietHoursEnd': quietOn ? hourMinute(quietEnd) : null,
  };

  static TimeOfDay? _time(Object? value) {
    if (value == null) return null;
    final parts = (value as String).split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final start = _time(json['quietHoursStart']);
    final end = _time(json['quietHoursEnd']);
    return NotificationPreferences(
      types: [
        for (final t in json['types'] as List<dynamic>) NotificationTypePreference.fromJson(t as Map<String, dynamic>),
      ],
      quietOn: start != null,
      quietStart: start ?? NotificationRules.defaultQuietStart,
      quietEnd: end ?? NotificationRules.defaultQuietEnd,
    );
  }
}
