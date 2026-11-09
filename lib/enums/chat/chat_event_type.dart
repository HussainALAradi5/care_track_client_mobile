/// Server ChatEventType: what a live frame on the chat queue changed.
enum ChatEventType {
  messageNew('MESSAGE_NEW'),
  messageEdited('MESSAGE_EDITED'),
  messageDeleted('MESSAGE_DELETED'),
  reaction('REACTION'),
  typing('TYPING'),
  receipt('RECEIPT'),
  presence('PRESENCE');

  const ChatEventType(this.wire);
  final String wire;

  static ChatEventType? fromWire(String value) {
    for (final type in values) {
      if (type.wire == value) return type;
    }
    return null;
  }
}
