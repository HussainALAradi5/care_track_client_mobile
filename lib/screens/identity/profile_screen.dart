import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/profile_texts.dart';
import '../../widgets/identity/profile/places_section.dart';
import '../../widgets/identity/profile/preferences_section.dart';
import '../../widgets/identity/profile/profile_header.dart';
import '../../widgets/identity/profile/security_section.dart';

/// The signed-in person's own account, where they belong, and their preferences.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(ProfileTexts.title)),
    body: ListView(
      padding: AppSpacing.page,
      children: const [
        Text(ProfileTexts.subtitle),
        SizedBox(height: AppSpacing.medium),
        ProfileHeader(),
        SizedBox(height: AppSpacing.medium),
        PlacesSection(),
        SizedBox(height: AppSpacing.medium),
        PreferencesSection(),
        SizedBox(height: AppSpacing.medium),
        SecuritySection(),
      ],
    ),
  );
}
