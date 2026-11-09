/// Paging of the chat screens.
class ChatConstants {
  const ChatConstants._();

  static const pageSize = 20;
  static const contactsPageSize = 50;
  static const maxAttachments = 5;

  /// File extensions the composer offers, with their content type; the server's media checks decide what is kept.
  static const attachmentTypes = {'png': 'image/png', 'jpg': 'image/jpeg', 'jpeg': 'image/jpeg', 'pdf': 'application/pdf'};
  static const fallbackContentType = 'application/octet-stream';

  /// The offered reactions; the server accepts only these.
  static const reactions = ['\u{1F44D}', '\u{2764}\u{FE0F}', '\u{1F602}', '\u{1F62E}', '\u{1F622}', '\u{1F64F}'];

  /// A live send without its echo after this long is sent over REST with the same key, which cannot duplicate.
  static const ackTimeout = Duration(seconds: 4);

  /// At most one typing frame in this window; "stopped" after this pause; an indicator with no refresh goes after this.
  static const typingThrottle = Duration(seconds: 3);
  static const typingIdle = Duration(seconds: 4);
  static const typingDisplay = Duration(seconds: 6);
  static const messagePageSize = 30;
  static const idempotencyHeader = 'Idempotency-Key';

  /// A bubble never takes more of the screen's width than this.
  static const bubbleMaxWidthFraction = 0.78;
}
