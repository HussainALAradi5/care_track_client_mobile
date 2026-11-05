import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/scheduling.dart';
import '../../constants/texts/staff_texts.dart';
import '../../controllers/care/queue_controller.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../../models/care/booking.dart';
import '../../models/ui/confirm_config.dart';
import '../../widgets/care/queue_row.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/feedback/reason_sheet.dart';
import '../../widgets/layout/staff_page.dart';

/// Staff booking queue: waiting requests at the selected Hospital, oldest first, to confirm or decline.
class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(queueProvider.notifier);
    final canDecide = ref.watch(selectedStaffHospitalProvider)?.can(PermissionCodes.bookingConfirm) ?? false;
    return StaffPage(
      title: StaffTexts.queueTitle,
      subtitle: StaffTexts.queueSubtitle,
      permission: PermissionCodes.bookingReadAll,
      onRefresh: controller.refresh,
      children: [
        PagedList<Booking>(
          value: ref.watch(queueProvider),
          idOf: (b) => b.id,
          emptyIcon: Icons.inbox_rounded,
          emptyTitle: StaffTexts.queueEmpty,
          emptyHint: StaffTexts.queueEmptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (b) => QueueRow(
            booking: b,
            onConfirm: canDecide ? () => _confirm(context, controller, b) : null,
            onReject: canDecide ? () => _reject(context, controller, b) : null,
          ),
        ),
      ],
    );
  }

  Future<void> _confirm(BuildContext context, QueueController controller, Booking booking) async {
    await controller.confirm(booking);
    if (context.mounted) AppSnack.success(context, StaffTexts.confirmed);
  }

  Future<void> _reject(BuildContext context, QueueController controller, Booking booking) async {
    const config = ConfirmConfig(
      title: StaffTexts.rejectTitle,
      message: StaffTexts.rejectBody,
      confirmLabel: StaffTexts.reject,
      danger: true,
    );
    final reason = await showReasonSheet(
      context,
      config,
      reasonLabel: StaffTexts.rejectReason,
      maxLength: Scheduling.reasonMaxLength,
    );
    if (reason == null) return;
    await controller.reject(booking, reason);
    if (context.mounted) AppSnack.success(context, StaffTexts.rejected);
  }
}
