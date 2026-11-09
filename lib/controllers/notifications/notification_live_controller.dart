import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/realtime.dart';
import '../../constants/texts/notification_texts.dart';
import '../../models/ui/app_toast.dart';
import '../../models/notifications/live_notification.dart';
import '../../models/notifications/notification_read_state.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import '../ui/app_toast_controller.dart';
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
      // During quiet hours it still counts, but nothing pops up.
      if (isNew && !live.quiet) {
        ref
            .read(appToastProvider.notifier)
            .show(
              AppToast(
                message: live.notification.title,
                actionLabel: NotificationTexts.actionLabels[live.notification.linkType],
                notification: live.notification,
              ),
            );
      }
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
