import '../../constants/scheduling.dart';
import '../../enums/care/appointment_status.dart';
import '../../models/care/appointment.dart';
import '../../models/care/desk_actions.dart';

/// Which desk actions the server's time rules allow now (SchedulingRules.java): check-in from shortly before the
/// start to the end, "did not arrive" a while after the end, "not seen" for a checked-in visit once the
/// late-start grace has passed. Permissions are checked apart.
DeskActions deskActionsFor(Appointment appointment, DateTime now) {
  final scheduled = appointment.status == AppointmentStatus.scheduled;
  final checkInOpens = appointment.startsAt.subtract(const Duration(minutes: Scheduling.earlyCheckInMinutes));
  return DeskActions(
    checkIn: scheduled && !now.isBefore(checkInOpens) && !now.isAfter(appointment.endsAt),
    noShow:
        scheduled && !now.isBefore(appointment.endsAt.add(const Duration(minutes: Scheduling.noShowAfterEndMinutes))),
    notSeen:
        appointment.status == AppointmentStatus.checkedIn &&
        !now.isBefore(appointment.endsAt.add(const Duration(minutes: Scheduling.lateStartGraceMinutes))),
  );
}
