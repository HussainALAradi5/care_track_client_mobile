import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/motion.dart';
import 'error_state.dart';
import 'skeleton_list.dart';

/// Loading → skeleton, error → retry panel, data → [data]. Keeps showing old data while refreshing.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({super.key, required this.value, required this.data, this.onRetry, this.skeletonRows = 4});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final int skeletonRows;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Motion.medium,
      child: switch (value) {
        AsyncValue(:final value?, hasValue: true) => KeyedSubtree(key: const ValueKey('data'), child: data(value)),
        AsyncError(:final error) => ErrorState(key: const ValueKey('error'), error: error, onRetry: onRetry),
        // Data that is legitimately null (nothing to show yet), not loading.
        AsyncData(:final value) => KeyedSubtree(key: const ValueKey('data'), child: data(value)),
        _ => SkeletonList(key: const ValueKey('loading'), rows: skeletonRows),
      },
    );
  }
}
