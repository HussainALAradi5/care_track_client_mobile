import 'package:care_track_client_mobile/controllers/chat/chat_live_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_thread_controller.dart';
import 'package:care_track_client_mobile/controllers/ui/app_foreground_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

class Backgrounded extends AppForegroundController {
  @override
  bool build() => false;

  void resume() => state = true;
}

Object? responses(RequestOptions r) {
  if (r.path.endsWith('/messages')) return messagesJson([messageJson(1)]);
  if (r.path.endsWith('/read')) return {'userId': 'a', 'readSequence': 1, 'deliveredSequence': 1};
  return pageJson([conversationJson('c1')]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a backgrounded thread sends no read receipt, then catches up on resume', () async {
    final h = await chatHarness(responses, overrides: [appForegroundProvider.overrideWith(Backgrounded.new)]);
    addTearDown(h.container.dispose);
    final c = h.container;
    final thread = chatThreadProvider('c1');
    c.listen(thread, (_, _) {});
    bool sentRead() => h.server.requests.any((r) => r.path.endsWith('/read'));

    await eventually(() => expect(c.read(thread).messages, isNotEmpty));
    expect(sentRead(), isFalse);

    (c.read(appForegroundProvider.notifier) as Backgrounded).resume();

    await eventually(() => expect(sentRead(), isTrue));
  });

  test('a reconnect reads the open thread again without clearing it', () async {
    var messages = [messageJson(1)];
    Object? respond(RequestOptions r) => r.path.endsWith('/messages') ? messagesJson(messages) : pageJson([conversationJson('c1')]);
    final h = await chatHarness(respond);
    addTearDown(h.container.dispose);
    final c = h.container;
    c.listen(chatLiveProvider, (_, _) {});
    final thread = chatThreadProvider('c1');
    c.listen(thread, (_, _) {});
    await eventually(() => expect(c.read(thread).messages.map((m) => m.id), ['m1']));

    messages = [messageJson(1), messageJson(2)];
    h.channel.openedController.add(null);

    await eventually(() => expect(c.read(thread).messages.map((m) => m.id), ['m1', 'm2']));
    expect(c.read(thread).loading, isFalse);
  });
}
