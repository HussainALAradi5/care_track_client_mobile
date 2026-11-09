import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/chat_constants.dart';
import '../../models/chat/chat_upload.dart';
import '../../models/files/picked_attachment.dart';
import '../../utilities/chat/client_key.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The composer's files in one thread: each uploads at once, reporting its progress; the server's checks decide
/// what is kept.
class ChatUploadsController extends Notifier<List<ChatUpload>> {
  ChatUploadsController(this.conversationId);

  final String conversationId;

  @override
  List<ChatUpload> build() {
    ref.watch(signedInUserIdProvider);
    return const [];
  }

  Future<void> pickAndUpload() async {
    final room = ChatConstants.maxAttachments - state.length;
    if (room <= 0) return;
    final picked = await ref.read(fileAccessProvider).pickAttachments(ChatConstants.attachmentTypes.keys.toList());
    await Future.wait(picked.take(room).map(_upload));
  }

  Future<void> _upload(PickedAttachment file) async {
    final id = generateClientKey();
    state = [...state, ChatUpload(id: id, name: file.name)];
    try {
      final attachment = await ref
          .read(chatServiceProvider)
          .upload(conversationId, file, onProgress: (progress) => _replace(id, (u) => ChatUpload(id: id, name: u.name, progress: progress)));
      _replace(id, (u) => ChatUpload(id: id, name: u.name, progress: 1, assetId: attachment.assetId));
    } catch (_) {
      _replace(id, (u) => ChatUpload(id: id, name: u.name, failed: true));
    }
  }

  void _replace(String id, ChatUpload Function(ChatUpload) change) {
    if (!ref.mounted) return;
    state = [for (final u in state) u.id == id ? change(u) : u];
  }

  void remove(String id) => state = state.where((u) => u.id != id).toList();

  void clear() => state = const [];
}

final chatUploadsProvider = NotifierProvider.autoDispose.family<ChatUploadsController, List<ChatUpload>, String>(
  ChatUploadsController.new,
);
