import 'package:flutter/material.dart';

import '../../../constants/motion.dart';
import '../../../constants/texts/common_texts.dart';
import 'brand_mark.dart';
import 'heartbeat_painter.dart';

/// Full-screen brand loader: the CareTrack mark above an animated heartbeat line (start-up, sign-in).
class HeartbeatLoader extends StatefulWidget {
  const HeartbeatLoader({super.key, this.label = CommonTexts.loading});

  final String label;

  @override
  State<HeartbeatLoader> createState() => _HeartbeatLoaderState();
}

class _HeartbeatLoaderState extends State<HeartbeatLoader> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: Motion.pulse)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandMark(),
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            height: 28,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: HeartbeatPainter(progress: _controller.value, color: scheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.label, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

