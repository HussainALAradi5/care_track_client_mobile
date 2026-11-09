import 'package:flutter/material.dart';

import '../identity/staff_hospital.dart';

/// One staff tab; it shows only when the selected Hospital grants [permission] (null: every staff member).
class StaffNavItem {
  const StaffNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
    this.permission,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
  final String? permission;

  bool isOpenAt(StaffHospital? hospital) =>
      hospital != null && (permission == null || hospital.can(permission!));
}
