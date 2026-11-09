import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/chat_constants.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_thread_controller.dart';
import '../../models/chat/chat_message.dart';
import 'chat_action.dart';

/// What can be done with a message: react, reply, and for the sender edit and delete.
Future<void> showMessageActions(
  BuildContext context, {
  required ChatMessage message,
  required bool mine,
  required String? myReaction,
  required ChatThreadController controller,
}) => showModalBottomSheet<void>(
  context: context,
  builder: (sheet) {
    void close(Future<void> Function() action) {
      Navigator.of(sheet).pop();
      runChatAction(context, action);
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.card,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final emoji in ChatConstants.reactions)
                  TextButton(
                    onPressed: () => close(() => controller.react(message, emoji == myReaction ? null : emoji)),
                    child: Text(emoji),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.reply_rounded),
            title: const Text(ChatTexts.reply),
            onTap: () => close(() async => controller.setReplyTo(message)),
          ),
          if (mine) ...[
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text(ChatTexts.edit),
              onTap: () => close(() async => controller.setEditing(message)),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text(ChatTexts.delete),
              onTap: () => close(() => controller.remove(message)),
            ),
          ],
        ],
      ),
    );
  },
);
