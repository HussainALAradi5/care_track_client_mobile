/// One file in the composer: uploading ([progress] 0 to 1), ready ([assetId] set) or failed.
class ChatUpload {
  const ChatUpload({required this.id, required this.name, this.progress = 0, this.assetId, this.failed = false});

  final String id;
  final String name;
  final double progress;
  final String? assetId;
  final bool failed;

  bool get isBusy => assetId == null && !failed;
}
