import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/identity_styles.dart';
import '../../../constants/texts/profile_texts.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/core/service_providers.dart';
import '../../../enums/identity/user_type.dart';
import '../../../utilities/text/initials.dart';
import 'care_mode_switch.dart';

/// Name, username and email; the account type is shown to administrators only.
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final email = ref.read(authServiceProvider).email;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          children: [
            CircleAvatar(
              radius: AppSpacing.avatarRadius,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                initialsOf(user.name),
                style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(user.name, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            if (user.userType == UserType.administrator)
              Text('${ProfileTexts.accountType}: ${IdentityStyles.userTypeLabels[user.userType]}'),
            if (user.username != null) Text('${ProfileTexts.username}: ${user.username}'),
            if (email != null) Text('${ProfileTexts.email}: $email'),
            if (user.userType.isStaff) ...[
              const SizedBox(height: AppSpacing.medium),
              const CareModeSwitch(),
            ],
          ],
        ),
      ),
    );
  }
}
