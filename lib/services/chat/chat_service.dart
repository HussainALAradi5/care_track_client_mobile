import '../../config/endpoints.dart';
import '../../constants/chat_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/message_page.dart';
import '../../models/common/page_result.dart';
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

  Future<ChatMessage> send(String conversationId, {required String text, required String clientKey, String? replyToId}) async =>
      ChatMessage.fromJson(
        await _api.post(
          Endpoints.chatMessages(conversationId),
          body: {'text': text, 'replyToId': replyToId},
          headers: {ChatConstants.idempotencyHeader: clientKey},
        ),
      );

  Future<void> markRead(String conversationId, int sequence) =>
      _api.post(Endpoints.chatRead(conversationId), body: {'sequence': sequence});

  Future<void> markDelivered(String conversationId, int sequence) =>
      _api.post(Endpoints.chatDelivered(conversationId), body: {'sequence': sequence});
}
