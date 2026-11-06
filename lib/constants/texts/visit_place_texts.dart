import '../../enums/care/appointment_status.dart';
import '../../enums/identity/user_type.dart';

/// Words of where a visit happens and how a clinician is addressed.
abstract final class VisitPlaceTexts {
  static String plannedRoom(String room) => '$room (planned)';
  static const roomToBeSet = 'Room to be set';

  /// Visits still to happen or under way: only these say "Room to be set" when no room is known.
  static const openVisitStatuses = {AppointmentStatus.scheduled, AppointmentStatus.checkedIn, AppointmentStatus.inProgress};

  /// Title before a clinician's name; other account types show the name alone.
  static const clinicianTitles = {UserType.doctor: 'Dr.', UserType.nurse: 'Nurse'};
}
