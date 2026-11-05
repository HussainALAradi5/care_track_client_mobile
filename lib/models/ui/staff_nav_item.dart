import 'package:flutter/material.dart';

/// One staff tab; it shows only when the selected Hospital grants [permission].
class StaffNavItem {
  const StaffNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
    required this.permission,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
  final String permission;
}
