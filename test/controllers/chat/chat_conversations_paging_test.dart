import 'package:care_track_client_mobile/controllers/chat/chat_conversations_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

Object? pages(RequestOptions r) {
  final page = r.queryParameters['page'] as int? ?? 0;
  return page == 0
      ? pageJson([conversationJson('c1')], hasNext: true)
      : pageJson([conversationJson('c1'), conversationJson('c2')], page: 1);
}

void main() {
  test('pages in further conversations and drops a row a live bump shifted onto the next page', () async {
    final h = await chatHarness(pages);
    addTearDown(h.container.dispose);
    final c = h.container;
    var paged = await c.read(chatConversationsProvider.future);
    expect(paged.items.map((c) => c.id), ['c1']);
    expect(paged.hasNext, isTrue);

    await c.read(chatConversationsProvider.notifier).loadMore();

    paged = c.read(chatConversationsProvider).value!;
    expect(paged.items.map((c) => c.id), ['c1', 'c2']);
    expect(paged.hasNext, isFalse);
  });
}
