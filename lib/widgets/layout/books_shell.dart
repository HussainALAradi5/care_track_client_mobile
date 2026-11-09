import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/books_nav.dart';
import '../../controllers/identity/organization_context_controller.dart';
import '../chat/chat_button.dart';
import '../notifications/notification_bell.dart';
import 'account_menu.dart';
import 'hospital_menu.dart';

/// Signed-in accountant frame: the Organization switcher and account menu on top, and a tab for each books screen
/// the selected Organization grants.
class BooksShell extends ConsumerWidget {
  const BooksShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final context_ = ref.watch(organizationContextProvider).value;
    final organization = context_?.organization;
    final items = [
      for (final item in BooksNav.items)
        if (organization != null && (item.permission == null || organization.can(item.permission!))) item,
    ];
    final selected = items.lastIndexWhere((item) => location.startsWith(item.path));
    return Scaffold(
      appBar: AppBar(
        title: HospitalMenu(
          selectedName: organization?.name,
          selectedId: organization?.organizationId,
          options: {for (final o in context_?.organizations ?? const []) o.organizationId: o.name},
          onSelect: (id) => ref.read(organizationContextProvider.notifier).select(id),
        ),
        actions: const [ChatButton(), NotificationBell(), AccountMenu()],
      ),
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
