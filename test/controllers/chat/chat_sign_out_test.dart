import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_conversations_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_thread_controller.dart';
import 'package:care_track_client_mobile/controllers/notifications/notification_inbox_controller.dart';
import 'package:care_track_client_mobile/controllers/notifications/unread_count_controller.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

Object? responses(RequestOptions r) {
  if (r.path.endsWith('/chat/conversations')) return pageJson([conversationJson('c1', unread: 2)]);
  if (r.path.endsWith('/messages')) return messagesJson([messageJson(1)]);
  if (r.path.endsWith('/unread-count')) return {'unreadCount': 7};
  if (r.path.contains('/notifications')) {
    return pageJson([
      {
        'id': 'n1',
        'type': 'BOOKING_CONFIRMED',
        'titleKey': 'k',
        'title': 'T',
        'linkType': 'APPOINTMENT',
        'linkId': null,
        'hospitalId': null,
        'read': false,
        'readAt': null,
        'createdAt': '2026-11-09T09:00:00Z',
      },
    ]);
  }
  return <String, dynamic>{};
}

void main() {
  test('signing out empties the conversations, inbox and counts of the person who left', () async {
    final h = await chatHarness(responses);
    addTearDown(h.container.dispose);
    final c = h.container;
    expect((await c.read(chatConversationsProvider.future)).items.length, 1);
    expect((await c.read(notificationInboxProvider.future)).items.length, 1);
    expect(await c.read(unreadCountProvider.future), 7);
    expect(c.read(chatUnreadTotalProvider), 2);

    (c.read(authControllerProvider.notifier) as SwitchableAuth).become(null);

    expect((await c.read(chatConversationsProvider.future)).items, isEmpty);
    expect((await c.read(notificationInboxProvider.future)).items, isEmpty);
    expect(await c.read(unreadCountProvider.future), 0);
    expect(c.read(chatUnreadTotalProvider), 0);
  });

  test('the next person reads their own data, not what was held for the last one', () async {
    final h = await chatHarness(responses);
    addTearDown(h.container.dispose);
    final c = h.container;
    await c.read(chatConversationsProvider.future);
    final before = h.server.requests.where((r) => r.path.endsWith('/chat/conversations')).length;

    (c.read(authControllerProvider.notifier) as SwitchableAuth).become(
      const SessionUser(userId: 'b', name: 'B', userType: UserType.patient),
    );
    await c.read(chatConversationsProvider.future);

    expect(h.server.requests.where((r) => r.path.endsWith('/chat/conversations')).length, before + 1);
  });

  test('a thread held for one person is not shown to the next', () async {
    final h = await chatHarness(responses);
    addTearDown(h.container.dispose);
    final c = h.container;
    final thread = chatThreadProvider('c1');
    final sub = c.listen(thread, (_, _) {});
    await settle();
    expect(c.read(thread).messages, isNotEmpty);

    (c.read(authControllerProvider.notifier) as SwitchableAuth).become(null);
    await settle();

    expect(c.read(thread).messages, isEmpty);
    sub.close();
  });
}
