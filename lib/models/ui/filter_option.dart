import 'package:flutter/widgets.dart';

/// One chip of a filter; a null [value] means no filter.
class FilterOption<T> {
  const FilterOption({required this.value, required this.label, this.icon});

  final T? value;
  final String label;
  final IconData? icon;
}
