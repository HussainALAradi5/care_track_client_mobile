import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// Staff are people too: "My care" shows a staff member the patient side instead of their work. Remembered on this
/// device per account, so it is cleared at sign-out and the next person starts on their own choice.
class CareModeController extends Notifier<bool> {
  @override
  bool build() {
    final userId = ref.watch(signedInUserIdProvider);
    if (userId == null) return false;
    return ref.read(sharedPreferencesProvider).getBool(_keyOf(userId)) ?? false;
  }

  Future<void> set(bool care) async {
    final userId = ref.read(signedInUserIdProvider);
    if (userId == null || care == state) return;
    state = care;
    await ref.read(sharedPreferencesProvider).setBool(_keyOf(userId), care);
  }

  String _keyOf(String userId) => '${AppConstants.careModeKey}.$userId';
}

final careModeProvider = NotifierProvider<CareModeController, bool>(CareModeController.new);
