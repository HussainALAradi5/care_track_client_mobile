import 'package:care_track_client_mobile/models/notifications/notification_preferences.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> preferencesJson({String? start, String? end}) => {
  'types': [
    {'type': 'LEAVE_APPROVED', 'inApp': true, 'push': false, 'email': false},
  ],
  'quietHoursStart': start,
  'quietHoursEnd': end,
};

void main() {
  test('parses NotificationPreferencesDto with quiet hours in LocalTime', () {
    final p = NotificationPreferences.fromJson(preferencesJson(start: '22:30:00', end: '06:45:00'));
    expect(p.quietOn, isTrue);
    expect(p.quietStart, const TimeOfDay(hour: 22, minute: 30));
    expect(p.types.single.type, 'LEAVE_APPROVED');
  });

  test('both times are null with quiet hours off', () {
    expect(NotificationPreferences.fromJson(preferencesJson()).quietOn, isFalse);
    final off = NotificationPreferences.fromJson(preferencesJson()).toSaveJson();
    expect(off['quietHoursStart'], isNull);
    expect(off['quietHoursEnd'], isNull);
  });

  test('saves the SaveNotificationPreferencesRequest field names', () {
    final on = NotificationPreferences.fromJson(preferencesJson(start: '22:30:00', end: '06:45:00')).toSaveJson();
    expect(on, {
      'types': [
        {'type': 'LEAVE_APPROVED', 'inApp': true, 'push': false, 'email': false},
      ],
      'quietHoursStart': '22:30',
      'quietHoursEnd': '06:45',
    });
  });
}
