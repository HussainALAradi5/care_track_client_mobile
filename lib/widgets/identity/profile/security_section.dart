import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/auth_config.dart';
import '../../../constants/texts/profile_texts.dart';
import '../../../enums/ui/button_variant.dart';
import '../../common/buttons/app_button.dart';
import '../../common/display/section_card.dart';
import '../../common/feedback/app_snack.dart';

/// The identity provider's account page, offered as a link to copy.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: AuthConfig.accountConsoleUrl));
    if (context.mounted) AppSnack.success(context, ProfileTexts.linkCopied);
  }

  @override
  Widget build(BuildContext context) => SectionCard(
    title: ProfileTexts.securityTitle,
    hint: ProfileTexts.securityBody,
    children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: AppButton(
          label: ProfileTexts.copyLink,
          icon: Icons.link_rounded,
          variant: ButtonVariant.outlined,
          onPressed: () => _copy(context),
        ),
      ),
    ],
  );
}
