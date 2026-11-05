import 'package:flutter/material.dart';

import '../../../constants/texts/common_texts.dart';
import '../../../utilities/http/error_message.dart';

/// Inline failure panel with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 36, color: scheme.onErrorContainer),
          const SizedBox(height: 12),
          Text(
            errorMessageOf(error),
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onErrorContainer, fontWeight: FontWeight.w500),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(CommonTexts.retry),
            ),
          ],
        ],
      ),
    );
  }
}
