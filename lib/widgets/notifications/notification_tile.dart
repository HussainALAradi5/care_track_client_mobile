import 'package:flutter/material.dart';

import '../../constants/texts/notification_texts.dart';
import '../../enums/notifications/notification_link_type.dart';
import '../../models/notifications/app_notification.dart';
import '../../utilities/time/dates.dart';

/// One inbox row: unread rows are highlighted; tapping marks it read and opens what it points at.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(_iconOf(notification.linkType), color: scheme.primary),
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: notification.read ? FontWeight.w400 : FontWeight.w700),
        ),
        subtitle: Text(shortDateTime(notification.createdAt.toLocal())),
        trailing: notification.read
            ? null
            : Icon(Icons.circle, size: 10, color: scheme.primary, semanticLabel: NotificationTexts.unread),
      ),
    );
  }

  IconData _iconOf(NotificationLinkType type) => switch (type) {
    NotificationLinkType.appointment => Icons.event_available_outlined,
    NotificationLinkType.booking => Icons.pending_actions_outlined,
    NotificationLinkType.prescription => Icons.medication_outlined,
    NotificationLinkType.payment || NotificationLinkType.refund => Icons.payments_outlined,
    NotificationLinkType.leaveRequest => Icons.beach_access_outlined,
    NotificationLinkType.staffRequest => Icons.assignment_outlined,
    NotificationLinkType.payslips => Icons.receipt_long_outlined,
  };
}
