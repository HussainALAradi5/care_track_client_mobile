import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

/// A rounded placeholder block with a moving highlight, used to build skeleton layouts.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.width, required this.height, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: Motion.shimmer)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHigh;
    final light = scheme.surfaceContainerLowest;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shift = _controller.value * 3 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(shift - 1, 0),
              end: Alignment(shift + 1, 0),
              colors: [base, light, base],
            ),
          ),
        );
      },
    );
  }
}
