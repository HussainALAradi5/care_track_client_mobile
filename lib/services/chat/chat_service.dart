import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../config/endpoints.dart';
import '../../constants/chat_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/chat/conversation_kind.dart';
import '../../models/chat/chat_attachment.dart';
import '../../models/chat/chat_contact.dart';
import '../../models/chat/chat_hospital.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_reaction.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/message_edit.dart';
import '../../models/chat/message_page.dart';
import '../../models/common/page_result.dart';
import '../../models/files/picked_attachment.dart';
import '../../utilities/chat/attachment_files.dart';
import '../api/api_client.dart';

/// Chat over REST: the source of truth, and how the app sends, since a retry there can never duplicate a message.
class ChatService {
  ChatService(this._api);

  final ApiClient _api;

  Future<PageResult<Conversation>> conversations(PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.chatConversations, query: request.toQuery()),
    Conversation.fromJson,
  );

  Future<Conversation> conversation(String id) async =>
      Conversation.fromJson(await _api.get(Endpoints.chatConversation(id)));

  Future<MessagePage> messages(String conversationId, {int? before}) async => MessagePage.fromJson(
    await _api.get(
      Endpoints.chatMessages(conversationId),
      query: {'limit': ChatConstants.messagePageSize, 'before': ?before},
    ),
  );

  /// [body] is the same payload the live channel carries; [clientKey] travels as the Idempotency-Key.
  Future<ChatMessage> send(String conversationId, {required Map<String, dynamic> body, required String clientKey}) async =>
      ChatMessage.fromJson(
        await _api.post(
          Endpoints.chatMessages(conversationId),
          body: body,
          headers: {ChatConstants.idempotencyHeader: clientKey},
        ),
      );

  Future<Conversation> start({required String hospitalId, required ConversationKind kind, String? targetUserId}) async =>
      Conversation.fromJson(
        await _api.post(
          Endpoints.chatConversations,
          body: {'hospitalId': hospitalId, 'kind': kind.wire, 'targetUserId': targetUserId},
        ),
      );

  Future<List<ChatHospital>> hospitals() async => [
    for (final h in await _api.getList(Endpoints.chatHospitals)) ChatHospital.fromJson(h as Map<String, dynamic>),
  ];

  Future<PageResult<ChatContact>> contacts(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.chatContacts(hospitalId), query: request.toQuery()),
    ChatContact.fromJson,
  );

  Future<Conversation> mute(String conversationId, bool muted) async =>
      Conversation.fromJson(await _api.put(Endpoints.chatMute(conversationId), body: {'muted': muted, 'until': null}));

  Future<Conversation> hide(String conversationId, bool hidden) async =>
      Conversation.fromJson(await _api.put(Endpoints.chatHide(conversationId), body: {'hidden': hidden}));

  Future<ChatMessage> edit(String conversationId, String messageId, String text) async => ChatMessage.fromJson(
    await _api.put(Endpoints.chatMessage(conversationId, messageId), body: {'text': text}),
  );

  Future<void> delete(String conversationId, String messageId) =>
      _api.delete(Endpoints.chatMessage(conversationId, messageId));

  Future<List<MessageEdit>> history(String conversationId, String messageId) async => [
    for (final e in await _api.getList(Endpoints.chatMessageHistory(conversationId, messageId)))
      MessageEdit.fromJson(e as Map<String, dynamic>),
  ];

  /// A null [emoji] takes the reaction back; the answer is the message's whole reaction list.
  Future<List<ChatReaction>> react(String conversationId, String messageId, String? emoji) async {
    final json = await _api.put(Endpoints.chatReaction(conversationId, messageId), body: {'emoji': emoji});
    return [for (final r in json['reactions'] as List<dynamic>) ChatReaction.fromJson(r as Map<String, dynamic>)];
  }

  Future<void> typing(String conversationId, bool typing) =>
      _api.postNoContent(Endpoints.chatTyping(conversationId), body: {'typing': typing});

  Future<ChatAttachment> upload(
    String conversationId,
    PickedAttachment file, {
    required void Function(double progress) onProgress,
  }) async {
    final media = DioMediaType.parse(contentTypeOfFile(file.name));
    final part = file.path != null
        ? await MultipartFile.fromFile(file.path!, filename: file.name, contentType: media)
        : MultipartFile.fromBytes(file.bytes!, filename: file.name, contentType: media);
    return ChatAttachment.fromJson(
      await _api.upload(
        Endpoints.chatAttachments(conversationId),
        form: FormData.fromMap({'file': part}),
        onProgress: (sent, total) {
          if (total > 0) onProgress(sent / total);
        },
      ),
    );
  }

  Future<Uint8List> download(String conversationId, String assetId) =>
      _api.getBytes(Endpoints.chatAttachmentDownload(conversationId, assetId));

  Future<void> markRead(String conversationId, int sequence) =>
      _api.post(Endpoints.chatRead(conversationId), body: {'sequence': sequence});

  Future<void> markDelivered(String conversationId, int sequence) =>
      _api.post(Endpoints.chatDelivered(conversationId), body: {'sequence': sequence});
}
