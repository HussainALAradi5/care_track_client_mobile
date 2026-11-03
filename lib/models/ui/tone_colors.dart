import 'package:flutter/painting.dart';

/// Background, foreground and solid accent of one status tone in the current brightness.
class ToneColors {
  const ToneColors({required this.background, required this.foreground, required this.solid});

  final Color background;
  final Color foreground;
  final Color solid;
}
