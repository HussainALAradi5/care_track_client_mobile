import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';
import '../../models/chat/conversation.dart';
import '../../utilities/time/dates.dart';
import 'presence_dot.dart';

/// One conversation in the list: who, whether they are online, whether it is muted, and its unread count.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = conversation.unreadCount;
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Row(
          children: [
            PresenceDot(online: conversation.otherOnline),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                conversation.title,
                style: TextStyle(fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
            if (conversation.muted) const Icon(Icons.notifications_off_rounded, size: AppSpacing.iconSmall),
          ],
        ),
        subtitle: Text('${conversation.kind.label} · ${shortDateTime(conversation.lastMessageAt.toLocal())}'),
        trailing: unread > 0
            ? CircleAvatar(
                radius: AppSpacing.medium,
                child: Text(
                  unread > ChatTexts.maxBadge ? '${ChatTexts.maxBadge}+' : '$unread',
                  style: const TextStyle(fontSize: ChatTexts.badgeFontSize),
                ),
              )
            : null,
      ),
    );
  }
}
