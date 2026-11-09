import 'dart:typed_data';

import '../../models/files/picked_attachment.dart';

/// The device's files: choosing attachments and saving downloads.
abstract interface class FileAccess {
  Future<List<PickedAttachment>> pickAttachments(List<String> extensions);

  /// False when the person dismissed the save dialog.
  Future<bool> save(String fileName, Uint8List bytes);
}
