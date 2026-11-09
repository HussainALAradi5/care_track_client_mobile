import 'package:care_track_client_mobile/enums/chat/conversation_kind.dart';
import 'package:care_track_client_mobile/enums/chat/chat_event_type.dart';
import 'package:care_track_client_mobile/enums/chat/receipt_state.dart';
import 'package:care_track_client_mobile/models/chat/chat_message.dart';
import 'package:care_track_client_mobile/models/chat/chat_receipt.dart';
import 'package:care_track_client_mobile/models/chat/conversation.dart';
import 'package:care_track_client_mobile/models/chat/message_page.dart';
import 'package:care_track_client_mobile/utilities/chat/receipt_state_of.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> messageJson({int sequence = 3, String sender = 'u1', bool deleted = false, String? text = 'hello'}) => {
  'id': 'm$sequence',
  'conversationId': 'c1',
  'sequence': sequence,
  'senderId': sender,
  'text': text,
  'replyTo': {'messageId': 'm1', 'senderId': 'u2', 'text': 'first', 'deleted': false},
  'edited': true,
  'editedAt': '2026-11-09T09:00:30Z',
  'deleted': deleted,
  'createdAt': '2026-11-09T09:00:00Z',
  'clientKey': 'key-$sequence',
  'reactions': <dynamic>[],
  'attachments': [
    {'assetId': 'a1', 'contentType': 'image/png', 'sizeBytes': 10, 'status': 'QUARANTINED'},
  ],
};

Map<String, dynamic> conversationJson() => {
  'id': 'c1',
  'hospitalId': 'h1',
  'kind': 'PATIENT_CARE',
  'patientId': 'u1',
  'lastSequence': 3,
  'lastMessageAt': '2026-11-09T09:00:00Z',
  'unreadCount': 2,
  'lastReadSequence': 1,
  'muted': false,
  'mutedUntil': null,
  'hidden': false,
  'myUserId': 'u1',
  'participants': [
    {'userId': 'u1', 'name': 'Sara', 'side': 'PATIENT', 'lastReadSequence': 1, 'lastDeliveredSequence': 1, 'active': true, 'online': true},
    {'userId': 'u2', 'name': 'Dr Ali', 'side': 'STAFF', 'lastReadSequence': 2, 'lastDeliveredSequence': 3, 'active': true, 'online': false},
  ],
};

void main() {
  test('parses a message with its reply and attachments', () {
    final message = ChatMessage.fromJson(messageJson());
    expect(message.sequence, 3);
    expect(message.replyTo?.text, 'first');
    expect(message.edited, isTrue);
    expect(message.attachmentCount, 1);
    expect(message.clientKey, 'key-3');
  });

  test('a deleted message has no text', () {
    final message = ChatMessage.fromJson(messageJson(deleted: true, text: null));
    expect(message.deleted, isTrue);
    expect(message.text, isNull);
  });

  test('parses a conversation and names it after the other person', () {
    final conversation = Conversation.fromJson(conversationJson());
    expect(conversation.kind, ConversationKind.patientCare);
    expect(conversation.unreadCount, 2);
    expect(conversation.title, 'Dr Ali');
  });

  test('a keyset page carries where to continue', () {
    final page = MessagePage.fromJson({'items': [messageJson()], 'hasMore': true, 'nextBefore': 3});
    expect(page.items.single.sequence, 3);
    expect(page.nextBefore, 3);
  });

  test('receipts follow the other members', () {
    final conversation = Conversation.fromJson(conversationJson());
    expect(receiptStateOf(ChatMessage.fromJson(messageJson(sequence: 1)), conversation), ReceiptState.read);
    expect(receiptStateOf(ChatMessage.fromJson(messageJson(sequence: 3)), conversation), ReceiptState.delivered);
    expect(receiptStateOf(ChatMessage.fromJson(messageJson(sequence: 4)), conversation), ReceiptState.sent);
    final receipt = ChatReceipt.fromJson({'userId': 'u2', 'readSequence': 2, 'deliveredSequence': 3});
    expect(receipt.deliveredSequence, 3);
  });

  test('an unknown live frame type is ignored rather than failing', () {
    expect(ChatEventType.fromWire('MESSAGE_NEW'), ChatEventType.messageNew);
    expect(ChatEventType.fromWire('SOMETHING_NEW'), isNull);
  });
}
