import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/screens/staff/department_screen.dart';
import 'package:care_track_client_mobile/screens/staff/payslip_detail_screen.dart';
import 'package:care_track_client_mobile/screens/staff/payslips_screen.dart';
import 'package:care_track_client_mobile/screens/staff/team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/workforce/payslip_team_models_test.dart' show payslipJson;
import '../support/api_harness.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final me = [signedInUserIdProvider.overrideWithValue('u1')];

  testWidgets('lists payslips with their net pay', (tester) async {
    final server = await pumpScreen(tester, const PayslipsScreen(), (_) => pageOf([payslipJson()]), overrides: me);
    expect(server.requests.single.path, '/auth/me/payslips');
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('1,150.500'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);
  });

  testWidgets('a signed-out person loads no payslips', (tester) async {
    final server = await pumpScreen(
      tester,
      const PayslipsScreen(),
      (_) => pageOf(const []),
      overrides: [signedInUserIdProvider.overrideWithValue(null)],
    );
    expect(server.requests, isEmpty);
    expect(find.text('No payslips yet'), findsOneWidget);
  });

  testWidgets('a payslip shows its lines', (tester) async {
    await pumpScreen(
      tester,
      const PayslipDetailScreen(payslipId: 'p1'),
      (_) => payslipJson(
        lines: [
          {'id': 'l1', 'kind': 'ALLOWANCE', 'label': 'Housing', 'amount': 200, 'days': null},
        ],
      ),
      overrides: me,
    );
    expect(find.text('Housing'), findsOneWidget);
    expect(find.text('Net pay'), findsOneWidget);
  });

  testWidgets('a refused payslip shows the error with a retry', (tester) async {
    await pumpScreen(tester, const PayslipDetailScreen(payslipId: 'p1'), (_) => const Failure(403, 'FORBIDDEN'), overrides: me);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('My team and My department only need a sign-in, and are read-only', (tester) async {
    await pumpScreen(tester, const TeamScreen(), (_) => [
      {'userId': 'u2', 'name': 'Junior Nurse', 'userType': null, 'positionName': 'Nurse', 'departmentName': null, 'hospitalName': null, 'reports': const []},
    ], overrides: me);
    expect(find.text('Junior Nurse'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    await pumpScreen(tester, const DepartmentScreen(), (_) => [
      {
        'id': 'd1',
        'code': 'ICU',
        'name': 'ICU',
        'hospitalName': 'Dev Hospital',
        'members': [
          {'userId': 'u1', 'name': 'Me Myself', 'userType': 'NURSE', 'positionName': 'Nurse', 'primary': true, 'me': true},
        ],
        'children': const [],
      },
    ], overrides: me);
    expect(find.text('Me Myself'), findsOneWidget);
    expect(find.text('You · Main'), findsOneWidget);
  });
}
