import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';

/// A titled card that groups related fields or details.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.children, this.icon, this.hint});

  final String title;
  final String? hint;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.small),
                ],
                Expanded(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
              ],
            ),
            if (hint != null) ...[
              const SizedBox(height: AppSpacing.tiny),
              Text(hint!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: AppSpacing.medium),
            ...children,
          ],
        ),
      ),
    );
  }
}
