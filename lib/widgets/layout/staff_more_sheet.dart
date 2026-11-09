import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/ui/staff_nav_item.dart';

/// Opens the staff screens that did not fit on the bottom bar.
Future<void> showStaffMoreSheet(BuildContext context, List<StaffNavItem> items, String location) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final item in items)
              ListTile(
                leading: Icon(item.isAt(location) ? item.selectedIcon : item.icon),
                title: Text(item.label),
                selected: item.isAt(location),
                onTap: () {
                  Navigator.of(sheet).pop();
                  context.go(item.path);
                },
              ),
          ],
        ),
      ),
    );
