import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/realtime.dart';
import '../../models/notifications/live_notification.dart';
import '../../models/notifications/notification_read_state.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import 'notification_inbox_controller.dart';
import 'unread_count_controller.dart';

/// Runs the live channel while someone is signed in: new rows and read changes flow into the inbox and the badge.
/// After a reconnect the inbox and count are read again, since messages sent during the gap are gone.
final notificationLiveProvider = Provider<void>((ref) {
  final signedIn = ref.watch(authControllerProvider.select((auth) => auth.value != null));
  if (!signedIn) return;
  final channel = ref.read(realtimeChannelProvider);
  final subscriptions = [
    channel.watch(Realtime.notificationsQueue).listen((json) {
      final live = LiveNotification.fromJson(json);
      final isNew = ref.read(notificationInboxProvider.notifier).receive(live.notification);
      if (isNew && !live.notification.read) ref.read(unreadCountProvider.notifier).increase();
    }),
    channel.watch(Realtime.readStateQueue).listen((json) {
      final state = NotificationReadState.fromJson(json);
      ref.read(notificationInboxProvider.notifier).applyRead(state.notificationId);
      ref.read(unreadCountProvider.notifier).setCount(state.unreadCount);
    }),
    channel.opened.listen((_) {
      ref.invalidate(notificationInboxProvider);
      ref.invalidate(unreadCountProvider);
    }),
  ];
  channel.connect();
  ref.onDispose(() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    channel.disconnect();
  });
});
