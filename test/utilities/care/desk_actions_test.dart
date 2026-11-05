import 'package:care_track_client_mobile/models/care/appointment.dart';
import 'package:care_track_client_mobile/utilities/care/desk_actions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../models/care/appointment_test.dart';

/// A 09:00–09:30 UTC visit in the given status.
Appointment visit(String status) => Appointment.fromJson(appointmentJson(status));

DateTime at(int hour, int minute) => DateTime.utc(2026, 11, 4, hour, minute);

void main() {
  test('check-in opens 30 minutes before the start and closes at the end', () {
    expect(deskActionsFor(visit('SCHEDULED'), at(8, 29)).checkIn, isFalse);
    expect(deskActionsFor(visit('SCHEDULED'), at(8, 30)).checkIn, isTrue);
    expect(deskActionsFor(visit('SCHEDULED'), at(9, 30)).checkIn, isTrue);
    expect(deskActionsFor(visit('SCHEDULED'), at(9, 31)).checkIn, isFalse);
  });

  test('a missed visit can be recorded 30 minutes after the end', () {
    expect(deskActionsFor(visit('SCHEDULED'), at(9, 59)).noShow, isFalse);
    expect(deskActionsFor(visit('SCHEDULED'), at(10, 0)).noShow, isTrue);
  });

  test('a checked-in visit can be closed as not seen 60 minutes after the end', () {
    expect(deskActionsFor(visit('CHECKED_IN'), at(10, 29)).notSeen, isFalse);
    final late = deskActionsFor(visit('CHECKED_IN'), at(10, 30));
    expect(late.notSeen, isTrue);
    expect(late.checkIn || late.noShow, isFalse);
  });

  test('a finished visit offers nothing', () {
    expect(deskActionsFor(visit('COMPLETED'), at(12, 0)).any, isFalse);
    expect(deskActionsFor(visit('NO_SHOW'), at(12, 0)).any, isFalse);
  });
}
