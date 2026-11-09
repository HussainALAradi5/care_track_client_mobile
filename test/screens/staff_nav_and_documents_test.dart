import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/constants/staff_nav.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/models/documents/written_document.dart';
import 'package:care_track_client_mobile/models/identity/staff_hospital.dart';
import 'package:care_track_client_mobile/widgets/documents/sick_note_use.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/api_harness.dart';

WrittenDocument note() => WrittenDocument(
  id: 'n1',
  title: 'Sick note',
  kind: 'SICK_LEAVE',
  appointmentId: 'a1',
  hospitalId: 'h1',
  hospitalName: 'Dev',
  authorName: 'Dr',
  issuedAt: DateTime(2026, 11, 1),
  restFrom: DateTime(2026, 11, 1),
  restTo: DateTime(2026, 11, 3),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('HR screens need their permission; self-service is open to all staff', () {
    StaffHospital at(Set<String> permissions) => staffHospital(permissions);
    final plain = at(const {});
    final hr = at(const {PermissionCodes.leaveReadAll, PermissionCodes.staffRequestHandle});
    final open = {for (final i in StaffNav.items.where((i) => i.isOpenAt(plain))) i.label};
    expect(open, containsAll(['Leave', 'Attendance', 'Payslips', 'Team', 'Department', 'Requests']));
    expect(open, isNot(contains('Leave requests')));
    expect(open, isNot(contains('Staff requests')));
    final hrOpen = {for (final i in StaffNav.items.where((i) => i.isOpenAt(hr))) i.label};
    expect(hrOpen, containsAll(['Leave requests', 'Staff requests']));
  });

  testWidgets('Use for my leave is for people who work somewhere', (tester) async {
    await pumpScreen(
      tester,
      SickNoteUse(document: note()),
      (_) => pageOf(const []),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    expect(find.textContaining('Rest from'), findsOneWidget);
    expect(find.text('Use for my leave'), findsNothing);
  });

  testWidgets('staff can use a sick note for their leave', (tester) async {
    await pumpScreen(
      tester,
      SickNoteUse(document: note()),
      (_) => pageOf(const []),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(doctor))],
    );
    expect(find.text('Use for my leave'), findsOneWidget);
  });
}
