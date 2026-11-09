/// Paging of the chat screens.
class ChatConstants {
  const ChatConstants._();

  static const pageSize = 20;
  static const messagePageSize = 30;
  static const idempotencyHeader = 'Idempotency-Key';

  /// A bubble never takes more of the screen's width than this.
  static const bubbleMaxWidthFraction = 0.78;
}
