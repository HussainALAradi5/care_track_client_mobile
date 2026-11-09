import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';
import '../../enums/chat/thread_menu_action.dart';
import '../../models/chat/conversation.dart';

/// A conversation's own actions: mute or unmute, and hide.
class ThreadMenu extends StatelessWidget {
  const ThreadMenu({super.key, required this.conversation, required this.onSelected});

  final Conversation conversation;
  final ValueChanged<ThreadMenuAction> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<ThreadMenuAction>(
    onSelected: onSelected,
    itemBuilder: (_) => [
      PopupMenuItem(
        value: ThreadMenuAction.mute,
        child: Text(conversation.muted ? ChatTexts.unmute : ChatTexts.mute),
      ),
      const PopupMenuItem(value: ThreadMenuAction.hide, child: Text(ChatTexts.hide)),
    ],
  );
}
