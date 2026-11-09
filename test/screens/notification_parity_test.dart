import 'dart:async';

import 'package:care_track_client_mobile/constants/realtime.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/notifications/notification_live_controller.dart';
import 'package:care_track_client_mobile/controllers/ui/picker_style_controller.dart';
import 'package:care_track_client_mobile/enums/notifications/notification_link_type.dart';
import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/interfaces/realtime/realtime_channel.dart';
import 'package:care_track_client_mobile/screens/identity/profile_screen.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:care_track_client_mobile/utilities/notifications/notification_route.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/smooth_calendar.dart';
import 'package:care_track_client_mobile/widgets/notifications/app_toast_host.dart';
import 'package:care_track_client_mobile/widgets/notifications/preferences/notification_preferences_section.dart';
import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/constants/route_paths.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notifications/notification_preferences_test.dart' show preferencesJson;
import '../support/api_harness.dart';

class Channel implements RealtimeChannel {
  final notifications = StreamController<Map<String, dynamic>>.broadcast();

  @override
  void connect() {}

  @override
  void disconnect() {}

  @override
  bool publish(String destination, Map<String, dynamic> body) => false;

  @override
  Stream<Map<String, dynamic>> watch(String destination) =>
      destination == Realtime.notificationsQueue ? notifications.stream : const Stream.empty();

  @override
  Stream<void> get opened => const Stream.empty();
}

Map<String, dynamic> live(bool quiet, {String linkType = 'LEAVE_REQUEST'}) => {
  'quiet': quiet,
  'notification': {
    'id': 'n1',
    'type': 'LEAVE_APPROVED',
    'title': 'Your leave request was approved',
    'linkType': linkType,
    'linkId': null,
    'hospitalId': null,
    'read': false,
    'createdAt': '2026-11-09T09:00:00Z',
  },
};

Object? server(RequestOptions r) {
  if (r.path == '/notifications/preferences') return r.method == 'PUT' ? r.data : preferencesJson();
  if (r.path == '/patients/me/hospitals') return pageOf(const []);
  if (r.path == '/notifications') return pageOf(const []);
  if (r.path == '/notifications/unread-count') return {'unreadCount': 0};
  return <String, dynamic>{};
}

Future<Channel> pumpToasts(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final channel = Channel();
  final fake = FakeServer(server);
  final router = GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => const Scaffold(body: Text('home')))]);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dioFor(fake))),
        authControllerProvider.overrideWith(() => FixedAuth(doctor)),
        realtimeChannelProvider.overrideWithValue(channel),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(notificationLiveProvider);
          return MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
            builder: (_, child) => AppToastHost(child: child!),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return channel;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('leave and payslip rows now open their screens', () {
    expect(notificationRoute(NotificationLinkType.leaveRequest, staff: true), RoutePaths.staffLeave);
    expect(notificationRoute(NotificationLinkType.payslips, staff: true), RoutePaths.staffPayslips);
    expect(notificationRoute(NotificationLinkType.staffRequest, staff: true), RoutePaths.staffRequests);
  });

  testWidgets('a live notification floats a toast with its action', (tester) async {
    final channel = await pumpToasts(tester);
    channel.notifications.add(live(false));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    expect(find.text('Your leave request was approved'), findsOneWidget);
    expect(find.text('View leave'), findsOneWidget);
  });

  testWidgets('quiet hours: it counts but does not interrupt', (tester) async {
    final channel = await pumpToasts(tester);
    channel.notifications.add(live(true));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    expect(find.text('Your leave request was approved'), findsNothing);
  });

  testWidgets('signed out, the settings load nothing', (tester) async {
    final s = await pumpScreen(
      tester,
      const NotificationPreferencesSection(),
      server,
      overrides: [signedInUserIdProvider.overrideWithValue(null)],
    );
    expect(s.requests, isEmpty);
    expect(find.text('Save notification settings'), findsNothing);
  });

  testWidgets('saves a changed channel and quiet hours', (tester) async {
    final s = await pumpScreen(
      tester,
      const NotificationPreferencesSection(),
      server,
      overrides: [
        authControllerProvider.overrideWith(() => FixedAuth(doctor)),
        chosenPickerStyleProvider.overrideWithValue(PickerStyle.smooth),
      ],
    );
    expect(find.text('Leave approved'), findsOneWidget);
    await tester.tap(find.text('Email'));
    await tester.pump();
    await tester.tap(find.text('Use quiet hours'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save notification settings'));
    await tester.pumpAndSettle();
    expect(s.lastTo('/notifications/preferences').data, {
      'types': [
        {'type': 'LEAVE_APPROVED', 'inApp': true, 'push': false, 'email': true},
      ],
      'quietHoursStart': '22:00',
      'quietHoursEnd': '07:00',
    });
    expect(find.text('Notification settings saved.'), findsOneWidget);
  });

  testWidgets('quiet hours times open through AppPickers', (tester) async {
    await pumpScreen(
      tester,
      const NotificationPreferencesSection(),
      (r) => r.path == '/notifications/preferences'
          ? preferencesJson(start: '22:00:00', end: '07:00:00')
          : server(r),
      overrides: [
        authControllerProvider.overrideWith(() => FixedAuth(doctor)),
        chosenPickerStyleProvider.overrideWithValue(PickerStyle.android),
      ],
    );
    await tester.tap(find.text('From'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    expect(find.byType(SmoothCalendar), findsNothing);
  });

  testWidgets('the settings show on My profile, and a load failure says so', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      (r) => r.path == '/notifications/preferences' ? const Failure(500, 'BOOM') : server(r),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
