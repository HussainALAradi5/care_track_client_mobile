import 'package:care_track_client_mobile/enums/chat/chat_attachment_status.dart';
import 'package:care_track_client_mobile/enums/chat/conversation_kind.dart';
import 'package:care_track_client_mobile/models/chat/chat_contact.dart';
import 'package:care_track_client_mobile/models/chat/chat_hospital.dart';
import 'package:care_track_client_mobile/models/chat/chat_message.dart';
import 'package:care_track_client_mobile/models/chat/chat_reaction.dart';
import 'package:care_track_client_mobile/models/chat/message_edit.dart';
import 'package:care_track_client_mobile/utilities/chat/attachment_files.dart';
import 'package:care_track_client_mobile/utilities/chat/reactions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_harness.dart';

void main() {
  test('parses MessageDto reactions and attachments', () {
    final m = ChatMessage.fromJson({
      ...messageJson(5),
      'reactions': [
        {'userId': 'a', 'emoji': '\u{1F44D}'},
      ],
      'attachments': [
        {'assetId': 'x1', 'contentType': 'application/pdf', 'sizeBytes': 2048, 'status': 'QUARANTINED'},
      ],
    });
    expect(m.reactions.single.emoji, '\u{1F44D}');
    expect(m.attachments.single.status, ChatAttachmentStatus.quarantined);
    expect(m.attachmentCount, 1);
  });

  test('every attachment status on the wire is known', () {
    for (final wire in ['QUARANTINED', 'AVAILABLE', 'REJECTED', 'REVOKED']) {
      expect(ChatAttachmentStatus.fromWire(wire).wire, wire);
    }
  });

  test('parses MessageEditDto, ChatHospitalDto and ChatContactDto', () {
    final edit = MessageEdit.fromJson({'previousText': 'old', 'editedAt': '2026-11-09T09:00:00Z'});
    expect(edit.previousText, 'old');
    final hospital = ChatHospital.fromJson({'hospitalId': 'h1', 'name': 'H', 'staff': true, 'patient': false});
    expect(hospital.staff, isTrue);
    final contact = ChatContact.fromJson({'userId': 'u1', 'name': 'Sam', 'kind': 'STAFF'});
    expect(contact.kind, ConversationKind.staff);
  });

  test('groups reactions by emoji and marks the viewer\'s', () {
    final groups = groupReactions(const [
      ChatReaction(userId: 'a', emoji: 'x'),
      ChatReaction(userId: 'b', emoji: 'x'),
      ChatReaction(userId: 'b', emoji: 'y'),
    ], 'a');
    expect(groups.first.count, 2);
    expect(groups.first.mine, isTrue);
    expect(groups.last.mine, isFalse);
  });

  test('names files by content type', () {
    expect(contentTypeOfFile('Scan.JPG'), 'image/jpeg');
    expect(contentTypeOfFile('note.pdf'), 'application/pdf');
    expect(downloadName('abc', 'application/pdf'), 'abc.pdf');
    expect(downloadName('abc', 'text/plain'), 'abc');
  });
}
