import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/error_codes.dart';
import '../../constants/texts/attendance_texts.dart';
import '../../controllers/workforce/attendance_controller.dart';
import '../../models/workforce/my_attendance_today.dart';
import '../../models/workforce/work_attendance.dart';
import '../../utilities/http/error_message.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/attendance/history_section.dart';
import '../../widgets/workforce/attendance/team_today_section.dart';
import '../../widgets/workforce/attendance/today_card.dart';

/// Today's clock-in and out at the selected Hospital, the last two weeks, and for managers their people today.
class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  Future<void> _clockIn(BuildContext context, AttendanceTodayController c) async {
    await c.clockIn();
    if (context.mounted) AppSnack.success(context, AttendanceTexts.clockedIn);
  }

  Future<void> _clockOut(BuildContext context, AttendanceTodayController c, int version) async {
    await c.clockOut(version);
    if (context.mounted) AppSnack.success(context, AttendanceTexts.clockedOut);
  }

  Future<void> _clockInToShift(BuildContext context, AttendanceTodayController c, String shiftId) async {
    await c.clockInToShift(shiftId);
    if (context.mounted) AppSnack.success(context, AttendanceTexts.clockedIn);
  }

  Future<void> _clockOutOfShift(BuildContext context, AttendanceTodayController c, String shiftId, int version) async {
    await c.clockOutOfShift(shiftId, version);
    if (context.mounted) AppSnack.success(context, AttendanceTexts.clockedOut);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(attendanceTodayProvider);
    final controller = ref.read(attendanceTodayProvider.notifier);
    final teamRows = ref.watch(teamTodayProvider).value ?? const [];
    final notAssigned = apiErrorCodeOf(today.error) == ErrorCodes.attendanceNotAssigned;
    return StaffPage(
      title: AttendanceTexts.title,
      subtitle: AttendanceTexts.subtitle,
      onRefresh: controller.refresh,
      children: notAssigned
          ? const [EmptyState(icon: Icons.info_rounded, title: AttendanceTexts.notAssigned)]
          : [
              AsyncBody<MyAttendanceToday?>(
                value: today,
                skeletonRows: 1,
                onRetry: () => ref.invalidate(attendanceTodayProvider),
                data: (day) => day == null
                    ? const SizedBox.shrink()
                    : TodayCard(
                        day: day,
                        onClockIn: () => _clockIn(context, controller),
                        onClockOut: (version) => _clockOut(context, controller, version),
                        onClockInToShift: (shiftId) => _clockInToShift(context, controller, shiftId),
                        onClockOutOfShift: (shiftId, version) => _clockOutOfShift(context, controller, shiftId, version),
                      ),
              ),
              if (teamRows.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.medium),
                TeamTodaySection(rows: teamRows),
              ],
              const SizedBox(height: AppSpacing.medium),
              AsyncBody<List<WorkAttendance>>(
                value: ref.watch(attendanceHistoryProvider),
                skeletonRows: 2,
                onRetry: () => ref.invalidate(attendanceHistoryProvider),
                data: (days) => HistorySection(days: days),
              ),
            ],
    );
  }
}
