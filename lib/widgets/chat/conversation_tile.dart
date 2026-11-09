import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';
import '../../models/chat/conversation.dart';
import '../../utilities/time/dates.dart';

/// One conversation in the list, with its unread count.
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
        title: Text(conversation.title, style: TextStyle(fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500)),
        subtitle: Text('${conversation.kind.label} · ${shortDateTime(conversation.lastMessageAt.toLocal())}'),
        trailing: unread > 0
            ? CircleAvatar(
                radius: 12,
                child: Text(
                  unread > ChatTexts.maxBadge ? '${ChatTexts.maxBadge}+' : '$unread',
                  style: const TextStyle(fontSize: 11),
                ),
              )
            : null,
      ),
    );
  }
}
