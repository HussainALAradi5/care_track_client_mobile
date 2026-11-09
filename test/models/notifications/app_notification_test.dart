import 'package:care_track_client_mobile/enums/notifications/notification_link_type.dart';
import 'package:care_track_client_mobile/models/notifications/app_notification.dart';
import 'package:care_track_client_mobile/models/notifications/live_notification.dart';
import 'package:care_track_client_mobile/models/notifications/notification_read_state.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> notificationJson({bool read = false, String? linkId = 'a1'}) => {
  'id': 'n1',
  'type': 'BOOKING_CONFIRMED',
  'titleKey': 'notifications.bookingConfirmed',
  'title': 'Your booking is confirmed',
  'linkType': 'APPOINTMENT',
  'linkId': linkId,
  'hospitalId': 'h1',
  'read': read,
  'readAt': null,
  'createdAt': '2026-11-09T09:00:00Z',
};

void main() {
  test('parses a server notification', () {
    final notification = AppNotification.fromJson(notificationJson());
    expect(notification.id, 'n1');
    expect(notification.type, 'BOOKING_CONFIRMED');
    expect(notification.linkType, NotificationLinkType.appointment);
    expect(notification.linkId, 'a1');
    expect(notification.read, isFalse);
    expect(notification.createdAt, DateTime.utc(2026, 11, 9, 9));
  });

  test('accepts an event with nothing to link to', () {
    final notification = AppNotification.fromJson({
      ...notificationJson(linkId: null),
      'linkType': 'PAYSLIPS',
      'hospitalId': null,
    });
    expect(notification.linkId, isNull);
    expect(notification.hospitalId, isNull);
    expect(notification.linkType, NotificationLinkType.payslips);
  });

  test('parses a live message and keeps quiet hours', () {
    final live = LiveNotification.fromJson({'notification': notificationJson(), 'quiet': true});
    expect(live.notification.id, 'n1');
    expect(live.quiet, isTrue);
  });

  test('parses a read change on another device', () {
    expect(NotificationReadState.fromJson({'notificationId': 'n1', 'unreadCount': 3}).unreadCount, 3);
    expect(NotificationReadState.fromJson({'notificationId': null, 'unreadCount': 0}).notificationId, isNull);
  });
}
