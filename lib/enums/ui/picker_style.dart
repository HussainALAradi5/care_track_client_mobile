/// How a person's date and time pickers look (server enum PickerStyle).
enum PickerStyle {
  iphone('IPHONE'),
  android('ANDROID'),
  smooth('SMOOTH');

  const PickerStyle(this.wire);

  final String wire;

  /// Null when nothing is chosen, or for a look this version does not know: the device's default then applies.
  static PickerStyle? fromWire(String? value) {
    for (final style in values) {
      if (style.wire == value) return style;
    }
    return null;
  }
}
