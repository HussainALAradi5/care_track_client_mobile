import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/realtime.dart';
import '../../models/chat/chat_attachment.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_reaction.dart';
import '../../models/chat/chat_thread_state.dart';
import '../../models/chat/message_history.dart';
import '../../utilities/chat/attachment_files.dart';
import '../core/service_providers.dart';

/// What can be done to a message already in the thread: edit, delete, react, its edit history, saving an attachment.
mixin ChatThreadActions on Notifier<ChatThreadState> {
  String get conversationId;

  void setEditing(ChatMessage? message) => state = state.copyWith(editing: () => message);

  void applyEdited(ChatMessage message) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == message.id ? message : m]);
  }

  void applyDeleted(String messageId) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == messageId ? m.asDeleted() : m]);
  }

  void applyReaction(String messageId, List<ChatReaction> reactions) {
    state = state.copyWith(messages: [for (final m in state.messages) m.id == messageId ? m.withReactions(reactions) : m]);
  }

  /// Live when the channel is up, in which case the frame brings the change back; over REST otherwise.
  Future<void> edit(ChatMessage message, String text) async {
    setEditing(null);
    final body = {'conversationId': conversationId, 'messageId': message.id, 'text': text};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatEdit, body)) return;
    applyEdited(await ref.read(chatServiceProvider).edit(conversationId, message.id, text));
  }

  Future<void> remove(ChatMessage message) async {
    final body = {'conversationId': conversationId, 'messageId': message.id};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatDelete, body)) return;
    await ref.read(chatServiceProvider).delete(conversationId, message.id);
    applyDeleted(message.id);
  }

  Future<void> react(ChatMessage message, String? emoji) async {
    final body = {'conversationId': conversationId, 'messageId': message.id, 'emoji': emoji};
    if (ref.read(realtimeChannelProvider).publish(Realtime.chatReact, body)) return;
    applyReaction(message.id, await ref.read(chatServiceProvider).react(conversationId, message.id, emoji));
  }

  Future<void> toggleHistory(ChatMessage message) async {
    if (state.history?.messageId == message.id) {
      state = state.copyWith(history: () => null);
      return;
    }
    final edits = await ref.read(chatServiceProvider).history(conversationId, message.id);
    if (ref.mounted) state = state.copyWith(history: () => MessageHistory(messageId: message.id, edits: edits));
  }

  /// Saves an available file; the server answers 409 MEDIA_UNAVAILABLE until a file check has passed it.
  Future<void> download(ChatAttachment attachment) async {
    final bytes = await ref.read(chatServiceProvider).download(conversationId, attachment.assetId);
    await ref.read(fileAccessProvider).save(downloadName(attachment.assetId, attachment.contentType), bytes);
  }
}
