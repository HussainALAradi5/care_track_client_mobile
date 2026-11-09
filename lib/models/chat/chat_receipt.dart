/// Server ReceiptDto: a member's read and delivered positions.
class ChatReceipt {
  const ChatReceipt({required this.userId, required this.readSequence, required this.deliveredSequence});

  final String userId;
  final int readSequence;
  final int deliveredSequence;

  factory ChatReceipt.fromJson(Map<String, dynamic> json) => ChatReceipt(
    userId: json['userId'] as String,
    readSequence: (json['readSequence'] as num).toInt(),
    deliveredSequence: (json['deliveredSequence'] as num).toInt(),
  );
}
