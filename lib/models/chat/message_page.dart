import 'chat_message.dart';

/// Server MessagePageDto: newest first, with the keyset for older ones.
class MessagePage {
  const MessagePage({required this.items, required this.hasMore, required this.nextBefore});

  final List<ChatMessage> items;
  final bool hasMore;
  final int? nextBefore;

  factory MessagePage.fromJson(Map<String, dynamic> json) => MessagePage(
    items: (json['items'] as List<dynamic>).map((m) => ChatMessage.fromJson(m as Map<String, dynamic>)).toList(),
    hasMore: json['hasMore'] as bool,
    nextBefore: (json['nextBefore'] as num?)?.toInt(),
  );
}
