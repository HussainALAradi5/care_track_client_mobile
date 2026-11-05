import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/motion.dart';
import '../../../constants/scheduling.dart';
import '../../../controllers/ui/clock_controller.dart';
import '../../../utilities/time/countdown.dart';
import '../../../constants/brand_colors.dart';

/// A draining bar for a time window (for example free cancellation): full when it opens, empty when it closes,
/// amber in its last quarter. The remaining time is written out too, so colour is never the only cue.
class CountdownMeter extends ConsumerWidget {
  const CountdownMeter({
    super.key,
    required this.opensAt,
    required this.closesAt,
    required this.label,
    required this.closedLabel,
    this.onColor,
  });

  final DateTime opensAt;
  final DateTime closesAt;
  final String label;
  final String closedLabel;

  /// Text and track colour when drawn on a coloured card.
  final Color? onColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final scheme = Theme.of(context).colorScheme;
    final fraction = remainingFraction(opensAt, closesAt, now);
    final left = remainingLabel(closesAt, now);
    final urgent = fraction > 0 && fraction < Scheduling.urgentFraction;
    final text = onColor ?? scheme.onSurfaceVariant;
    final fill = urgent ? BrandColors.urgentFill : (onColor ?? scheme.primary);
    return Semantics(
      label: left == null ? closedLabel : '$label: $left',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(left == null ? Icons.lock_clock_rounded : Icons.timer_outlined, size: 16, color: text),
              const SizedBox(width: 4),
              Expanded(
                child: Text(left == null ? closedLabel : label, style: TextStyle(fontSize: 12, color: text)),
              ),
              if (left != null)
                Text(
                  left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: urgent ? BrandColors.urgentText : text,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: fraction),
              duration: Motion.slow,
              curve: Motion.standard,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                color: fill,
                backgroundColor: (onColor ?? scheme.onSurface).withValues(alpha: 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
