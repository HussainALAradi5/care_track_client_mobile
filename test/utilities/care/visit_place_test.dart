import 'package:care_track_client_mobile/enums/care/appointment_room_source.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/models/care/appointment.dart';
import 'package:care_track_client_mobile/utilities/care/visit_place.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../models/care/appointment_test.dart';

Appointment visit(Map<String, dynamic> fields) => Appointment.fromJson({
  ...appointmentJson('SCHEDULED'),
  'hospitalName': 'Manama Hospital',
  'clinicianName': 'Sara Ali',
  'clinicianType': 'DOCTOR',
  ...fields,
});

void main() {
  test('reads where the visit happens from the server', () {
    final a = visit({'departmentName': 'General Medicine', 'roomName': 'Room 3', 'roomSource': 'SESSION'});
    expect(a.hospitalName, 'Manama Hospital');
    expect(a.clinicianType, UserType.doctor);
    expect(a.roomSource, AppointmentRoomSource.session);
  });

  test('lists hospital, department and room, marking a planned room', () {
    expect(
      visitPlaceBadges(visit({'departmentName': 'General Medicine', 'roomName': 'Room 3', 'roomSource': 'SESSION'}))
          .map((b) => b.label),
      ['Manama Hospital', 'General Medicine', 'Room 3'],
    );
    expect(visitPlaceBadges(visit({'roomName': 'Room 1', 'roomSource': 'PLANNED'})).last.label, 'Room 1 (planned)');
    expect(visitPlaceBadges(visit({})).map((b) => b.label), ['Manama Hospital', 'Room to be set']);
    expect(visitPlaceBadges(visit({'status': 'NO_SHOW'})).map((b) => b.label), ['Manama Hospital']);
  });

  test('gives doctors and nurses their title', () {
    expect(clinicianLabel(visit({})), 'Dr. Sara Ali');
    expect(clinicianLabel(visit({'clinicianType': 'NURSE', 'clinicianName': 'Omar'})), 'Nurse Omar');
    expect(clinicianLabel(visit({'clinicianType': 'EMPLOYEE', 'clinicianName': 'Huda'})), 'Huda');
  });
}
