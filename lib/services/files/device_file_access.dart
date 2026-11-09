import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../interfaces/files/file_access.dart';
import '../../models/files/picked_attachment.dart';

class DeviceFileAccess implements FileAccess {
  const DeviceFileAccess();

  @override
  Future<List<PickedAttachment>> pickAttachments(List<String> extensions) async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: extensions);
    return [for (final f in files) PickedAttachment(name: f.name, path: f.path)];
  }

  @override
  Future<bool> save(String fileName, Uint8List bytes) async =>
      await FilePicker.saveFile(fileName: fileName, bytes: bytes) != null;
}
