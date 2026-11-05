import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

const _dotSize = 8.0;
const _ringGrowth = 8.0;

/// A small dot with an expanding, fading ring: "this is still waiting".
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, required this.color});

  final Color color;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: Motion.pulse)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );
    if (MediaQuery.disableAnimationsOf(context)) return dot;
    return SizedBox.square(
      dimension: _dotSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: _dotSize + _ringGrowth * _controller.value,
              height: _dotSize + _ringGrowth * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.45 * (1 - _controller.value)),
              ),
            ),
            child!,
          ],
        ),
        child: dot,
      ),
    );
  }
}
