import 'package:flutter/material.dart';

import '../models/workforce/shift_quick_start.dart';

/// Client copies of the server shift rules (SchedulingRules.MAX_SHIFT_LENGTH); the server stays the authority.
class ShiftRules {
  const ShiftRules._();

  static const maxHours = 24;
  static const lengthOptions = [4, 6, 8, 10, 12, 24];
  static const defaultHours = 8;
  static const defaultStart = TimeOfDay(hour: 8, minute: 0);

  /// How far ahead the date picker reaches.
  static const plannableDays = 90;
  static const maxClinicians = 100;

  /// One-tap usual starts shown above the time picker.
  static const quickStarts = [
    ShiftQuickStart(label: 'Morning', time: TimeOfDay(hour: 7, minute: 0), icon: Icons.wb_twilight_rounded),
    ShiftQuickStart(label: 'Day', time: TimeOfDay(hour: 8, minute: 0), icon: Icons.light_mode_rounded),
    ShiftQuickStart(label: 'Evening', time: TimeOfDay(hour: 15, minute: 0), icon: Icons.wb_sunny_rounded),
    ShiftQuickStart(label: 'Night', time: TimeOfDay(hour: 23, minute: 0), icon: Icons.dark_mode_rounded),
  ];
}
