import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/notifications/app_notification.dart';
import '../core/service_providers.dart';
import 'unread_count_controller.dart';

/// The signed-in person's inbox, newest first: REST pages, plus live rows and read changes as they arrive.
class NotificationInboxController extends AsyncNotifier<PagedItems<AppNotification>> {
  @override
  Future<PagedItems<AppNotification>> build() async => _toItems(await _fetch(0), const []);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(_toItems(await _fetch(current.nextPage), current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  /// A live row: prepended once. Returns false for a repeat, which changes nothing (and must not be counted again).
  bool receive(AppNotification notification) {
    final current = state.value;
    if (current == null) return true;
    if (current.items.any((item) => item.id == notification.id)) return false;
    state = AsyncData(current.copyWith(items: [notification, ...current.items]));
    return true;
  }

  /// [id] null marks every row read.
  void applyRead(String? id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [for (final item in current.items) id == null || item.id == id ? item.copyWith(read: true) : item],
      ),
    );
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.read) return;
    applyRead(notification.id);
    ref.read(unreadCountProvider.notifier).decrease();
    await ref.read(notificationServiceProvider).markRead(notification.id);
  }

  Future<void> markAllRead() async {
    applyRead(null);
    ref.read(unreadCountProvider.notifier).setCount(await ref.read(notificationServiceProvider).markAllRead());
  }

  Future<PageResult<AppNotification>> _fetch(int page) => ref
      .read(notificationServiceProvider)
      .list(PageRequest(page: page, pageSize: AppConstants.pageSize));

  PagedItems<AppNotification> _toItems(PageResult<AppNotification> page, List<AppNotification> before) =>
      PagedItems(items: [...before, ...page.items], nextPage: page.page + 1, hasNext: page.hasNext);
}

final notificationInboxProvider = AsyncNotifierProvider<NotificationInboxController, PagedItems<AppNotification>>(
  NotificationInboxController.new,
);
