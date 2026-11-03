import 'package:flutter/material.dart';

import '../../../constants/texts/common_texts.dart';
import 'shimmer_box.dart';

const _defaultRows = 4;

/// Shimmering placeholder cards shaped like the list that is loading, so the layout does not jump.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.rows = _defaultRows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: CommonTexts.loading,
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const ShimmerBox(width: 44, height: 44, radius: 12),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(widthFactor: 0.5, child: const ShimmerBox(height: 14)),
                            const SizedBox(height: 8),
                            FractionallySizedBox(widthFactor: 0.75, child: const ShimmerBox(height: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
