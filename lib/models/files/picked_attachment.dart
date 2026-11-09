/// A file the person chose from the device; [bytes] is set when the platform gives no path.
class PickedAttachment {
  const PickedAttachment({required this.name, this.path, this.bytes});

  final String name;
  final String? path;
  final List<int>? bytes;
}
