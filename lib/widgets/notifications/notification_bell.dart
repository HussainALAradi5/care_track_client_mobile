import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/notification_texts.dart';
import '../../controllers/notifications/notification_live_controller.dart';
import '../../controllers/notifications/unread_count_controller.dart';

/// The app bar bell: opens the inbox and shows the unread count. Keeps the live channel running while it is on screen.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationLiveProvider);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    return IconButton(
      tooltip: NotificationTexts.openInbox,
      onPressed: () => context.push(RoutePaths.notifications),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > NotificationTexts.maxBadge ? '${NotificationTexts.maxBadge}+' : '$unread'),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
