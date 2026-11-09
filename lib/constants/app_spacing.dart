import 'package:flutter/widgets.dart';

/// Gaps, paddings and small sizes shared by the screens.
class AppSpacing {
  const AppSpacing._();

  static const tiny = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const xLarge = 24.0;
  static const iconSmall = 18.0;
  static const avatarRadius = 36.0;
  static const sheetHeightFactor = 0.8;
  static const page = EdgeInsets.fromLTRB(large, small, large, xLarge);
  static const card = EdgeInsets.all(large);
  static const sheet = EdgeInsets.all(large);
}
