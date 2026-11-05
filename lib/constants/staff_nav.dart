import 'package:flutter/material.dart';

import '../models/ui/staff_nav_item.dart';
import 'permission_codes.dart';
import 'route_paths.dart';
import 'texts/staff_texts.dart';

/// Staff tabs in order; each shows only when the selected Hospital grants its permission.
class StaffNav {
  const StaffNav._();

  static const items = [
    StaffNavItem(
      label: StaffTexts.navQueue,
      icon: Icons.inbox_outlined,
      selectedIcon: Icons.inbox_rounded,
      path: RoutePaths.staffQueue,
      permission: PermissionCodes.bookingReadAll,
    ),
    StaffNavItem(
      label: StaffTexts.navDesk,
      icon: Icons.how_to_reg_outlined,
      selectedIcon: Icons.how_to_reg_rounded,
      path: RoutePaths.staffDesk,
      permission: PermissionCodes.appointmentReadAll,
    ),
    StaffNavItem(
      label: StaffTexts.navShifts,
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
      path: RoutePaths.staffShifts,
      permission: PermissionCodes.shiftWrite,
    ),
  ];
}
