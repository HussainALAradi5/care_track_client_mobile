import 'package:flutter/material.dart';

import '../../../constants/brand_colors.dart';
import '../../../constants/motion.dart';
import '../../../enums/ui/avatar_tone.dart';
import '../../../utilities/text/initials.dart';

/// Rounded tile at the start of a row or card: a person's initials when [name] is given, else [icon].
class Avatar extends StatelessWidget {
  const Avatar({super.key, this.icon = Icons.person_rounded, this.name, this.tone = AvatarTone.primary});

  final IconData icon;
  final String? name;
  final AvatarTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      AvatarTone.primary => (scheme.primaryContainer, scheme.onPrimaryContainer),
      AvatarTone.secondary => (scheme.secondaryContainer, scheme.onSecondaryContainer),
      AvatarTone.solid => (scheme.primary, scheme.onPrimary),
      AvatarTone.inverse => (BrandColors.onGradientPanel, scheme.onPrimary),
    };
    final initials = name == null || name!.trim().isEmpty ? null : initialsOf(name!);
    return AnimatedContainer(
      duration: Motion.medium,
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: initials == null
          ? Icon(icon, color: foreground)
          : Text(
              initials,
              style: TextStyle(color: foreground, fontWeight: FontWeight.w700, fontSize: 14),
            ),
    );
  }
}
