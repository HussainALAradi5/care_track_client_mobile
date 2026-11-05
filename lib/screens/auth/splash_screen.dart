import 'package:flutter/material.dart';

import '../../widgets/common/brand/heartbeat_loader.dart';

/// Shown while a stored sign-in is restored at start-up.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: HeartbeatLoader());
}
