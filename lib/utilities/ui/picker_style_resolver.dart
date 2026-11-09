import 'package:flutter/foundation.dart';

import '../../enums/ui/picker_style.dart';

/// The look to draw: the person's choice, or their device's default (wheels on Apple devices, Material elsewhere).
PickerStyle resolvePickerStyle(PickerStyle? chosen, TargetPlatform platform) {
  if (chosen != null) return chosen;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS ? PickerStyle.iphone : PickerStyle.android;
}
