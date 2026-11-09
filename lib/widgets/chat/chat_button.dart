import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/chat_conversations_controller.dart';
import '../../controllers/chat/chat_live_controller.dart';

/// The app bar's way into chat, with the unread total; keeps the chat queue running while it is on screen.
class ChatButton extends ConsumerWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatLiveProvider);
    final unread = ref.watch(chatUnreadTotalProvider);
    return IconButton(
      tooltip: ChatTexts.open,
      onPressed: () => context.push(RoutePaths.chat),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > ChatTexts.maxBadge ? '${ChatTexts.maxBadge}+' : '$unread'),
        child: const Icon(Icons.forum_outlined),
      ),
    );
  }
}
