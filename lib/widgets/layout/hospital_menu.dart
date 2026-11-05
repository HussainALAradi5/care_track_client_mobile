import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

/// App bar title: the selected Hospital's name, with a menu to switch when there are several to choose from.
class HospitalMenu extends StatelessWidget {
  const HospitalMenu({
    super.key,
    required this.selectedName,
    required this.selectedId,
    required this.options,
    required this.onSelect,
  });

  final String? selectedName;
  final String? selectedId;

  /// Hospital id → name, in menu order.
  final Map<String, String> options;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_hospital_rounded, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            selectedName ?? AppConstants.appName,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
    if (options.length < 2) return title;
    return PopupMenuButton<String>(
      initialValue: selectedId,
      onSelected: onSelect,
      itemBuilder: (_) => [
        for (final entry in options.entries) PopupMenuItem(value: entry.key, child: Text(entry.value)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: title),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
    );
  }
}
