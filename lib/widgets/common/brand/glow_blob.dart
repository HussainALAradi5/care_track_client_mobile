import 'package:flutter/material.dart';

/// Soft blurred colour blob for brand backgrounds.
class GlowBlob extends StatelessWidget {
  const GlowBlob({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 320,
    height: 320,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)]),
    ),
  );
}
