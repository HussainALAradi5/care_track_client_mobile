import 'package:flutter/material.dart';

import '../enums/chat/chat_attachment_status.dart';
import '../enums/ui/status_tone.dart';
import '../models/ui/status_style.dart';

/// What an attachment says for each status.
class ChatStyles {
  const ChatStyles._();

  static const attachmentStatus = <ChatAttachmentStatus, StatusStyle>{
    ChatAttachmentStatus.available: StatusStyle(label: 'Download', tone: StatusTone.success, icon: Icons.download_rounded),
    ChatAttachmentStatus.quarantined: StatusStyle(label: 'Awaiting file check', tone: StatusTone.warning, icon: Icons.hourglass_top_rounded),
    ChatAttachmentStatus.rejected: StatusStyle(label: 'Blocked by the file check', tone: StatusTone.danger, icon: Icons.block_rounded),
    ChatAttachmentStatus.revoked: StatusStyle(label: 'No longer available', tone: StatusTone.neutral, icon: Icons.link_off_rounded),
  };
}
