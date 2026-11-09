import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/attendance_texts.dart';
import '../../../enums/ui/button_variant.dart';
import '../../../models/workforce/my_attendance_today.dart';
import '../../../models/workforce/staff_attendance.dart';
import '../../../utilities/time/dates.dart';
import '../../../utilities/workforce/attendance.dart';
import '../../common/buttons/app_button.dart';
import '../../common/display/section_card.dart';

/// Today's clock-in and out, or why there is none, with the button the server allows now.
class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.day,
    required this.onClockIn,
    required this.onClockOut,
    required this.onClockInToShift,
    required this.onClockOutOfShift,
  });

  final MyAttendanceToday day;
  final Future<void> Function() onClockIn;
  final Future<void> Function(int version) onClockOut;
  final Future<void> Function(String shiftId) onClockInToShift;
  final Future<void> Function(String shiftId, int version) onClockOutOfShift;

  String? _statusLine() {
    final t = day.today;
    if (t != null) {
      return [
        AttendanceTexts.inAt(timeOfDayLabel(t.clockInAt.toLocal())),
        if (t.clockOutAt != null) AttendanceTexts.outAt(timeOfDayLabel(t.clockOutAt!.toLocal())),
        if (t.minutesLate > 0) AttendanceTexts.late(minutesLabel(t.minutesLate)),
        if (t.workedMinutes != null) AttendanceTexts.worked(minutesLabel(t.workedMinutes!)),
      ].join(' · ');
    }
    if (day.shiftStartsAt != null) return null;
    if (day.leaveTypeName != null) return AttendanceTexts.onLeave(day.leaveTypeName!);
    if (day.schedule == null) return AttendanceTexts.noHours;
    if (!day.workingDay) return AttendanceTexts.offDay;
    return null;
  }

  String _shiftTimes(StaffAttendance record) => [
    AttendanceTexts.inAt(timeOfDayLabel(record.clockInAt.toLocal())),
    if (record.clockOutAt != null) AttendanceTexts.outAt(timeOfDayLabel(record.clockOutAt!.toLocal())),
  ].join(' · ');

  @override
  Widget build(BuildContext context) {
    final s = day.schedule;
    final shiftRecord = day.shiftAttendance;
    final canActOnShift = day.canClockInToShift || day.canClockOutOfShift;
    final line = _statusLine();
    return SectionCard(
      title: longDate(DateTime.now()),
      icon: Icons.fingerprint_rounded,
      children: [
        ?(line == null ? null : Text(line)),
        if (day.shiftStartsAt != null) Text(AttendanceTexts.onShift(timeOfDayLabel(day.shiftStartsAt!.toLocal()))),
        if (shiftRecord != null) Text(_shiftTimes(shiftRecord)),
        if (s != null)
          Text(AttendanceTexts.hours(daysLabel(s.workingDays), shortTime(s.startTime), shortTime(s.endTime))),
        if (day.canClockIn || day.canClockOut || canActOnShift) const SizedBox(height: AppSpacing.medium),
        if (day.canClockIn) AppButton(label: AttendanceTexts.clockIn, icon: Icons.login_rounded, expand: true, onPressed: onClockIn),
        if (day.canClockOut)
          AppButton(
            label: AttendanceTexts.clockOut,
            icon: Icons.logout_rounded,
            variant: ButtonVariant.tonal,
            expand: true,
            onPressed: () => onClockOut(day.today!.version),
          ),
        if (day.canClockInToShift)
          AppButton(
            label: AttendanceTexts.clockIn,
            icon: Icons.login_rounded,
            expand: true,
            onPressed: () => onClockInToShift(day.shiftId!),
          ),
        if (day.canClockOutOfShift)
          AppButton(
            label: AttendanceTexts.clockOut,
            icon: Icons.logout_rounded,
            variant: ButtonVariant.tonal,
            expand: true,
            onPressed: () => onClockOutOfShift(day.shiftId!, shiftRecord!.version),
          ),
      ],
    );
  }
}
