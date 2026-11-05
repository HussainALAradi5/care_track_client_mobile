import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/scheduling.dart';
import '../../constants/texts/staff_texts.dart';
import '../../controllers/care/desk_controller.dart';
import '../../controllers/care/desk_filter_controller.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../../controllers/ui/clock_controller.dart';
import '../../enums/care/appointment_status.dart';
import '../../models/care/appointment.dart';
import '../../models/ui/confirm_config.dart';
import '../../utilities/care/desk_actions.dart';
import '../../widgets/care/desk_row.dart';
import '../../widgets/care/verification_sheet.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/feedback/reason_sheet.dart';
import '../../widgets/layout/staff_page.dart';

/// Appointments desk: visits at the selected Hospital, soonest first, to check in or close as missed / not seen.
/// Buttons appear only inside the server's time windows and when the Hospital grants the action.
class DeskScreen extends ConsumerWidget {
  const DeskScreen({super.key});

  static const _tabLabels = {
    AppointmentStatus.scheduled: StaffTexts.waitingToArrive,
    AppointmentStatus.checkedIn: StaffTexts.checkedInTab,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(deskProvider.notifier);
    final tab = ref.watch(deskFilterProvider);
    final now = ref.watch(nowProvider);
    final hospital = ref.watch(selectedStaffHospitalProvider);
    final canCheckIn = hospital?.can(PermissionCodes.appointmentCheckIn) ?? false;
    final canClose = hospital?.can(PermissionCodes.appointmentNoShow) ?? false;
    return StaffPage(
      title: StaffTexts.deskTitle,
      subtitle: StaffTexts.deskSubtitle,
      permission: PermissionCodes.appointmentReadAll,
      onRefresh: controller.refresh,
      children: [
        SegmentedButton<AppointmentStatus>(
          showSelectedIcon: false,
          segments: [
            for (final status in DeskFilterController.tabs)
              ButtonSegment(value: status, label: Text(_tabLabels[status]!)),
          ],
          selected: {tab},
          onSelectionChanged: (picked) => ref.read(deskFilterProvider.notifier).select(picked.first),
        ),
        const SizedBox(height: 16),
        PagedList<Appointment>(
          value: ref.watch(deskProvider),
          idOf: (a) => a.id,
          emptyIcon: Icons.event_available_rounded,
          emptyTitle: StaffTexts.deskEmpty,
          emptyHint: StaffTexts.deskEmptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (a) {
            final open = deskActionsFor(a, now);
            return DeskRow(
              appointment: a,
              onCheckIn: open.checkIn && canCheckIn ? () => _checkIn(context, controller, a) : null,
              onNoShow: open.noShow && canClose ? () => _noShow(context, controller, a) : null,
              onNotSeen: open.notSeen && canClose ? () => _notSeen(context, controller, a) : null,
            );
          },
        ),
      ],
    );
  }

  Future<void> _checkIn(BuildContext context, DeskController controller, Appointment appointment) async {
    final method = await showVerificationSheet(context);
    if (method == null) return;
    await controller.checkIn(appointment, method);
    if (context.mounted) AppSnack.success(context, StaffTexts.checkedIn);
  }

  Future<void> _noShow(BuildContext context, DeskController controller, Appointment appointment) async {
    const config = ConfirmConfig(
      title: StaffTexts.noShowTitle,
      message: StaffTexts.noShowBody,
      confirmLabel: StaffTexts.noShow,
      danger: true,
    );
    final reason = await showReasonSheet(
      context,
      config,
      reasonLabel: StaffTexts.noShowReason,
      maxLength: Scheduling.reasonMaxLength,
    );
    if (reason == null) return;
    await controller.markNoShow(appointment, reason);
    if (context.mounted) AppSnack.success(context, StaffTexts.noShowDone);
  }

  Future<void> _notSeen(BuildContext context, DeskController controller, Appointment appointment) async {
    const config = ConfirmConfig(
      title: StaffTexts.notSeenTitle,
      message: StaffTexts.notSeenBody,
      confirmLabel: StaffTexts.notSeen,
      danger: true,
    );
    final reason = await showReasonSheet(
      context,
      config,
      reasonLabel: StaffTexts.notSeenReason,
      maxLength: Scheduling.reasonMaxLength,
    );
    if (reason == null) return;
    await controller.markNotSeen(appointment, reason);
    if (context.mounted) AppSnack.success(context, StaffTexts.notSeenDone);
  }
}
