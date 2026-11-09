import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/attendance_styles.dart';
import '../../../constants/texts/attendance_texts.dart';
import '../../../models/workforce/day_attendance_row.dart';
import '../../../utilities/time/dates.dart';
import '../../common/display/section_card.dart';
import '../../common/status/status_chip.dart';

/// Managers: who is in, late, absent or on leave among their people today.
class TeamTodaySection extends StatelessWidget {
  const TeamTodaySection({super.key, required this.rows});

  final List<DayAttendanceRow> rows;

  String? _detail(DayAttendanceRow r) {
    final parts = [
      if (r.clockInAt != null) AttendanceTexts.inAt(timeOfDayLabel(r.clockInAt!.toLocal())),
      if (r.clockOutAt != null) AttendanceTexts.outAt(timeOfDayLabel(r.clockOutAt!.toLocal())),
      if (r.clockInAt == null && r.expectedAt != null) AttendanceTexts.expected(timeOfDayLabel(r.expectedAt!.toLocal())),
      ?r.leaveTypeName,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) => SectionCard(
    title: AttendanceTexts.teamTitle,
    hint: AttendanceTexts.teamLead,
    children: [
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.small),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.userName, style: Theme.of(context).textTheme.titleSmall),
                    ?(_detail(r) == null ? null : Text(_detail(r)!, style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ),
              ),
              StatusChip(status: AttendanceStyles.day[r.status]!),
            ],
          ),
        ),
    ],
  );
}
