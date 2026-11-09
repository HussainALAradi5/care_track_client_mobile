import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../models/ui/filter_option.dart';

/// A row of chips where one is chosen; [errorText] shows under them.
class FilterChips<T> extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.label,
    this.errorText,
  });

  final List<FilterOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final String? label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.small),
        ],
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.tiny,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option.label),
                avatar: option.icon == null ? null : Icon(option.icon, size: AppSpacing.iconSmall),
                selected: option.value == selected,
                onSelected: (_) => onSelected(option.value),
              ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.tiny),
          Text(errorText!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
        ],
      ],
    );
  }
}
