import 'package:flutter/material.dart';

import '../enums/ui/status_tone.dart';
import '../enums/workforce/day_attendance_status.dart';
import '../models/ui/status_style.dart';

/// How each day status reads and looks.
class AttendanceStyles {
  const AttendanceStyles._();

  static const day = <DayAttendanceStatus, StatusStyle>{
    DayAttendanceStatus.present: StatusStyle(label: 'On time', tone: StatusTone.success, icon: Icons.check_circle_rounded),
    DayAttendanceStatus.late: StatusStyle(label: 'Late', tone: StatusTone.warning, icon: Icons.schedule_rounded),
    DayAttendanceStatus.absent: StatusStyle(label: 'Absent', tone: StatusTone.danger, icon: Icons.person_off_rounded),
    DayAttendanceStatus.onLeave: StatusStyle(label: 'On leave', tone: StatusTone.info, icon: Icons.flight_takeoff_rounded),
    DayAttendanceStatus.offDay: StatusStyle(label: 'Day off', tone: StatusTone.neutral, icon: Icons.weekend_rounded),
    DayAttendanceStatus.notInYet: StatusStyle(label: 'Not in yet', tone: StatusTone.info, icon: Icons.hourglass_top_rounded),
    DayAttendanceStatus.noSchedule: StatusStyle(label: 'No hours set', tone: StatusTone.neutral, icon: Icons.help_rounded),
  };
}
