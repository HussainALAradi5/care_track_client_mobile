import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/brand_colors.dart';

/// Green when the other person is online, muted otherwise.
class PresenceDot extends StatelessWidget {
  const PresenceDot({super.key, required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) => Container(
    width: AppSpacing.small,
    height: AppSpacing.small,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: online ? BrandColors.success : Theme.of(context).colorScheme.outline,
    ),
  );
}
