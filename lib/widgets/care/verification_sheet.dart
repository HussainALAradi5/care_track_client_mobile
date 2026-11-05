import 'package:flutter/material.dart';

import '../../constants/texts/staff_texts.dart';
import '../../enums/identity/presence_verification_method.dart';

/// Asks how the desk checked the patient's identity; null when dismissed.
Future<PresenceVerificationMethod?> showVerificationSheet(BuildContext context) =>
    showModalBottomSheet<PresenceVerificationMethod>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(StaffTexts.checkInTitle, style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final method in PresenceVerificationMethod.values)
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(StaffTexts.verification[method]!),
                onTap: () => Navigator.of(context).pop(method),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
