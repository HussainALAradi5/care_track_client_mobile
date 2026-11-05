import 'package:flutter/material.dart';

/// Draws the ECG line up to [progress] (0–1) with a fading tail.
class HeartbeatPainter extends CustomPainter {
  HeartbeatPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const _points = [
    Offset(0, .5), Offset(.32, .5), Offset(.38, .5), Offset(.43, .1),
    Offset(.5, .9), Offset(.55, .5), Offset(.62, .5), Offset(1, .5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(_points.first.dx * size.width, _points.first.dy * size.height);
    for (final p in _points.skip(1)) {
      path.lineTo(p.dx * size.width, p.dy * size.height);
    }
    final metric = path.computeMetrics().first;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(colors: [color.withValues(alpha: 0), color]).createShader(Offset.zero & size);
    canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
  }

  @override
  bool shouldRepaint(HeartbeatPainter old) => old.progress != progress || old.color != color;
}
