import 'package:flutter/material.dart';

import '../../../interfaces/ui/search_loader.dart';
import '../../../models/ui/search_option.dart';
import 'picker_field.dart';
import 'search_select_sheet.dart';

/// A form field whose value is picked by typing to search on the server.
class SearchSelectField extends StatelessWidget {
  const SearchSelectField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    required this.value,
    required this.load,
    required this.onChanged,
    this.enabled = true,
    this.clearLabel,
    this.errorText,
  });

  final String label;
  final String placeholder;
  final IconData icon;
  final SearchOption? value;
  final SearchLoader load;

  /// Null when the "no choice" row was picked.
  final ValueChanged<SearchOption?> onChanged;
  final bool enabled;
  final String? clearLabel;
  final String? errorText;

  Future<void> _open(BuildContext context) async {
    final picked = await showSearchSelectSheet(context, title: label, load: load, clearLabel: clearLabel);
    if (picked != null) onChanged(picked.isNone ? null : picked);
  }

  @override
  Widget build(BuildContext context) => PickerField(
    label: label,
    value: value?.label ?? placeholder,
    icon: icon,
    errorText: errorText,
    onTap: enabled ? () => _open(context) : null,
  );
}
