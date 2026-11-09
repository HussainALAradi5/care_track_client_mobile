import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/attendance_texts.dart';
import '../../../models/workforce/work_attendance.dart';
import '../../../utilities/time/dates.dart';
import '../../../utilities/workforce/attendance.dart';
import '../../common/display/section_card.dart';

/// The caller's last two weeks.
class HistorySection extends StatelessWidget {
  const HistorySection({super.key, required this.days});

  final List<WorkAttendance> days;

  String _line(WorkAttendance day) => [
    AttendanceTexts.inAt(timeOfDayLabel(day.clockInAt.toLocal())),
    if (day.clockOutAt != null) AttendanceTexts.outAt(timeOfDayLabel(day.clockOutAt!.toLocal())),
    if (day.minutesLate > 0) AttendanceTexts.late(minutesLabel(day.minutesLate)),
    if (day.workedMinutes != null) AttendanceTexts.worked(minutesLabel(day.workedMinutes!)),
  ].join(' · ');

  @override
  Widget build(BuildContext context) => SectionCard(
    title: AttendanceTexts.historyTitle,
    children: [
      if (days.isEmpty) const Text(AttendanceTexts.noHistory),
      for (final day in days)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(longDate(day.workDate), style: Theme.of(context).textTheme.titleSmall),
              Text(_line(day), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
    ],
  );
}
