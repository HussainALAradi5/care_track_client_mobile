import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the app is on screen, following the platform lifecycle.
class AppForegroundController extends Notifier<bool> {
  @override
  bool build() {
    final listener = AppLifecycleListener(onStateChange: (next) => state = next == AppLifecycleState.resumed);
    ref.onDispose(listener.dispose);
    final current = WidgetsBinding.instance.lifecycleState;
    return current == null || current == AppLifecycleState.resumed;
  }
}

final appForegroundProvider = NotifierProvider<AppForegroundController, bool>(AppForegroundController.new);
