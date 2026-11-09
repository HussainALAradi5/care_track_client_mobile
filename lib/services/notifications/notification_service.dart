import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/notifications/app_notification.dart';
import '../../models/notifications/notification_preferences.dart';
import '../api/api_client.dart';

/// The caller's own notifications; REST is the source of truth and the fallback when the live channel is down.
class NotificationService {
  NotificationService(this._api);

  final ApiClient _api;

  Future<PageResult<AppNotification>> list(PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.notifications, query: request.toQuery()),
    AppNotification.fromJson,
  );

  Future<int> unreadCount() async {
    final json = await _api.get(Endpoints.notificationsUnreadCount);
    return (json['unreadCount'] as num).toInt();
  }

  Future<NotificationPreferences> preferences() async =>
      NotificationPreferences.fromJson(await _api.get(Endpoints.notificationPreferences));

  Future<NotificationPreferences> savePreferences(NotificationPreferences preferences) async =>
      NotificationPreferences.fromJson(await _api.put(Endpoints.notificationPreferences, body: preferences.toSaveJson()));

  Future<AppNotification> markRead(String id) async =>
      AppNotification.fromJson(await _api.post(Endpoints.notificationRead(id)));

  Future<int> markAllRead() async {
    final json = await _api.post(Endpoints.notificationsReadAll);
    return (json['unreadCount'] as num).toInt();
  }
}
