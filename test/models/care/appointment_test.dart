import 'package:care_track_client_mobile/enums/care/appointment_status.dart';
import 'package:care_track_client_mobile/models/care/appointment.dart';
import 'package:care_track_client_mobile/utilities/care/journey.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> appointmentJson(String status) => {
  'id': 'a1',
  'code': 'APT-1',
  'bookingId': 'b1',
  'hospitalId': 'h1',
  'patientId': 'p1',
  'clinicianId': 'c1',
  'startsAt': '2026-11-04T09:00:00Z',
  'endsAt': '2026-11-04T09:30:00Z',
  'cancellationDeadlineAt': '2026-11-03T09:00:00Z',
  'status': status,
  'version': 2,
  'checkedInAt': null,
  'noShowAt': null,
  'noShowReason': null,
  'createdAt': '2026-11-01T10:00:00Z',
};

void main() {
  test('parses the server AppointmentDto', () {
    final a = Appointment.fromJson(appointmentJson('SCHEDULED'));
    expect(a.status, AppointmentStatus.scheduled);
    expect(a.scheduled, isTrue);
    expect(a.version, 2);
    expect(a.startsAt.toUtc(), DateTime.utc(2026, 11, 4, 9));
    expect(a.patientName, isEmpty);
  });

  test('staff lists carry the patient and clinician names', () {
    final a = Appointment.fromJson({
      ...appointmentJson('SCHEDULED'),
      'patientName': 'Development Patient',
      'clinicianName': 'Development Doctor',
    });
    expect(a.patientName, 'Development Patient');
    expect(a.clinicianName, 'Development Doctor');
  });

  test('journey ends at cancellation or completion', () {
    final cancelled = appointmentJourney(Appointment.fromJson(appointmentJson('CANCELLED')));
    expect(cancelled.length, 3);
    final completed = appointmentJourney(Appointment.fromJson(appointmentJson('COMPLETED')));
    expect(completed.every((e) => e.done), isTrue);
    final scheduled = appointmentJourney(Appointment.fromJson(appointmentJson('SCHEDULED')));
    expect(scheduled.where((e) => e.done).length, 2);
  });

  test('parses NOT_SEEN and ends the journey with its reason', () {
    final json = appointmentJson('NOT_SEEN')
      ..['notSeenAt'] = '2026-11-04T10:31:00Z'
      ..['notSeenReason'] = 'Clinic closed early';
    final a = Appointment.fromJson(json);
    expect(a.status, AppointmentStatus.notSeen);
    final journey = appointmentJourney(a);
    expect(journey.last.detail, 'Clinic closed early');
    expect(journey.every((e) => e.done), isTrue);
  });
}
