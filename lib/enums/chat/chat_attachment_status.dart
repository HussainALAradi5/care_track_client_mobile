/// Server MediaStatus: only an available file can be downloaded.
enum ChatAttachmentStatus {
  quarantined('QUARANTINED'),
  available('AVAILABLE'),
  rejected('REJECTED'),
  revoked('REVOKED');

  const ChatAttachmentStatus(this.wire);
  final String wire;

  static ChatAttachmentStatus fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
