import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/document_texts.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../models/documents/written_document.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';

/// A sick note's rest days and, for people who work somewhere, Use for my leave.
class SickNoteUse extends ConsumerWidget {
  const SickNoteUse({super.key, required this.document});

  final WrittenDocument document;

  Future<void> _use(BuildContext context) async {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(RoutePaths.staffLeaveWithSickNote(document.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final works = ref.watch(authControllerProvider).value?.userType.isStaff ?? false;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(DocumentTexts.restLine(longDate(document.restFrom!), longDate(document.restTo!)), style: theme.textTheme.titleSmall),
          if (works) ...[
            const SizedBox(height: AppSpacing.tiny),
            Text(DocumentTexts.useForLeaveHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.small),
            AppButton(
              label: DocumentTexts.useForLeave,
              icon: Icons.flight_takeoff_rounded,
              onPressed: () => _use(context),
            ),
          ],
        ],
      ),
    );
  }
}
