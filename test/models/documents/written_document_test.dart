import 'package:care_track_client_mobile/models/documents/written_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a WrittenDocumentDto; lists carry no body', () {
    final json = {
      'id': 'd1',
      'title': 'Medical report',
      'kind': 'MEDICAL_REPORT',
      'appointmentId': 'a1',
      'hospitalId': 'h1',
      'hospitalName': 'Main Hospital',
      'authorId': 'u1',
      'authorName': 'Dr Sara',
      'issuedAt': '2026-11-05T09:30:00Z',
      'body': null,
    };
    final document = WrittenDocument.fromJson(json);
    expect(document.body, isNull);
    expect(document.issuedAt.isUtc, isFalse);
    expect(WrittenDocument.fromJson({...json, 'body': '<p>Hi</p>'}).body, '<p>Hi</p>');
    expect(document.restFrom, isNull);
  });

  test('parses the rest days of a sick note', () {
    final note = WrittenDocument.fromJson({
      'id': 'n1',
      'title': 'Sick note',
      'kind': 'SICK_LEAVE',
      'appointmentId': 'a1',
      'hospitalId': 'h1',
      'hospitalName': 'Main Hospital',
      'authorName': 'Dr Sara',
      'issuedAt': '2026-11-05T09:30:00Z',
      'body': null,
      'restFrom': '2026-11-06',
      'restTo': '2026-11-08',
    });
    expect(note.restFrom, DateTime(2026, 11, 6));
    expect(note.restTo, DateTime(2026, 11, 8));
  });
}
