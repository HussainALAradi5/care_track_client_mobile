import '../../constants/chat_constants.dart';

/// The content type of a file by its name, as the composer offers only these.
String contentTypeOfFile(String name) {
  final extension = name.split('.').last.toLowerCase();
  return ChatConstants.attachmentTypes[extension] ?? ChatConstants.fallbackContentType;
}

/// A file name for a download, from the server's content type.
String downloadName(String assetId, String contentType) {
  final extension = ChatConstants.attachmentTypes.entries
      .where((e) => e.value == contentType)
      .map((e) => e.key)
      .firstOrNull;
  return extension == null ? assetId : '$assetId.$extension';
}
