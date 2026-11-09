import '../../enums/chat/receipt_state.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/conversation.dart';

/// How far every other member has got with [message].
ReceiptState receiptStateOf(ChatMessage message, Conversation conversation) {
  final others = conversation.participants.where((p) => p.userId != conversation.myUserId);
  if (others.isNotEmpty && others.every((p) => p.lastReadSequence >= message.sequence)) return ReceiptState.read;
  if (others.isNotEmpty && others.every((p) => p.lastDeliveredSequence >= message.sequence)) {
    return ReceiptState.delivered;
  }
  return ReceiptState.sent;
}
