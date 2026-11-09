import 'package:care_track_client_mobile/enums/workforce/payroll_run_status.dart';
import 'package:care_track_client_mobile/models/workforce/department_tree.dart';
import 'package:care_track_client_mobile/models/workforce/payslip.dart';
import 'package:care_track_client_mobile/models/workforce/team_member.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> payslipJson({List<Map<String, dynamic>>? lines}) => {
  'id': 'p1',
  'runId': 'r1',
  'userId': 'u1',
  'userName': 'Sam',
  'hospitalName': 'Dev Hospital',
  'year': 2026,
  'month': 10,
  'status': 'PAID',
  'basic': 1000.5,
  'allowances': 200,
  'deductions': -50,
  'adjustments': 0,
  'net': 1150.5,
  'dayRate': 33.35,
  'unpaidLeaveDays': 1,
  'absentDays': 0,
  'lines': lines ?? const [],
};

void main() {
  test('parses PayslipDto with its lines', () {
    final p = Payslip.fromJson(
      payslipJson(
        lines: [
          {'id': 'l1', 'kind': 'UNPAID_LEAVE', 'label': 'Unpaid leave', 'amount': -33.35, 'days': 1},
          {'id': 'l2', 'kind': 'BASIC', 'label': 'Basic', 'amount': 1000.5, 'days': null},
        ],
      ),
    );
    expect(p.status, PayrollRunStatus.paid);
    expect(p.net, 1150.5);
    expect(p.lines.first.days, 1);
    expect(p.lines.last.days, isNull);
  });

  test('parses TeamMemberDto with nested reports', () {
    final m = TeamMember.fromJson({
      'userId': 'u1',
      'name': 'Lead',
      'userType': 'DOCTOR',
      'positionName': 'Consultant',
      'departmentName': 'ICU',
      'hospitalName': 'H',
      'reports': [
        {'userId': 'u2', 'name': 'Junior', 'userType': null, 'positionName': null, 'departmentName': null, 'hospitalName': null, 'reports': const []},
      ],
    });
    expect(m.reports.single.name, 'Junior');
  });

  test('parses DepartmentTreeDto with members and children', () {
    final d = DepartmentTree.fromJson({
      'id': 'd1',
      'code': 'ICU',
      'name': 'ICU',
      'hospitalName': 'H',
      'members': [
        {'userId': 'u1', 'name': 'Me', 'userType': 'NURSE', 'positionName': 'Nurse', 'primary': true, 'me': true},
      ],
      'children': [
        {'id': 'd2', 'code': 'A', 'name': 'Sub', 'hospitalName': null, 'members': const [], 'children': const []},
      ],
    });
    expect(d.members.single.me, isTrue);
    expect(d.children.single.name, 'Sub');
  });
}
