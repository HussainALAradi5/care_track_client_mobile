import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/error_codes.dart';
import '../../enums/ui/picker_style.dart';
import '../../models/identity/session_user.dart';
import '../../utilities/http/error_message.dart';
import '../core/service_providers.dart';
import 'pending_sign_up_controller.dart';

/// The signed-in CareTrack profile, or null when signed out. Restores a stored sign-in at start-up.
class AuthController extends AsyncNotifier<SessionUser?> {
  @override
  Future<SessionUser?> build() async {
    final auth = ref.watch(authServiceProvider);
    final sub = auth.expired.listen((_) {
      ref.read(pendingSignUpProvider.notifier).set(false);
      state = const AsyncData(null);
    });
    ref.onDispose(sub.cancel);
    if (!await auth.restore()) return null;
    return _loadProfile();
  }

  Future<void> signIn() => _enter(register: false);

  /// Creates a sign-in on the identity provider's registration page; the person then finishes signing up here.
  Future<void> register() => _enter(register: true);

  Future<void> _enter({required bool register}) async {
    try {
      if (!await ref.read(authServiceProvider).signIn(register: register)) return;
    } catch (error, stackTrace) {
      // A refused token exchange must reach the sign-in screen instead of leaving it looking untouched.
      state = AsyncError(error, stackTrace);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadProfile);
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    ref.read(pendingSignUpProvider.notifier).set(false);
    state = const AsyncData(null);
  }

  /// The account the Finish signing up form just created.
  void completeSignUp(SessionUser user) {
    ref.read(pendingSignUpProvider.notifier).set(false);
    state = AsyncData(user);
  }

  /// Saves the person's own picker look and shows it at once; a failed save throws and changes nothing.
  Future<void> setPickerStyle(PickerStyle? style) async {
    state = AsyncData(await ref.read(sessionServiceProvider).setPickerStyle(style));
  }

  /// A rejected token counts as signed out; a sign-in without an account keeps its tokens and finishes signing up.
  Future<SessionUser?> _loadProfile() async {
    try {
      return await _accountOfThisSignIn();
    } catch (error) {
      if (apiErrorCodeOf(error) == ErrorCodes.invitationNotFound) {
        ref.read(pendingSignUpProvider.notifier).set(true);
        return null;
      }
      // No answer from the server says nothing about the account, so the stored sign-in stays for the next attempt.
      if (!_isUnanswered(error)) await ref.read(authServiceProvider).signOut();
      rethrow;
    }
  }

  /// One without an account first tries the profile an import prepared for its email.
  Future<SessionUser> _accountOfThisSignIn() async {
    final session = ref.read(sessionServiceProvider);
    try {
      return await session.me();
    } catch (error) {
      if (apiErrorCodeOf(error) != ErrorCodes.signUpRequired) rethrow;
      return session.linkInvitation();
    }
  }


  bool _isUnanswered(Object error) => error is DioException && error.response == null;
}

final authControllerProvider = AsyncNotifierProvider<AuthController, SessionUser?>(AuthController.new);

/// Who is signed in, or null; what one person's data hangs on, so it is rebuilt when someone else signs in.
final signedInUserIdProvider = Provider<String?>(
  (ref) => ref.watch(authControllerProvider.select((auth) => auth.value?.userId)),
);
