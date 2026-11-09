import 'dart:async';

import 'package:care_track_client_mobile/controllers/chat/chat_thread_controller.dart';
import 'package:care_track_client_mobile/models/chat/chat_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

final thread = chatThreadProvider('c1');

Object? listAndMessages(RequestOptions r) {
  if (r.path.endsWith('/messages')) return messagesJson([messageJson(1)]);
  if (r.path.endsWith('/read')) return {'userId': 'a', 'readSequence': 1, 'deliveredSequence': 1};
  return pageJson([conversationJson('c1')]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a failed send survives leaving the thread', () async {
    final h = await chatHarness((r) {
      if (r.method == 'POST' && r.path.endsWith('/messages')) {
        throw DioException(requestOptions: r, type: DioExceptionType.connectionError);
      }
      return listAndMessages(r);
    });
    addTearDown(h.container.dispose);
    final c = h.container;
    final sub = c.listen(thread, (_, _) {});
    await eventually(() => expect(c.read(thread).messages, isNotEmpty));
    await c.read(thread.notifier).send('hello');
    expect(c.read(thread).outgoing.single.failed, isTrue);

    sub.close();
    await c.pump();

    expect(c.exists(thread), isTrue);
    expect(c.read(thread).outgoing.single.failed, isTrue);
  });

  test('a send in flight when the thread is left still settles, then the thread goes away', () async {
    final release = Completer<void>();
    final h = await chatHarness((r) async {
      if (r.method == 'POST' && r.path.endsWith('/messages')) {
        await release.future;
        return messageJson(2, sender: 'a', clientKey: r.headers['Idempotency-Key'] as String?);
      }
      return listAndMessages(r);
    });
    addTearDown(h.container.dispose);
    final c = h.container;
    final sub = c.listen(thread, (_, _) {});
    await eventually(() => expect(c.read(thread).messages, isNotEmpty));
    final sending = c.read(thread.notifier).send('hello');

    sub.close();
    await c.pump();
    expect(c.exists(thread), isTrue);

    release.complete();
    await sending;
    await c.pump();

    expect(c.exists(thread), isFalse);
  });

  test('a thread kept alive off screen sends no read receipts', () async {
    final release = Completer<void>();
    final h = await chatHarness((r) async {
      if (r.method == 'POST' && r.path.endsWith('/messages')) {
        await release.future;
        return messageJson(2, sender: 'a', clientKey: r.headers['Idempotency-Key'] as String?);
      }
      return listAndMessages(r);
    });
    addTearDown(h.container.dispose);
    final c = h.container;
    final sub = c.listen(thread, (_, _) {});
    await eventually(() => expect(c.read(thread).messages, isNotEmpty));
    final notifier = c.read(thread.notifier);
    final sending = notifier.send('hello');
    final readsBefore = h.server.requests.where((r) => r.path.endsWith('/read')).length;

    sub.close();
    await c.pump();
    expect(notifier.isOnScreen, isFalse);
    notifier.applyNew(ChatMessage.fromJson(messageJson(5)));
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(h.server.requests.where((r) => r.path.endsWith('/read')).length, readsBefore);
    release.complete();
    await sending;
  });
}
