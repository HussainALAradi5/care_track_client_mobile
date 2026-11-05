import 'package:flutter/material.dart';

import '../../../constants/texts/common_texts.dart';
import '../../../models/ui/confirm_config.dart';

/// Bottom sheet asking "are you sure?"; resolves true only when confirmed.
Future<bool> showConfirmSheet(BuildContext context, ConfirmConfig config) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(config.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(config.message, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              FilledButton(
                style: config.danger ? FilledButton.styleFrom(backgroundColor: scheme.error) : null,
                onPressed: () => Navigator.pop(context, true),
                child: Text(config.confirmLabel),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(CommonTexts.keep)),
            ],
          ),
        ),
      );
    },
  );
  return confirmed ?? false;
}
