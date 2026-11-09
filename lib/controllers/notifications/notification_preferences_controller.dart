import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notifications/notification_preferences.dart';
import '../../models/notifications/notification_type_preference.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The notification settings while they are edited; saving sends them all. Empty signed out.
class NotificationPreferencesController extends AsyncNotifier<NotificationPreferences?> {
  @override
  Future<NotificationPreferences?> build() async {
    if (ref.watch(signedInUserIdProvider) == null) return null;
    return ref.read(notificationServiceProvider).preferences();
  }

  void _change(NotificationPreferences Function(NotificationPreferences) edit) {
    final current = state.value;
    if (current != null) state = AsyncData(edit(current));
  }

  void setType(NotificationTypePreference row) => _change(
    (p) => p.copyWith(types: [for (final t in p.types) t.type == row.type ? row : t]),
  );

  void setQuietOn(bool value) => _change((p) => p.copyWith(quietOn: value));
  void setQuietStart(TimeOfDay value) => _change((p) => p.copyWith(quietStart: value));
  void setQuietEnd(TimeOfDay value) => _change((p) => p.copyWith(quietEnd: value));

  Future<void> save() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(await ref.read(notificationServiceProvider).savePreferences(current));
  }
}

final notificationPreferencesProvider =
    AsyncNotifierProvider.autoDispose<NotificationPreferencesController, NotificationPreferences?>(
      NotificationPreferencesController.new,
    );
