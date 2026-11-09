import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes/app_router.dart';
import '../../constants/notification_rules.dart';
import '../../controllers/notifications/notification_opener.dart';
import '../../controllers/ui/app_toast_controller.dart';
import '../../models/ui/app_toast.dart';

/// Floats toasts over whatever is on screen; a live notification's toast has an action that opens it.
class AppToastHost extends ConsumerWidget {
  const AppToastHost({super.key, required this.child});

  final Widget child;

  Future<void> _open(WidgetRef ref, AppToast toast) async {
    final path = await ref.read(notificationOpenerProvider).open(toast.notification!);
    if (path != null) ref.read(appRouterProvider).go(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appToastProvider, (_, toast) {
      if (toast == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: NotificationRules.toastSeconds,
            content: Text(toast.message),
            action: toast.notification == null || toast.actionLabel == null
                ? null
                : SnackBarAction(label: toast.actionLabel!, onPressed: () => _open(ref, toast)),
          ),
        );
    });
    return child;
  }
}
