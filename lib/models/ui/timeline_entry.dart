import 'package:flutter/widgets.dart';

import '../../enums/ui/status_tone.dart';

/// One step on the visit timeline.
class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.icon,
    required this.tone,
    required this.done,
    this.detail,
    this.at,
  });

  final String title;
  final IconData icon;
  final StatusTone tone;
  final bool done;
  final String? detail;
  final DateTime? at;
}
