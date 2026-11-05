import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

/// A large selectable card (radio-like) with an icon or initials, a title and a subtitle.
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.initials,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? initials;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimaryContainer : scheme.onSurface;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: AnimatedContainer(
        duration: Motion.medium,
        curve: Motion.standard,
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Motion.medium,
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: initials != null
                      ? Text(
                          initials!,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: selected ? scheme.onPrimary : scheme.primary,
                          ),
                        )
                      : Icon(icon, color: selected ? scheme.onPrimary : scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall?.copyWith(color: foreground)),
                      if (subtitle != null)
                        Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: 0.75))),
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: selected ? 1 : 0,
                  duration: Motion.medium,
                  curve: Motion.emphasized,
                  child: Icon(Icons.check_circle_rounded, color: scheme.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
