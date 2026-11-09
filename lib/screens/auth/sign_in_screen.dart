import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../../constants/texts/common_texts.dart';
import '../../constants/texts/sign_up_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../enums/ui/button_variant.dart';
import '../../widgets/common/brand/brand_mark.dart';
import '../../widgets/common/brand/glow_blob.dart';
import '../../widgets/common/buttons/app_button.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/motion/fade_slide_in.dart';

/// Hands sign-in to the identity provider in the system browser; the router moves on once signed in. A sign-in that
/// fails (for example one without a CareTrack account yet) says why.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (_, next) {
      final error = next.error;
      if (next is AsyncError && error != null) AppSnack.error(context, error);
    });
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -120, left: -80, child: GlowBlob(color: scheme.primary)),
          Positioned(bottom: -140, right: -90, child: GlowBlob(color: scheme.tertiary)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: FadeSlideIn(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BrandMark(),
                          const SizedBox(height: 16),
                          Text(AppConstants.appName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                          Text(AppConstants.tagline, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                          const SizedBox(height: 20),
                          const Text(CommonTexts.signInIntro, textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          AppButton(
                            label: CommonTexts.signIn,
                            icon: Icons.login_rounded,
                            expand: true,
                            onPressed: () => ref.read(authControllerProvider.notifier).signIn(),
                          ),
                          const SizedBox(height: 8),
                          AppButton(
                            label: SignUpTexts.createAccount,
                            icon: Icons.person_add_alt_1_rounded,
                            variant: ButtonVariant.outlined,
                            expand: true,
                            onPressed: () => ref.read(authControllerProvider.notifier).register(),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => context.push(RoutePaths.find),
                            icon: const Icon(Icons.travel_explore_rounded),
                            label: const Text(CareModeTexts.findHospitals),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
