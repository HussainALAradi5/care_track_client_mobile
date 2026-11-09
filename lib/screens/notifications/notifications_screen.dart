import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/texts/notification_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/notifications/notification_inbox_controller.dart';
import '../../controllers/notifications/notification_live_controller.dart';
import '../../controllers/notifications/unread_count_controller.dart';
import '../../models/notifications/app_notification.dart';
import '../../utilities/notifications/notification_route.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/notifications/notification_tile.dart';

/// The signed-in person's inbox: live while open, with the read state shared by their devices.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationLiveProvider);
    final controller = ref.read(notificationInboxProvider.notifier);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text(NotificationTexts.title),
        actions: [
          if (unread > 0)
            IconButton(
              tooltip: NotificationTexts.markAllRead,
              onPressed: controller.markAllRead,
              icon: const Icon(Icons.done_all_rounded),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            PagedList<AppNotification>(
              value: ref.watch(notificationInboxProvider),
              idOf: (n) => n.id,
              emptyIcon: Icons.notifications_none_rounded,
              emptyTitle: NotificationTexts.empty,
              emptyHint: NotificationTexts.emptyHint,
              onRetry: controller.refresh,
              onLoadMore: controller.loadMore,
              itemBuilder: (n) => NotificationTile(notification: n, onTap: () => _open(context, ref, n)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, AppNotification notification) async {
    final path = notificationRoute(notification.linkType, staff: ref.read(authControllerProvider).value?.userType.isStaff ?? false, linkId: notification.linkId);
    await ref.read(notificationInboxProvider.notifier).markRead(notification);
    if (path != null && context.mounted) context.go(path);
  }
}
