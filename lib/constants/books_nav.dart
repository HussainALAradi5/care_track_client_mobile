import 'package:flutter/material.dart';

import '../models/ui/staff_nav_item.dart';
import 'permission_codes.dart';
import 'route_paths.dart';
import 'texts/accounting_texts.dart';

/// Accountant tabs in order; each shows only when the selected Organization grants its permission.
class BooksNav {
  const BooksNav._();

  static const items = [
    StaffNavItem(
      label: AccountingTexts.navBooks,
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard_rounded,
      path: RoutePaths.books,
      permission: PermissionCodes.accountRead,
    ),
    StaffNavItem(
      label: AccountingTexts.navJournal,
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      path: RoutePaths.booksJournal,
      permission: PermissionCodes.journalRead,
    ),
    StaffNavItem(
      label: AccountingTexts.navReports,
      icon: Icons.query_stats_outlined,
      selectedIcon: Icons.query_stats_rounded,
      path: RoutePaths.booksReports,
      permission: PermissionCodes.financeReportRead,
    ),
  ];
}
