import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ui/app_toast.dart';
import '../auth/auth_controller.dart';

/// The latest toast to show over any screen; cleared at sign-out so the next person never sees it.
class AppToastController extends Notifier<AppToast?> {
  @override
  AppToast? build() {
    ref.watch(signedInUserIdProvider);
    return null;
  }

  void show(AppToast toast) => state = toast;
}

final appToastProvider = NotifierProvider<AppToastController, AppToast?>(AppToastController.new);
