import 'package:flutter/material.dart';

import '../../../constants/motion.dart';
import 'step_bubble.dart';

const _bubble = 34.0;

/// Wizard header: numbered steps on a track that fills smoothly as the person moves forward.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final last = steps.length - 1;
    return SizedBox(
      height: _bubble + 26,
      child: Stack(
        children: [
          Positioned(
            top: _bubble / 2 - 2,
            left: _bubble / 2,
            right: _bubble / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: last <= 0 ? 1 : current / last),
                duration: Motion.medium,
                curve: Motion.standard,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < steps.length; i++) StepBubble(index: i, label: steps[i], current: current),
            ],
          ),
        ],
      ),
    );
  }
}
