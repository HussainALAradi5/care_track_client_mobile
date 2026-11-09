import 'package:flutter/animation.dart';

/// One duration and easing scale for every animation in the app.
class Motion {
  const Motion._();

  static const searchDebounce = Duration(milliseconds: 300);
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 700);
  static const shimmer = Duration(milliseconds: 1400);
  static const pulse = Duration(milliseconds: 1600);
  static const staggerStep = Duration(milliseconds: 45);
  static const maxStaggerItems = 10;
  static const enterOffset = 0.06;
  static const standard = Curves.easeOutCubic;
  static const emphasized = Curves.easeOutBack;
}
