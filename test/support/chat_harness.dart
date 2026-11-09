import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/interfaces/realtime/realtime_channel.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Respond = FutureOr<Object?> Function(RequestOptions request);

class FakeServer implements HttpClientAdapter {
  FakeServer(this.respond);

  final Respond respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(await respond(options)),
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
  final openedController = StreamController<void>.broadcast();
  final controllers = <String, StreamController<Map<String, dynamic>>>{};

  @override
  void connect() {}

  @override
  void disconnect() {}

  @override
  Stream<Map<String, dynamic>> watch(String destination) =>
      controllers.putIfAbsent(destination, StreamController<Map<String, dynamic>>.broadcast).stream;

  @override
  bool publish(String destination, Map<String, dynamic> body) => false;

  @override
  Stream<void> get opened => openedController.stream;
}

/// A channel that records what was published; [up] false means sending falls back to REST.
class RecordingChannel extends FakeChannel {
  RecordingChannel({this.up = false});

  final bool up;
  final published = <String, Map<String, dynamic>>{};

  @override
  bool publish(String destination, Map<String, dynamic> body) {
    if (up) published[destination] = body;
    return up;
  }
}

/// Signs in as one person and can switch to another or to nobody.
class SwitchableAuth extends AuthController {
  @override
  Future<SessionUser?> build() async => const SessionUser(userId: 'a', name: 'A', userType: UserType.patient);

  void become(SessionUser? user) => state = AsyncData(user);
}

class Harness {
  Harness(this.container, this.server, this.channel);

  final ProviderContainer container;
  final FakeServer server;
  final FakeChannel channel;
}

Future<Harness> chatHarness(Respond respond, {List<Override> overrides = const [], FakeChannel? liveChannel}) async {
  final server = FakeServer(respond);
  final channel = liveChannel ?? FakeChannel();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
      realtimeChannelProvider.overrideWithValue(channel),
      authControllerProvider.overrideWith(SwitchableAuth.new),
      ...overrides,
    ],
  );
  await container.read(authControllerProvider.future);
  return Harness(container, server, channel);
}

Map<String, dynamic> conversationJson(String id, {int unread = 0, int lastSequence = 2}) => {
  'id': id,
  'hospitalId': 'h1',
  'kind': 'PATIENT_CARE',
  'patientId': 'a',
  'lastSequence': lastSequence,
  'lastMessageAt': '2026-11-09T09:00:00Z',
  'unreadCount': unread,
  'lastReadSequence': 0,
  'muted': false,
  'mutedUntil': null,
  'hidden': false,
  'myUserId': 'a',
  'participants': [
    {'userId': 'a', 'name': 'A', 'side': 'PATIENT', 'lastReadSequence': 0, 'lastDeliveredSequence': 0, 'active': true, 'online': true},
    {'userId': 'b', 'name': 'B', 'side': 'STAFF', 'lastReadSequence': 0, 'lastDeliveredSequence': 0, 'active': true, 'online': false},
  ],
};

Map<String, dynamic> pageJson(List<Map<String, dynamic>> items, {int page = 0, bool hasNext = false}) => {
  'items': items,
  'page': page,
  'pageSize': 20,
  'totalItems': items.length,
  'totalPages': hasNext ? 2 : 1,
  'hasNext': hasNext,
};

Map<String, dynamic> messageJson(int sequence, {String conversationId = 'c1', String sender = 'b', String? clientKey}) => {
  'id': 'm$sequence',
  'conversationId': conversationId,
  'sequence': sequence,
  'senderId': sender,
  'text': 'hello $sequence',
  'replyTo': null,
  'edited': false,
  'editedAt': null,
  'deleted': false,
  'createdAt': '2026-11-09T09:00:00Z',
  'clientKey': clientKey ?? 'k$sequence',
  'reactions': <dynamic>[],
  'attachments': <dynamic>[],
};

Map<String, dynamic> messagesJson(List<Map<String, dynamic>> items, {bool hasMore = false, int? nextBefore}) => {
  'items': items,
  'hasMore': hasMore,
  'nextBefore': nextBefore,
};

/// Runs [check] until it stops failing, for work that finishes on the event loop; times out after a few seconds.
Future<void> eventually(void Function() check) async {
  final deadline = DateTime.now().add(const Duration(seconds: 3));
  while (true) {
    try {
      return check();
    } on TestFailure {
      if (DateTime.now().isAfter(deadline)) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }
}
