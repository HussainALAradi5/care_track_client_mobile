import 'package:flutter/material.dart';

import '../../../utilities/http/error_message.dart';
import '../../../constants/brand_colors.dart';

/// Short floating confirmations and errors.
class AppSnack {
  const AppSnack._();

  static void success(BuildContext context, String message) =>
      _show(context, message, Icons.check_circle_rounded, BrandColors.success);

  static void error(BuildContext context, Object error) =>
      _show(context, errorMessageOf(error), Icons.error_rounded, Theme.of(context).colorScheme.error);

  static void _show(BuildContext context, String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: BrandColors.onSolid),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: const TextStyle(color: BrandColors.onSolid))),
            ],
          ),
        ),
      );
  }
}
