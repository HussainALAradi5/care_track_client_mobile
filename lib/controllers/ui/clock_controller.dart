import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';

/// One shared ticking "now", so every countdown on screen updates together.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(AppConstants.clockTick, (_) => DateTime.now());
});

/// The latest tick, falling back to the real time before the first one.
final nowProvider = Provider<DateTime>((ref) => ref.watch(clockProvider).value ?? DateTime.now());
