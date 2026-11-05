import 'package:flutter/material.dart';

import '../../enums/ui/status_tone.dart';
import '../../models/ui/tone_colors.dart';

/// Colours of a status tone in light or dark mode (same families as the web client's chips).
ToneColors toneColors(StatusTone tone, ColorScheme scheme) {
  final dark = scheme.brightness == Brightness.dark;
  MaterialColor? family = switch (tone) {
    StatusTone.neutral => null,
    StatusTone.info => Colors.lightBlue,
    StatusTone.success => Colors.green,
    StatusTone.warning => Colors.amber,
    StatusTone.danger => Colors.red,
  };
  if (family == null) {
    return ToneColors(
      background: scheme.surfaceContainerHighest,
      foreground: scheme.onSurfaceVariant,
      solid: scheme.outline,
    );
  }
  return ToneColors(
    background: dark ? family.shade900.withValues(alpha: 0.45) : family.shade50,
    foreground: dark ? family.shade100 : family.shade900,
    solid: family.shade500,
  );
}
