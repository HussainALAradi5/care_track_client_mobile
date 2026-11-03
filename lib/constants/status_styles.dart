import 'package:flutter/material.dart';

import '../enums/care/appointment_status.dart';
import '../enums/care/booking_status.dart';
import '../enums/ui/status_tone.dart';
import '../models/ui/status_style.dart';

class StatusStyles {
  const StatusStyles._();

  static const booking = <BookingStatus, StatusStyle>{
    BookingStatus.requested: StatusStyle(label: 'Waiting', tone: StatusTone.info, icon: Icons.hourglass_top_rounded),
    BookingStatus.confirmed: StatusStyle(label: 'Confirmed', tone: StatusTone.success, icon: Icons.check_circle_rounded),
    BookingStatus.cancelled: StatusStyle(label: 'Withdrawn', tone: StatusTone.neutral, icon: Icons.undo_rounded),
    BookingStatus.rejected: StatusStyle(label: 'Declined', tone: StatusTone.danger, icon: Icons.block_rounded),
    BookingStatus.expired: StatusStyle(label: 'Expired', tone: StatusTone.warning, icon: Icons.timer_off_rounded),
  };

  static const appointment = <AppointmentStatus, StatusStyle>{
    AppointmentStatus.scheduled: StatusStyle(label: 'Scheduled', tone: StatusTone.info, icon: Icons.event_rounded),
    AppointmentStatus.cancelled: StatusStyle(label: 'Cancelled', tone: StatusTone.neutral, icon: Icons.event_busy_rounded),
    AppointmentStatus.checkedIn: StatusStyle(label: 'Checked in', tone: StatusTone.success, icon: Icons.how_to_reg_rounded),
    AppointmentStatus.noShow: StatusStyle(label: 'Missed', tone: StatusTone.danger, icon: Icons.person_off_rounded),
    AppointmentStatus.inProgress: StatusStyle(label: 'In progress', tone: StatusTone.warning, icon: Icons.medical_services_rounded),
    AppointmentStatus.completed: StatusStyle(label: 'Completed', tone: StatusTone.success, icon: Icons.task_alt_rounded),
    AppointmentStatus.notSeen: StatusStyle(label: 'Not seen', tone: StatusTone.warning, icon: Icons.schedule_rounded),
  };
}
