import 'package:flutter/material.dart';

import '../../constants/chat_styles.dart';
import '../../enums/chat/chat_attachment_status.dart';
import '../../models/chat/chat_attachment.dart';

/// One attachment of a message: only an available file can be downloaded; the rest say why not.
class AttachmentTile extends StatelessWidget {
  const AttachmentTile({super.key, required this.attachment, required this.onDownload});

  final ChatAttachment attachment;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final style = ChatStyles.attachmentStatus[attachment.status]!;
    return TextButton.icon(
      onPressed: attachment.status == ChatAttachmentStatus.available ? onDownload : null,
      icon: Icon(style.icon),
      label: Text(style.label),
    );
  }
}
