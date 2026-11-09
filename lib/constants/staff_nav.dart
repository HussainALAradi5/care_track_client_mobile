import 'package:flutter/material.dart';

import '../models/ui/staff_nav_item.dart';
import 'permission_codes.dart';
import 'route_paths.dart';
import 'texts/attendance_texts.dart';
import 'texts/document_texts.dart';
import 'texts/leave_texts.dart';
import 'texts/payslip_texts.dart';
import 'texts/staff_request_texts.dart';
import 'texts/staff_texts.dart';
import 'texts/team_texts.dart';

/// Staff tabs in order; each shows only when the selected Hospital grants its permission.
class StaffNav {
  const StaffNav._();

  /// The phone's bottom bar: this many screens, then More for the rest (all of them when they fit).
  static const visibleTabs = 4;

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
    StaffNavItem(
      label: DocumentTexts.navVisits,
      icon: Icons.medical_services_outlined,
      selectedIcon: Icons.medical_services_rounded,
      path: RoutePaths.staffVisits,
      permission: PermissionCodes.clinicalHistoryWrite,
    ),
    StaffNavItem(
      label: LeaveTexts.navRequests,
      icon: Icons.event_busy_outlined,
      selectedIcon: Icons.event_busy_rounded,
      path: RoutePaths.staffLeaveRequests,
      permission: PermissionCodes.leaveReadAll,
    ),
    StaffNavItem(
      label: StaffRequestTexts.navHr,
      icon: Icons.assignment_ind_outlined,
      selectedIcon: Icons.assignment_ind_rounded,
      path: RoutePaths.staffHrRequests,
      permission: PermissionCodes.staffRequestHandle,
    ),
    StaffNavItem(
      label: AttendanceTexts.nav,
      icon: Icons.fingerprint_outlined,
      selectedIcon: Icons.fingerprint_rounded,
      path: RoutePaths.staffAttendance,
    ),
    StaffNavItem(
      label: LeaveTexts.nav,
      icon: Icons.flight_takeoff_outlined,
      selectedIcon: Icons.flight_takeoff_rounded,
      path: RoutePaths.staffLeave,
    ),
    StaffNavItem(
      label: PayslipTexts.nav,
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      path: RoutePaths.staffPayslips,
    ),
    StaffNavItem(
      label: TeamTexts.navTeam,
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups_rounded,
      path: RoutePaths.staffTeam,
    ),
    StaffNavItem(
      label: TeamTexts.navDepartment,
      icon: Icons.account_tree_outlined,
      selectedIcon: Icons.account_tree_rounded,
      path: RoutePaths.staffDepartment,
    ),
    StaffNavItem(
      label: StaffRequestTexts.nav,
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment_rounded,
      path: RoutePaths.staffRequests,
    ),
  ];
}
