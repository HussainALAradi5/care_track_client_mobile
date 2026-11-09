import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';

/// Above the composer while writing a reply.
class ReplyBanner extends StatelessWidget {
  const ReplyBanner({super.key, required this.quoted, required this.onCancel});

  final String quoted;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${ChatTexts.replyingTo}: $quoted',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(onPressed: onCancel, child: const Text(ChatTexts.cancel)),
        ],
      ),
    );
  }
}
