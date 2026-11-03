import 'package:flutter/widgets.dart';

import '../../enums/ui/status_tone.dart';

/// How one status value looks: its label, colour family and icon.
class StatusStyle {
  const StatusStyle({required this.label, required this.tone, required this.icon});

  final String label;
  final StatusTone tone;
  final IconData icon;
}
