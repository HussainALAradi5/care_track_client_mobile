import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/constants/realtime.dart';
import 'package:care_track_client_mobile/enums/chat/thread_menu_action.dart';
import 'package:care_track_client_mobile/models/files/picked_attachment.dart';
import 'package:care_track_client_mobile/screens/chat/chat_list_screen.dart';
import 'package:care_track_client_mobile/screens/chat/chat_thread_screen.dart';
import 'package:care_track_client_mobile/screens/chat/new_conversation_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/chat_harness.dart';
import '../support/chat_widgets.dart';

Object? chat(RequestOptions r, {List<Map<String, dynamic>>? messages}) {
  if (r.path == '/chat/conversations' && r.method == 'GET') return pageJson([conversationJson('c1')]);
  if (r.path == '/chat/conversations/c1/messages' && r.method == 'GET') {
    return messagesJson(messages ?? [messageJson(1, sender: 'a'), messageJson(2)]);
  }
  if (r.path.endsWith('/read') || r.path.endsWith('/delivered')) return {'unreadCount': 0};
  return <String, dynamic>{};
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('the contact picker offers patient support only to a patient at that hospital', (tester) async {
    final s = await pumpChat(tester, const NewConversationScreen(), (r) {
      if (r.path == '/chat/hospitals') {
        return [
          {'hospitalId': 'h1', 'name': 'Where I work', 'staff': true, 'patient': false},
          {'hospitalId': 'h2', 'name': 'Where I am cared for', 'staff': false, 'patient': true},
        ];
      }
      return chat(r);
    });
    await tester.tap(find.text('Hospital'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Where I work').last);
    await tester.pumpAndSettle();
    expect(find.text('Message patient support'), findsNothing);
    await tester.tap(find.text('Where I work').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Where I am cared for').last);
    await tester.pumpAndSettle();
    expect(find.text('Message patient support'), findsOneWidget);
    expect(s.server.requests.where((r) => r.method == 'POST'), isEmpty);
  });

  testWidgets('starting with a contact posts its kind and opens the thread', (tester) async {
    final s = await pumpChat(tester, const NewConversationScreen(), (r) {
      if (r.path == '/chat/hospitals') {
        return [
          {'hospitalId': 'h1', 'name': 'Dev Hospital', 'staff': true, 'patient': false},
        ];
      }
      if (r.path == '/chat/hospitals/h1/contacts') {
        return pageJson([
          {'userId': 'u9', 'name': 'Sara Staff', 'kind': 'STAFF'},
        ]);
      }
      if (r.path == '/chat/conversations' && r.method == 'POST') return conversationJson('c1');
      return chat(r);
    });
    await tester.tap(find.text('Hospital'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dev Hospital').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search people').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sara Staff'));
    await tester.pumpAndSettle();
    final start = s.server.requests.firstWhere((r) => r.method == 'POST' && r.path == '/chat/conversations');
    expect(start.data, {'hospitalId': 'h1', 'kind': 'STAFF', 'targetUserId': 'u9'});
  });

  testWidgets('a refused start says why', (tester) async {
    await pumpChat(tester, const NewConversationScreen(), (r) {
      if (r.path == '/chat/hospitals') {
        return [
          {'hospitalId': 'h1', 'name': 'Dev Hospital', 'staff': false, 'patient': true},
        ];
      }
      if (r.path == '/chat/conversations' && r.method == 'POST') {
        throw DioException(
          requestOptions: r,
          response: Response(requestOptions: r, statusCode: 403, data: {'code': 'CHAT_NOT_AT_HOSPITAL', 'message': ''}),
        );
      }
      return chat(r);
    });
    await tester.tap(find.text('Hospital'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dev Hospital').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Message patient support'));
    await tester.pumpAndSettle();
    expect(find.text('You are not part of this hospital.'), findsOneWidget);
  });

  testWidgets('deletes my message over REST and shows the placeholder', (tester) async {
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) {
      if (r.method == 'DELETE') return {'messageId': 'm1', 'sequence': 1};
      return chat(r);
    });
    await tester.longPress(find.text('hello 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(s.server.requests.any((r) => r.method == 'DELETE' && r.path.endsWith('/messages/m1')), isTrue);
    expect(find.text('This message was deleted'), findsOneWidget);
  });

  testWidgets('only my own messages can be edited or deleted', (tester) async {
    await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), chat);
    await tester.longPress(find.text('hello 2'));
    await tester.pumpAndSettle();
    expect(find.text('Reply'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);
  });

  testWidgets('edits through the composer and shows earlier versions', (tester) async {
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) {
      if (r.method == 'PUT') {
        return {...messageJson(1, sender: 'a'), 'text': 'changed', 'edited': true};
      }
      if (r.path.endsWith('/history')) {
        return [
          {'previousText': 'hello 1', 'editedAt': '2026-11-09T09:00:00Z'},
        ];
      }
      return chat(r);
    });
    await tester.longPress(find.text('hello 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'changed');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(s.server.requests.firstWhere((r) => r.method == 'PUT').data, {'text': 'changed'});
    expect(find.text('changed'), findsOneWidget);
    await tester.tap(find.text('edited'));
    await tester.pumpAndSettle();
    expect(find.text('Earlier versions'), findsOneWidget);
    expect(find.textContaining('hello 1'), findsOneWidget);
  });

  testWidgets('adds a reaction, and a live reaction frame updates the chips', (tester) async {
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) {
      if (r.method == 'PUT' && r.path.endsWith('/reaction')) {
        return {
          'messageId': 'm2',
          'reactions': [
            {'userId': 'a', 'emoji': '\u{1F44D}'},
          ],
        };
      }
      return chat(r);
    });
    await tester.longPress(find.text('hello 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u{1F44D}'));
    await tester.pumpAndSettle();
    expect(s.server.requests.firstWhere((r) => r.method == 'PUT').data, {'emoji': '\u{1F44D}'});
    expect(find.text('\u{1F44D} 1'), findsOneWidget);

    s.channel.controllers[Realtime.chatQueue]!.add({
      'type': 'REACTION',
      'conversationId': 'c1',
      'data': {
        'messageId': 'm2',
        'reactions': [
          {'userId': 'a', 'emoji': '\u{1F44D}'},
          {'userId': 'b', 'emoji': '\u{1F44D}'},
        ],
      },
    });
    await tester.pump();
    await tester.pump();
    expect(find.text('\u{1F44D} 2'), findsOneWidget);
  });

  testWidgets('a typing frame shows who is typing and goes away on its own', (tester) async {
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), chat);
    s.channel.controllers[Realtime.chatQueue]!.add({
      'type': 'TYPING',
      'conversationId': 'c1',
      'data': {'userId': 'b', 'typing': true},
    });
    await tester.pump();
    await tester.pump();
    expect(find.text('B is typing'), findsOneWidget);
    await tester.pump(const Duration(seconds: 7));
    expect(find.text('B is typing'), findsNothing);
  });

  testWidgets('writing tells the others over REST when the channel is down, at most once per window', (tester) async {
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), chat);
    await tester.enterText(find.byType(TextField), 'h');
    await tester.enterText(find.byType(TextField), 'he');
    await tester.pump();
    final typing = s.server.requests.where((r) => r.path.endsWith('/typing')).toList();
    expect(typing, hasLength(1));
    expect(typing.first.data, {'typing': true});
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('a presence frame with no conversation lights the dot in the list', (tester) async {
    final s = await pumpChat(tester, const ChatListScreen(), chat);
    expect(find.byType(ChatListScreen), findsOneWidget);
    s.channel.controllers[Realtime.chatQueue]!.add({
      'type': 'PRESENCE',
      'conversationId': null,
      'data': {'userId': 'b', 'online': true},
    });
    await tester.pump();
    expect(find.byType(ChatListScreen), findsOneWidget);
  });

  testWidgets('an unscanned attachment says it is awaiting the file check and cannot be opened', (tester) async {
    await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) => chat(r, messages: [
      {
        ...messageJson(1, sender: 'b'),
        'attachments': [
          {'assetId': 'x1', 'contentType': 'application/pdf', 'sizeBytes': 10, 'status': 'QUARANTINED'},
        ],
      },
    ]));
    expect(find.text('Awaiting file check'), findsOneWidget);
    final button = tester.widget<TextButton>(find.ancestor(of: find.text('Awaiting file check'), matching: find.byType(TextButton)));
    expect(button.onPressed, isNull);
  });

  testWidgets('downloading a file saves it, and a 409 explains the file check', (tester) async {
    final files = FakeFiles();
    var unavailable = false;
    await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) {
      if (r.path.endsWith('/download')) {
        if (unavailable) {
          throw DioException(
            requestOptions: r,
            response: Response(requestOptions: r, statusCode: 409, data: {'code': 'MEDIA_UNAVAILABLE', 'message': ''}),
          );
        }
        return Uint8List.fromList(utf8.encode('file'));
      }
      return chat(r, messages: [
        {
          ...messageJson(1, sender: 'b'),
          'attachments': [
            {'assetId': 'x1', 'contentType': 'application/pdf', 'sizeBytes': 10, 'status': 'AVAILABLE'},
          ],
        },
      ]);
    }, files: files);
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();
    expect(files.saved.keys, ['x1.pdf']);

    unavailable = true;
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();
    expect(find.text('This file is awaiting its file check, so it cannot be downloaded yet.'), findsOneWidget);
  });

  testWidgets('uploads a picked file and sends its id with the message', (tester) async {
    final s = await pumpChat(
      tester,
      const ChatThreadScreen(conversationId: 'c1'),
      (r) {
        if (r.path.endsWith('/attachments')) {
          return {'assetId': 'x1', 'contentType': 'application/pdf', 'sizeBytes': 4, 'status': 'QUARANTINED'};
        }
        if (r.method == 'POST' && r.path.endsWith('/messages')) {
          return {...messageJson(3, sender: 'a', clientKey: r.headers['Idempotency-Key'] as String)};
        }
        return chat(r);
      },
      files: FakeFiles(picked: const [PickedAttachment(name: 'note.pdf', bytes: [1, 2, 3, 4])]),
    );
    await tester.tap(find.byTooltip('Attach a file'));
    await tester.pumpAndSettle();
    expect(find.text('note.pdf'), findsOneWidget);
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    final post = s.server.requests.firstWhere((r) => r.method == 'POST' && r.path.endsWith('/messages'));
    expect(post.data, {'text': null, 'replyToId': null, 'attachmentIds': ['x1']});
    expect(find.text('note.pdf'), findsNothing);
  });

  testWidgets('a failed upload says so and nothing can be sent with it', (tester) async {
    await pumpChat(
      tester,
      const ChatThreadScreen(conversationId: 'c1'),
      (r) {
        if (r.path.endsWith('/attachments')) {
          throw DioException(requestOptions: r, type: DioExceptionType.connectionError);
        }
        return chat(r);
      },
      files: FakeFiles(picked: const [PickedAttachment(name: 'bad.pdf', bytes: [1])]),
    );
    await tester.tap(find.byTooltip('Attach a file'));
    await tester.pumpAndSettle();
    expect(find.text('Could not upload this file'), findsOneWidget);
  });

  testWidgets('mutes and hides from the thread menu', (tester) async {
    var muted = false;
    final s = await pumpChat(tester, const ChatThreadScreen(conversationId: 'c1'), (r) {
      if (r.method == 'PUT' && r.path.endsWith('/mute')) {
        muted = true;
        return {...conversationJson('c1'), 'muted': true};
      }
      if (r.method == 'PUT' && r.path.endsWith('/hide')) return {...conversationJson('c1'), 'hidden': true};
      return chat(r);
    });
    await tester.tap(find.byType(PopupMenuButton<ThreadMenuAction>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mute'));
    await tester.pumpAndSettle();
    expect(muted, isTrue);
    expect(s.server.requests.firstWhere((r) => r.path.endsWith('/mute')).data, {'muted': true, 'until': null});
    await tester.tap(find.byType(PopupMenuButton<ThreadMenuAction>));
    await tester.pumpAndSettle();
    expect(find.text('Unmute'), findsOneWidget);
    await tester.tap(find.text('Hide conversation'));
    await tester.pumpAndSettle();
    expect(s.server.requests.firstWhere((r) => r.path.endsWith('/hide')).data, {'hidden': true});
  });
}
