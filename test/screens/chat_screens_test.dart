import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/constants/realtime.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/interfaces/realtime/realtime_channel.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/screens/chat/chat_list_screen.dart';
import 'package:care_track_client_mobile/screens/chat/chat_thread_screen.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

class FakeServer implements HttpClientAdapter {
  FakeServer(this.respond);

  final Object? Function(RequestOptions request) respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
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
  final controllers = <String, StreamController<Map<String, dynamic>>>{};
  final openedController = StreamController<void>.broadcast();

  @override
  void connect() {}

  @override
  void disconnect() {}

  @override
  Stream<Map<String, dynamic>> watch(String destination) =>
      controllers.putIfAbsent(destination, StreamController<Map<String, dynamic>>.broadcast).stream;

  @override
  Stream<void> get opened => openedController.stream;

  void push(Map<String, dynamic> frame) => controllers[Realtime.chatQueue]!.add(frame);
}

class SignedIn extends AuthController {
  @override
  Future<SessionUser?> build() async => const SessionUser(userId: 'u1', name: 'Sara', userType: UserType.patient);
}

Map<String, dynamic> conversation({int unread = 2, int peerRead = 0, int peerDelivered = 0}) => {
  'id': 'c1',
  'hospitalId': 'h1',
  'kind': 'PATIENT_CARE',
  'patientId': 'u1',
  'lastSequence': 2,
  'lastMessageAt': '2026-11-09T09:00:00Z',
  'unreadCount': unread,
  'lastReadSequence': 0,
  'muted': false,
  'mutedUntil': null,
  'hidden': false,
  'myUserId': 'u1',
  'participants': [
    {'userId': 'u1', 'name': 'Sara', 'side': 'PATIENT', 'lastReadSequence': 0, 'lastDeliveredSequence': 0, 'active': true, 'online': true},
    {'userId': 'u2', 'name': 'Dr Ali', 'side': 'STAFF', 'lastReadSequence': peerRead, 'lastDeliveredSequence': peerDelivered, 'active': true, 'online': false},
  ],
};

Map<String, dynamic> message(int sequence, {String sender = 'u2', String text = 'hello', String? clientKey}) => {
  'id': 'm$sequence',
  'conversationId': 'c1',
  'sequence': sequence,
  'senderId': sender,
  'text': text,
  'replyTo': null,
  'edited': false,
  'editedAt': null,
  'deleted': false,
  'createdAt': '2026-11-09T09:00:0${sequence}Z',
  'clientKey': clientKey ?? 'k$sequence',
  'reactions': <dynamic>[],
  'attachments': <dynamic>[],
};

Future<(FakeServer, FakeChannel)> pump(
  WidgetTester tester,
  Widget home, {
  required Object? Function(RequestOptions request) respond,
}) async {
  final server = FakeServer(respond);
  final channel = FakeChannel();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
        realtimeChannelProvider.overrideWithValue(channel),
        authControllerProvider.overrideWith(SignedIn.new),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: home),
    ),
  );
  await tester.pumpAndSettle();
  return (server, channel);
}

Object? chatResponses(RequestOptions r, {Map<String, dynamic>? sent, bool failSend = false}) {
  if (r.path.endsWith('/conversations')) {
    return {
      'items': [conversation()],
      'page': 0,
      'pageSize': 20,
      'totalItems': 1,
      'totalPages': 1,
      'hasNext': false,
    };
  }
  if (r.path.endsWith('/read')) return {'userId': 'u1', 'readSequence': 2, 'deliveredSequence': 2};
  if (r.path.endsWith('/messages') && r.method == 'POST') {
    if (failSend) throw DioException(requestOptions: r, type: DioExceptionType.connectionError);
    return sent;
  }
  return {
    'items': [message(1, sender: 'u1', text: 'mine'), message(2, text: 'from the doctor')],
    'hasMore': false,
    'nextBefore': null,
  };
}

Finder readTicks() => find.byWidgetPredicate((w) => w is Icon && w.semanticLabel == 'Read');

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('lists conversations with their unread count', (tester) async {
    await pump(tester, const ChatListScreen(), respond: (r) => chatResponses(r));
    expect(find.text('Dr Ali'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('shows messages, sends optimistically and confirms with the idempotency key', (tester) async {
    final (server, _) = await pump(
      tester,
      const ChatThreadScreen(conversationId: 'c1'),
      respond: (r) => chatResponses(r, sent: message(3, sender: 'u1', text: 'on my way', clientKey: r.headers['Idempotency-Key'] as String?)),
    );
    expect(find.text('from the doctor'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'on my way');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();

    final post = server.requests.singleWhere((r) => r.method == 'POST' && r.path.endsWith('/messages'));
    expect(post.headers['Idempotency-Key'], isNotNull);
    expect(find.text('on my way'), findsOneWidget);
    expect(find.text('Sending...'), findsNothing);
  });

  testWidgets('a failed send can be retried and keeps its key', (tester) async {
    var fail = true;
    final (server, _) = await pump(
      tester,
      const ChatThreadScreen(conversationId: 'c1'),
      respond: (r) => chatResponses(r, sent: message(3, sender: 'u1', text: 'retry me'), failSend: fail),
    );
    await tester.enterText(find.byType(TextField), 'retry me');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Not sent'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    final posts = server.requests.where((r) => r.method == 'POST' && r.path.endsWith('/messages')).toList();
    expect(posts.length, 2);
    expect(posts[0].headers['Idempotency-Key'], posts[1].headers['Idempotency-Key']);
    expect(find.text('Not sent'), findsNothing);
  });

  testWidgets('a live message appears once and a read receipt reaches the conversation', (tester) async {
    final (_, channel) = await pump(tester, const ChatThreadScreen(conversationId: 'c1'), respond: (r) => chatResponses(r));

    final frame = {'type': 'MESSAGE_NEW', 'conversationId': 'c1', 'data': message(3, text: 'from afar')};
    channel.push(frame);
    channel.push(frame);
    await tester.pumpAndSettle();
    expect(find.text('from afar'), findsOneWidget);
    expect(readTicks(), findsNothing);

    channel.push({
      'type': 'RECEIPT',
      'conversationId': 'c1',
      'data': {'userId': 'u2', 'readSequence': 3, 'deliveredSequence': 3},
    });
    await tester.pumpAndSettle();
    expect(readTicks(), findsOneWidget);
  });

  testWidgets('long-pressing a message starts a reply', (tester) async {
    await pump(tester, const ChatThreadScreen(conversationId: 'c1'), respond: (r) => chatResponses(r));
    await tester.longPress(find.text('from the doctor'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Replying to'), findsOneWidget);
  });
}
