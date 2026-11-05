import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/identity/session_user.dart';
import '../core/service_providers.dart';

/// The signed-in CareTrack profile, or null when signed out. Restores a stored sign-in at start-up.
class AuthController extends AsyncNotifier<SessionUser?> {
  @override
  Future<SessionUser?> build() async {
    final auth = ref.watch(authServiceProvider);
    final sub = auth.expired.listen((_) => state = const AsyncData(null));
    ref.onDispose(sub.cancel);
    if (!await auth.restore()) return null;
    return _loadProfile();
  }

  Future<void> signIn() async {
    if (!await ref.read(authServiceProvider).signIn()) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadProfile);
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = const AsyncData(null);
  }

  /// A token without a linked CareTrack account (or a rejected one) counts as signed out.
  Future<SessionUser?> _loadProfile() async {
    try {
      return await ref.read(sessionServiceProvider).me();
    } catch (_) {
      await ref.read(authServiceProvider).signOut();
      rethrow;
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, SessionUser?>(AuthController.new);
