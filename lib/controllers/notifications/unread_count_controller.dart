import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/service_providers.dart';

/// The unread total behind the badge. The server's count wins; between reads it follows the changes made here.
class UnreadCountController extends AsyncNotifier<int> {
  @override
  Future<int> build() => ref.read(notificationServiceProvider).unreadCount();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  void setCount(int count) => state = AsyncData(count);

  void increase() => state = AsyncData((state.value ?? 0) + 1);

  void decrease() {
    final count = state.value ?? 0;
    if (count > 0) state = AsyncData(count - 1);
  }
}

final unreadCountProvider = AsyncNotifierProvider<UnreadCountController, int>(UnreadCountController.new);
