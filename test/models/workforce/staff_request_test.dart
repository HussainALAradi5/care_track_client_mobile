import 'package:care_track_client_mobile/enums/workforce/staff_request_status.dart';
import 'package:care_track_client_mobile/enums/workforce/staff_request_type.dart';
import 'package:care_track_client_mobile/models/workforce/staff_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a staff request from the server', () {
    final request = StaffRequest.fromJson({
      'id': 'r1',
      'code': 'SR-1',
      'userId': 'u1',
      'userName': 'Development Nurse',
      'type': 'SALARY_CERTIFICATE',
      'details': 'For the bank',
      'status': 'REJECTED',
      'requestedAt': '2026-11-05T09:00:00Z',
      'decidedByName': 'Development HR',
      'decidedAt': '2026-11-05T10:00:00Z',
      'decisionNote': 'Salary changes next month',
      'version': 1,
      'canDecide': false,
      'canCancel': false,
    });

    expect(request.type, StaffRequestType.salaryCertificate);
    expect(request.status, StaffRequestStatus.rejected);
    expect(request.requestedAt, DateTime.utc(2026, 11, 5, 9));
    expect(request.decidedByName, 'Development HR');
    expect(request.decisionNote, 'Salary changes next month');
    expect(request.version, 1);
    expect(request.canCancel, isFalse);
  });

  test('a waiting request has no decider or note', () {
    final request = StaffRequest.fromJson({
      'id': 'r2',
      'code': 'SR-2',
      'type': 'GENERAL',
      'details': 'New ID card',
      'status': 'REQUESTED',
      'requestedAt': '2026-11-05T09:00:00Z',
      'decidedByName': null,
      'decisionNote': null,
      'version': 0,
      'canCancel': true,
    });

    expect(request.type, StaffRequestType.general);
    expect(request.decidedByName, isNull);
    expect(request.canCancel, isTrue);
  });
}
