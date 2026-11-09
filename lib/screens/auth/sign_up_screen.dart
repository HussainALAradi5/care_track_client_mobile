import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/sign_up_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/core/service_providers.dart';
import '../../controllers/identity/sign_up_form_controller.dart';
import '../../enums/ui/button_variant.dart';
import '../../widgets/common/buttons/app_button.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/identity/sign_up/about_you_section.dart';
import '../../widgets/identity/sign_up/where_you_live_section.dart';
import '../../widgets/identity/sign_up/your_hospital_section.dart';

/// After creating a sign-in on the identity provider, the person finishes signing up here. The account is always a
/// patient's; the screen never asks for or sends a user type.
class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final user = await ref.read(signUpFormProvider.notifier).submit();
    if (context.mounted) AppSnack.success(context, SignUpTexts.done);
    ref.read(authControllerProvider.notifier).completeSignUp(user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final email = ref.read(authServiceProvider).email;
    return Scaffold(
      appBar: AppBar(title: const Text(SignUpTexts.title)),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.page,
          children: [
            Text(SignUpTexts.lead, style: muted),
            if (email != null) ...[
              const SizedBox(height: AppSpacing.small),
              Text('${SignUpTexts.signedInAs} $email', style: muted),
            ],
            const SizedBox(height: AppSpacing.large),
            const AboutYouSection(),
            const SizedBox(height: AppSpacing.medium),
            const WhereYouLiveSection(),
            const SizedBox(height: AppSpacing.medium),
            const YourHospitalSection(),
            const SizedBox(height: AppSpacing.medium),
            Text(SignUpTexts.patientNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.large),
            AppButton(
              label: SignUpTexts.submit,
              icon: Icons.check_rounded,
              expand: true,
              onPressed: () => _submit(context, ref),
            ),
            const SizedBox(height: AppSpacing.small),
            AppButton(
              label: SignUpTexts.useAnother,
              icon: Icons.switch_account_rounded,
              variant: ButtonVariant.text,
              expand: true,
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
