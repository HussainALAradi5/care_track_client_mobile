import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/texts/common_texts.dart';
import '../../constants/texts/document_texts.dart';
import 'account_menu.dart';
import 'hospital_switcher.dart';

/// Signed-in frame: hospital switcher and account menu on top, five tabs at the bottom.
class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const HospitalSwitcher(), actions: const [AccountMenu()]),
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            label: CommonTexts.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available_rounded),
            label: CommonTexts.navBook,
          ),
          NavigationDestination(
            icon: Icon(Icons.pending_actions_outlined),
            selectedIcon: Icon(Icons.pending_actions_rounded),
            label: CommonTexts.navRequests,
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: CommonTexts.navVisits,
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: DocumentTexts.navDocuments,
          ),
        ],
      ),
    );
  }
}
