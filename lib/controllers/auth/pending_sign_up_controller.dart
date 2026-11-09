import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while this sign-in has no CareTrack account yet and the person still has to finish signing up.
class PendingSignUpController extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final pendingSignUpProvider = NotifierProvider<PendingSignUpController, bool>(PendingSignUpController.new);
