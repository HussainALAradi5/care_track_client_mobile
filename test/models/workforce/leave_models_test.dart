import 'package:care_track_client_mobile/dtos/workforce/create_leave_request.dart';
import 'package:care_track_client_mobile/dtos/workforce/decision_request.dart';
import 'package:care_track_client_mobile/enums/workforce/leave_status.dart';
import 'package:care_track_client_mobile/models/workforce/leave_request.dart';
import 'package:care_track_client_mobile/models/workforce/my_leave.dart';
import 'package:care_track_client_mobile/utilities/workforce/leave.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> leaveRequestJson({Map<String, Object?> sickNote = const {}}) => {
  'id': 'l1',
  'code': 'LV-1',
  'userId': 'u1',
  'userName': 'Sam',
  'leaveTypeId': 't1',
  'leaveTypeName': 'Annual',
  'paid': true,
  'startDate': '2026-11-10',
  'endDate': '2026-11-12',
  'days': 3,
  'reason': 'Rest',
  'status': 'REQUESTED',
  'requestedAt': '2026-11-01T09:00:00Z',
  'decidedByName': null,
  'decidedAt': null,
  'decisionNote': null,
  'version': 4,
  'canDecide': true,
  'canCancel': false,
  'sickNote': sickNote.isEmpty ? null : sickNote,
};

void main() {
  test('parses LeaveRequestDto with and without a sick note', () {
    final plain = LeaveRequest.fromJson(leaveRequestJson());
    expect(plain.status, LeaveStatus.requested);
    expect(plain.version, 4);
    expect(plain.sickNote, isNull);
    expect(plain.startDate, DateTime(2026, 11, 10));

    final withNote = LeaveRequest.fromJson(
      leaveRequestJson(
        sickNote: {
          'id': 'n1',
          'code': 'SN-1',
          'hospitalName': 'H',
          'doctorName': 'Dr',
          'issuedAt': '2026-11-01T09:00:00Z',
          'restFrom': '2026-11-10',
          'restTo': '2026-11-12',
        },
      ),
    );
    expect(withNote.sickNote!.doctorName, 'Dr');
  });

  test('parses MyLeaveDto; a null allowance means no limit', () {
    final mine = MyLeave.fromJson({
      'year': 2026,
      'employed': true,
      'balances': [
        {'leaveTypeId': 't1', 'name': 'Annual', 'paid': true, 'allowed': 21, 'taken': 3, 'waiting': 2, 'left': 16},
        {'leaveTypeId': 't2', 'name': 'Unpaid', 'paid': false, 'allowed': null, 'taken': 0, 'waiting': 0, 'left': null},
      ],
      'requests': [leaveRequestJson()],
    });
    expect(mine.balances.first.left, 16);
    expect(mine.balances.last.allowed, isNull);
    expect(mine.requests.single.id, 'l1');
  });

  test('sends the request and decision field names', () {
    expect(
      CreateLeaveRequest(
        leaveTypeId: 't1',
        startDate: DateTime(2026, 11, 10),
        endDate: DateTime(2026, 11, 12),
      ).toJson(),
      {'leaveTypeId': 't1', 'startDate': '2026-11-10', 'endDate': '2026-11-12', 'reason': null, 'sickNoteId': null},
    );
    expect(const DecisionRequest(approve: false, expectedVersion: 4, note: 'x').toJson(), {
      'approve': false,
      'note': 'x',
      'expectedVersion': 4,
    });
  });

  test('counts calendar days and used allowance', () {
    expect(leaveDays(DateTime(2026, 11, 10), DateTime(2026, 11, 10)), 1);
    expect(leaveDays(DateTime(2026, 3, 28), DateTime(2026, 3, 31)), 4);
    expect(leaveDays(DateTime(2026, 11, 12), DateTime(2026, 11, 10)), 0);
    expect(usedFraction(null, 1, 1), isNull);
    expect(usedFraction(10, 3, 2), 0.5);
  });
}
