import 'package:flutter/material.dart';

/// The CareTrack cross on a rounded square.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(size * 0.28)),
      child: Icon(Icons.add_rounded, size: size * 0.75, color: scheme.onPrimary),
    );
  }
}
