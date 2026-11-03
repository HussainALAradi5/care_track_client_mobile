import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

/// Small metric card whose number counts up from its previous value.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, required this.icon});

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: scheme.primary),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(end: value.toDouble()),
              duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : Motion.slow,
              curve: Motion.standard,
              builder: (context, shown, _) => Text(
                '${shown.round()}',
                semanticsLabel: '$value',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
