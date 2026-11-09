import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'controllers/ui/theme_controller.dart';
import 'widgets/notifications/app_toast_host.dart';

class CareTrackApp extends ConsumerWidget {
  const CareTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
      builder: (_, child) => AppToastHost(child: child!),
    );
  }
}
