import 'package:care_track_client_mobile/controllers/chat/chat_live_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_thread_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

void main() {
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
