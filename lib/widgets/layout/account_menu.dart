import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/motion.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../../constants/texts/common_texts.dart';
import '../../constants/texts/picker_texts.dart';
import '../../constants/texts/profile_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/identity/care_mode_controller.dart';
import '../../controllers/ui/theme_controller.dart';
import '../../utilities/text/initials.dart';
import '../common/pickers/picker_style_sheet.dart';

/// Theme toggle and an avatar menu with the person's name and sign-out.
class AccountMenu extends ConsumerWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final care = ref.watch(careModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: CommonTexts.toggleTheme,
          onPressed: () => ref.read(themeModeProvider.notifier).toggle(brightness),
          icon: AnimatedSwitcher(
            duration: Motion.medium,
            transitionBuilder: (child, a) => RotationTransition(turns: a, child: FadeTransition(opacity: a, child: child)),
            child: Icon(
              brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(brightness),
            ),
          ),
        ),
        PopupMenuButton<void>(
          offset: const Offset(0, 48),
          itemBuilder: (_) => [
            PopupMenuItem<void>(enabled: false, child: Text(user?.name ?? '')),
            PopupMenuItem<void>(
              onTap: () => context.push(RoutePaths.profile),
              child: const ListTile(leading: Icon(Icons.person_rounded), title: Text(ProfileTexts.viewProfile)),
            ),
            if (user?.userType.isStaff ?? false)
              PopupMenuItem<void>(
                onTap: () => ref.read(careModeProvider.notifier).set(!care),
                child: ListTile(
                  leading: Icon(care ? Icons.work_rounded : Icons.favorite_rounded),
                  title: Text(care ? CareModeTexts.work : CareModeTexts.care),
                ),
              ),
            PopupMenuItem<void>(
              onTap: () => context.push(RoutePaths.hospitals),
              child: const ListTile(leading: Icon(Icons.local_hospital_rounded), title: Text(CareModeTexts.hospitals)),
            ),
            PopupMenuItem<void>(
              onTap: () => showPickerStyleSheet(context),
              child: const ListTile(leading: Icon(Icons.event_rounded), title: Text(PickerTexts.pickerStyle)),
            ),
            PopupMenuItem<void>(
              onTap: () => ref.read(authControllerProvider.notifier).signOut(),
              child: const ListTile(leading: Icon(Icons.logout_rounded), title: Text(CommonTexts.signOut)),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: scheme.primary,
              child: Text(
                initialsOf(user?.name ?? ''),
                style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
