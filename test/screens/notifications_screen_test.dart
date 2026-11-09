import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/constants/realtime.dart';
import 'package:care_track_client_mobile/constants/route_paths.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/enums/notifications/notification_link_type.dart';
import 'package:care_track_client_mobile/utilities/notifications/notification_route.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/interfaces/realtime/realtime_channel.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/screens/notifications/notifications_screen.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:care_track_client_mobile/widgets/notifications/notification_bell.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FakeServer implements HttpClientAdapter {
  FakeServer(this.respond);

  final Object? Function(RequestOptions request) respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(respond(options)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeTokens implements TokenSource {
  @override
  bool get signedIn => true;

  @override
  Future<String?> validAccessToken() async => 'token';

  @override
  Future<void> handleUnauthorized() async {}
}

class FakeChannel implements RealtimeChannel {
  @override
  bool publish(String destination, Map<String, dynamic> body) => false;

  final controllers = <String, StreamController<Map<String, dynamic>>>{};
  final openedController = StreamController<void>.broadcast();
  bool connected = false;

  @override
  void connect() => connected = true;

  @override
  void disconnect() => connected = false;

  @override
  Stream<Map<String, dynamic>> watch(String destination) =>
      controllers.putIfAbsent(destination, StreamController<Map<String, dynamic>>.broadcast).stream;

  @override
  Stream<void> get opened => openedController.stream;

  void push(String destination, Map<String, dynamic> message) => controllers[destination]!.add(message);
}

class SignedIn extends AuthController {
  @override
  Future<SessionUser?> build() async =>
      const SessionUser(userId: 'u1', name: 'Sara Ali', userType: UserType.patient);
}

Map<String, dynamic> row(String id, {bool read = false, String title = 'Your booking is confirmed'}) => {
  'id': id,
  'type': 'BOOKING_CONFIRMED',
  'titleKey': 'notifications.bookingConfirmed',
  'title': title,
  'linkType': 'PAYSLIPS',
  'linkId': null,
  'hospitalId': null,
  'read': read,
  'readAt': null,
  'createdAt': '2026-11-09T09:00:00Z',
};

Map<String, dynamic> page(List<Map<String, dynamic>> items) => {
  'items': items,
  'page': 0,
  'pageSize': 20,
  'totalItems': items.length,
  'totalPages': 1,
  'hasNext': false,
  'correlationId': 'c',
};

Future<(FakeServer, FakeChannel)> pumpInbox(
  WidgetTester tester, {
  required List<Map<String, dynamic>> items,
  required int unread,
}) async {
  final server = FakeServer((r) {
    if (r.path.endsWith('/unread-count')) return {'unreadCount': unread};
    if (r.path.endsWith('/read-all')) return {'updated': items.length, 'unreadCount': 0};
    if (r.path.endsWith('/read')) return row('r', read: true);
    return page(items);
  });
  final channel = FakeChannel();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
        realtimeChannelProvider.overrideWithValue(channel),
        authControllerProvider.overrideWith(SignedIn.new),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(56), child: NotificationBell()),
          body: NotificationsScreen(),
              ),
            ),
            GoRoute(path: RoutePaths.staffPayslips, builder: (_, _) => const Text('payslips')),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (server, channel);
}

void main() {
  test('a booking opens the booking queue for staff', () {
    expect(notificationRoute(NotificationLinkType.booking, staff: true), RoutePaths.staffQueue);
    expect(notificationRoute(NotificationLinkType.booking, staff: false), RoutePaths.requests);
  });

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('lists the inbox with its unread badge', (tester) async {
    final (server, channel) = await pumpInbox(tester, items: [row('n1'), row('n2', read: true)], unread: 1);

    expect(server.requests.any((r) => r.path == '/notifications'), isTrue);
    expect(find.text('Your booking is confirmed'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);
    expect(channel.connected, isTrue);
  });

  testWidgets('shows the empty inbox', (tester) async {
    await pumpInbox(tester, items: [], unread: 0);
    expect(find.text('Nothing new'), findsOneWidget);
  });

  testWidgets('tapping a row marks it read on the server and clears the badge', (tester) async {
    final (server, _) = await pumpInbox(tester, items: [row('n1')], unread: 1);

    await tester.tap(find.text('Your booking is confirmed'));
    await tester.pumpAndSettle();

    final read = server.requests.singleWhere((r) => r.path.endsWith('/read'));
    expect(read.path, '/notifications/n1/read');
    expect(find.text('1'), findsNothing);
  });

  testWidgets('marks all as read', (tester) async {
    final (server, _) = await pumpInbox(tester, items: [row('n1'), row('n2')], unread: 2);

    await tester.tap(find.byTooltip('Mark all as read'));
    await tester.pumpAndSettle();

    expect(server.requests.any((r) => r.path == '/notifications/read-all'), isTrue);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('a live message appears once and raises the badge; a read change on another device lowers it',
      (tester) async {
    final (_, channel) = await pumpInbox(tester, items: [row('n1')], unread: 1);

    final message = {'notification': row('n2', title: 'Your refund was recorded'), 'quiet': false};
    channel.push(Realtime.notificationsQueue, message);
    channel.push(Realtime.notificationsQueue, message);
    await tester.pumpAndSettle();
    expect(find.text('Your refund was recorded'), findsOneWidget);
    expect(find.text('2'), findsOneWidget, reason: 'the repeat of a row is not counted');

    channel.push(Realtime.readStateQueue, {'notificationId': 'n1', 'unreadCount': 1});
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('a reconnect reads the inbox and count again', (tester) async {
    final (server, channel) = await pumpInbox(tester, items: [row('n1')], unread: 1);
    final before = server.requests.length;

    channel.openedController.add(null);
    await tester.pumpAndSettle();

    expect(server.requests.length, greaterThan(before));
  });
}
