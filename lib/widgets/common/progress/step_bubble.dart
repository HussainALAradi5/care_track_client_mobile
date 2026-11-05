import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

const _bubble = 34.0;

/// One numbered step of StepProgress: filled once reached, enlarged while current.
class StepBubble extends StatelessWidget {
  const StepBubble({super.key, required this.index, required this.label, required this.current});

  final int index;
  final String label;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reached = index <= current;
    final active = index == current;
    return Semantics(
      selected: active,
      child: Column(
        children: [
          AnimatedScale(
            scale: active ? 1.12 : 1,
            duration: Motion.medium,
            curve: Motion.emphasized,
            child: AnimatedContainer(
              duration: Motion.medium,
              width: _bubble,
              height: _bubble,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: reached ? scheme.primary : scheme.surfaceContainerHighest,
                boxShadow: active ? [BoxShadow(color: scheme.primary.withValues(alpha: 0.3), blurRadius: 0, spreadRadius: 4)] : null,
              ),
              child: index < current
                  ? Icon(Icons.check_rounded, size: 18, color: scheme.onPrimary)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: reached ? scheme.onPrimary : scheme.onSurfaceVariant,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
