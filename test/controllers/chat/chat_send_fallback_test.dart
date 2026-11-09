import 'package:care_track_client_mobile/constants/realtime.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_thread_controller.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

const key = 'Idempotency-Key';

Future<(ProviderContainer, FakeServer, RecordingChannel)> thread(Respond respond, {required bool up}) async {
  final channel = RecordingChannel(up: up);
  final h = await chatHarness(respond, liveChannel: channel);
  addTearDown(h.container.dispose);
  h.container.listen(chatThreadProvider('c1'), (_, _) {});
  return (h.container, h.server, channel);
}

Object? server(RequestOptions r) {
  if (r.method == 'POST' && r.path.endsWith('/messages')) return messageJson(9, clientKey: r.headers[key] as String);
  if (r.path.endsWith('/messages')) return messagesJson(const []);
  if (r.path.endsWith('/chat/conversations')) return pageJson([conversationJson('c1')]);
  return <String, dynamic>{};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a send goes out live when the channel is up, with its client key and no REST call', () async {
    final (c, s, channel) = await thread(server, up: true);
    await c.read(chatThreadProvider('c1').notifier).send('hi');
    final frame = channel.published[Realtime.chatSend]!;
    expect(frame['conversationId'], 'c1');
    expect(frame['text'], 'hi');
    expect(frame['clientKey'], isNotEmpty);
    expect(s.requests.where((r) => r.method == 'POST'), isEmpty);
  });

  test('with the channel down it goes over REST with an Idempotency-Key', () async {
    final (c, s, _) = await thread(server, up: false);
    await c.read(chatThreadProvider('c1').notifier).send('hi');
    final post = s.requests.firstWhere((r) => r.method == 'POST');
    expect(post.headers[key], isNotEmpty);
    expect(post.data, {'text': 'hi', 'replyToId': null, 'attachmentIds': const <String>[]});
  });

  test('a failed REST send is retried with the same key', () async {
    var fail = true;
    final (c, s, _) = await thread((r) {
      if (r.method == 'POST' && r.path.endsWith('/messages') && fail) {
        throw DioException(requestOptions: r, type: DioExceptionType.connectionError);
      }
      return server(r);
    }, up: false);
    final notifier = c.read(chatThreadProvider('c1').notifier);
    await notifier.send('hi');
    expect(c.read(chatThreadProvider('c1')).outgoing.single.failed, isTrue);
    fail = false;
    await notifier.retry(c.read(chatThreadProvider('c1')).outgoing.single);
    final keys = s.requests.where((r) => r.method == 'POST').map((r) => r.headers[key]).toList();
    expect(keys, hasLength(2));
    expect(keys.first, keys.last);
  });

  test('a live send with no echo falls back to REST with the same key', () async {
    final (c, s, channel) = await thread(server, up: true);
    await c.read(chatThreadProvider('c1').notifier).send('hi');
    final clientKey = channel.published[Realtime.chatSend]!['clientKey'];
    await Future<void>.delayed(const Duration(seconds: 5));
    final post = s.requests.firstWhere((r) => r.method == 'POST');
    expect(post.headers[key], clientKey);
  }, timeout: const Timeout(Duration(seconds: 15)));
}
