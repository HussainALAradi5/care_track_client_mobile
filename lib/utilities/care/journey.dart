import 'package:flutter/material.dart';

import '../../constants/texts/appointment_texts.dart';
import '../../enums/care/appointment_status.dart';
import '../../enums/ui/status_tone.dart';
import '../../models/care/appointment.dart';
import '../../models/ui/timeline_entry.dart';

const _visited = {AppointmentStatus.checkedIn, AppointmentStatus.inProgress, AppointmentStatus.completed};

/// The steps of one visit, from request to completion, for the timeline widget.
List<TimelineEntry> appointmentJourney(Appointment a) {
  final entries = [
    const TimelineEntry(title: AppointmentTexts.stepRequested, icon: Icons.send_rounded, tone: StatusTone.info, done: true),
    TimelineEntry(
      title: AppointmentTexts.stepConfirmed,
      icon: Icons.event_available_rounded,
      tone: StatusTone.success,
      done: true,
      at: a.createdAt,
    ),
  ];
  if (a.status == AppointmentStatus.cancelled) {
    return [
      ...entries,
      const TimelineEntry(title: AppointmentTexts.stepCancelled, icon: Icons.event_busy_rounded, tone: StatusTone.neutral, done: true),
    ];
  }
  if (a.status == AppointmentStatus.noShow) {
    return [
      ...entries,
      TimelineEntry(
        title: AppointmentTexts.stepMissed,
        icon: Icons.person_off_rounded,
        tone: StatusTone.danger,
        done: true,
        detail: a.noShowReason,
        at: a.noShowAt,
      ),
    ];
  }
  if (a.status == AppointmentStatus.notSeen) {
    return [
      ...entries,
      TimelineEntry(
        title: AppointmentTexts.stepCheckedIn,
        icon: Icons.how_to_reg_rounded,
        tone: StatusTone.success,
        done: true,
        at: a.checkedInAt,
      ),
      TimelineEntry(
        title: AppointmentTexts.stepNotSeen,
        icon: Icons.schedule_rounded,
        tone: StatusTone.warning,
        done: true,
        detail: a.notSeenReason,
        at: a.notSeenAt,
      ),
    ];
  }
  return [
    ...entries,
    TimelineEntry(
      title: AppointmentTexts.stepCheckedIn,
      icon: Icons.how_to_reg_rounded,
      tone: StatusTone.success,
      done: _visited.contains(a.status),
      at: a.checkedInAt,
    ),
    TimelineEntry(
      title: AppointmentTexts.stepCompleted,
      icon: Icons.task_alt_rounded,
      tone: StatusTone.success,
      done: a.status == AppointmentStatus.completed,
    ),
  ];
}
