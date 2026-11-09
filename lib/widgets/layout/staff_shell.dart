import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/staff_nav.dart';
import '../../constants/texts/staff_texts.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../../models/ui/staff_nav_item.dart';
import '../chat/chat_button.dart';
import '../notifications/notification_bell.dart';
import 'account_menu.dart';
import 'staff_hospital_switcher.dart';
import 'staff_more_sheet.dart';

/// Signed-in staff frame: hospital switcher and account menu on top, and a tab for each staff screen the
/// selected Hospital grants: all of them when they fit, otherwise the first few and More for the rest. With fewer
/// than two such screens there is no tab bar.
class StaffShell extends ConsumerWidget {
  const StaffShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospital = ref.watch(selectedStaffHospitalProvider);
    final items = [
      for (final item in StaffNav.items)
        if (item.isOpenAt(hospital)) item,
    ];
    final fits = items.length <= StaffNav.visibleTabs + 1;
    final tabs = fits ? items : items.sublist(0, StaffNav.visibleTabs);
    final more = fits ? const <StaffNavItem>[] : items.sublist(StaffNav.visibleTabs);
    final selected = [...tabs, ...more].indexWhere((item) => item.isAt(location));
    return Scaffold(
      appBar: AppBar(title: const StaffHospitalSwitcher(), actions: const [ChatButton(), NotificationBell(), AccountMenu()]),
      body: child,
      bottomNavigationBar: items.length < 2
          ? null
          : NavigationBar(
              selectedIndex: selected < 0 ? 0 : selected.clamp(0, tabs.length),
              onDestinationSelected: (i) =>
                  i < tabs.length ? context.go(tabs[i].path) : showStaffMoreSheet(context, more, location),
              destinations: [
                for (final item in tabs)
                  NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
                if (more.isNotEmpty)
                  const NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: StaffTexts.navMore),
              ],
            ),
    );
  }
}
