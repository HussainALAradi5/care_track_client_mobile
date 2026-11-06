import '../../enums/identity/user_type.dart';

/// Words of where a visit happens and how a clinician is addressed.
abstract final class VisitPlaceTexts {
  static String plannedRoom(String room) => '$room (planned)';
  static const roomToBeSet = 'Room to be set';

  /// Title before a clinician's name; other account types show the name alone.
  static const clinicianTitles = {UserType.doctor: 'Dr.', UserType.nurse: 'Nurse'};
}
