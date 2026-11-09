import 'package:flutter/material.dart';

/// A read-only form field showing a picked value; tapping it opens a picker (date, time, search). A null [onTap] is
/// a disabled field.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.errorText,
    this.helperText,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(4),
    onTap: onTap,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon),
        errorText: errorText,
        helperText: helperText,
        enabled: onTap != null,
      ),
      child: Text(value),
    ),
  );
}
