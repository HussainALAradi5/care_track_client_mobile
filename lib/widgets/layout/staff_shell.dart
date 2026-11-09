import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/staff_nav.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../chat/chat_button.dart';
import '../notifications/notification_bell.dart';
import 'account_menu.dart';
import 'staff_hospital_switcher.dart';

/// Signed-in staff frame: hospital switcher and account menu on top, and a tab for each staff screen the
/// selected Hospital grants. With fewer than two such screens there is no tab bar.
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
    final selected = items.indexWhere((item) => location.startsWith(item.path));
    return Scaffold(
      appBar: AppBar(title: const StaffHospitalSwitcher(), actions: const [ChatButton(), NotificationBell(), AccountMenu()]),
      body: child,
      bottomNavigationBar: items.length < 2
          ? null
          : NavigationBar(
              selectedIndex: selected < 0 ? 0 : selected,
              onDestinationSelected: (i) => context.go(items[i].path),
              destinations: [
                for (final item in items)
                  NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
              ],
            ),
    );
  }
}
