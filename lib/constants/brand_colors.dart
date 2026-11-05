import 'package:flutter/painting.dart';

/// The same brand as the web client: calm clinical blue with a warm coral accent.
class BrandColors {
  const BrandColors._();

  static const primary = Color(0xFF1D4F91);
  static const primaryDark = Color(0xFFA9C7FF);
  static const accent = Color(0xFFF08A5D);
  static const canvasLight = Color(0xFFF5F7FB);
  static const canvasDark = Color(0xFF0F1318);
  static const cardDark = Color(0xFF151A20);

  /// Text and icons on solid coloured surfaces (snacks, filled markers).
  static const onSolid = Color(0xFFFFFFFF);
  /// Translucent white panel on the highlighted gradient card.
  static const onGradientPanel = Color(0x33FFFFFF);
  static const success = Color(0xFF388E3C);
  /// Countdown in its last quarter: bar fill and its label.
  static const urgentFill = Color(0xFFFFB300);
  static const urgentText = Color(0xFFFFA000);
}
