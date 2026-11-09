import 'package:flutter/widgets.dart';

import '../common/feedback/app_snack.dart';

/// Runs one chat action; a refusal shows as a snack.
Future<void> runChatAction(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } catch (error) {
    if (context.mounted) AppSnack.error(context, error);
  }
}
