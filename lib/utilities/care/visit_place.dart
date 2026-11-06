import '../../constants/texts/visit_place_texts.dart';
import '../../constants/visit_place_styles.dart';
import '../../enums/care/appointment_room_source.dart';
import '../../models/care/appointment.dart';
import '../../models/ui/status_style.dart';

/// The badges of where a visit happens, in reading order: the Hospital, the clinician's department, then the room:
/// the session's room once the visit has one, the planned room (marked as planned) before, or "Room to be set" while
/// the visit is still open; a finished visit's unknown room is left out.
List<StatusStyle> visitPlaceBadges(Appointment a) => [
  if (a.hospitalName.isNotEmpty)
    StatusStyle(label: a.hospitalName, tone: VisitPlaceStyles.hospital.tone, icon: VisitPlaceStyles.hospital.icon),
  if (a.departmentName != null)
    StatusStyle(
      label: a.departmentName!,
      tone: VisitPlaceStyles.department.tone,
      icon: VisitPlaceStyles.department.icon,
    ),
  if (a.roomName == null) ...[
    if (VisitPlaceTexts.openVisitStatuses.contains(a.status))
      StatusStyle(
        label: VisitPlaceTexts.roomToBeSet,
        tone: VisitPlaceStyles.noRoom.tone,
        icon: VisitPlaceStyles.noRoom.icon,
      ),
  ] else if (a.roomSource == AppointmentRoomSource.session)
    StatusStyle(label: a.roomName!, tone: VisitPlaceStyles.room.tone, icon: VisitPlaceStyles.room.icon)
  else
    StatusStyle(
      label: VisitPlaceTexts.plannedRoom(a.roomName!),
      tone: VisitPlaceStyles.plannedRoom.tone,
      icon: VisitPlaceStyles.plannedRoom.icon,
    ),
];

/// "Dr. Sara Ali", "Nurse Omar Saleh", or the name alone for other account types.
String clinicianLabel(Appointment a) {
  final title = VisitPlaceTexts.clinicianTitles[a.clinicianType];
  return title == null ? a.clinicianName : '$title ${a.clinicianName}';
}
