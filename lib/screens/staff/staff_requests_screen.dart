import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/permission_codes.dart';
import '../../constants/staff_request_rules.dart';
import '../../constants/status_styles.dart';
import '../../constants/texts/staff_request_texts.dart';
import '../../controllers/workforce/staff_requests_controller.dart';
import '../../controllers/workforce/staff_request_status_filter_controller.dart';
import '../../enums/workforce/staff_request_status.dart';
import '../../models/ui/confirm_config.dart';
import '../../models/ui/filter_option.dart';
import '../../models/workforce/staff_request.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/feedback/reason_sheet.dart';
import '../../widgets/common/inputs/filter_chips.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/hr_request_card.dart';

/// HR's list of what the people at its hospitals ask for, by status; approve or reject what waits.
class StaffRequestsScreen extends ConsumerWidget {
  const StaffRequestsScreen({super.key});

  Future<void> _approve(BuildContext context, StaffRequestsController controller, StaffRequest request) async {
    await controller.decide(request, approve: true);
    if (context.mounted) AppSnack.success(context, StaffRequestTexts.approved(request.userName ?? ''));
  }

  Future<void> _reject(BuildContext context, StaffRequestsController controller, StaffRequest request) async {
    final name = request.userName ?? '';
    final note = await showReasonSheet(
      context,
      ConfirmConfig(
        title: StaffRequestTexts.rejectTitle,
        message: StaffRequestTexts.rejectMessage(name, StaffRequestTexts.types[request.type]!),
        confirmLabel: StaffRequestTexts.reject,
        danger: true,
      ),
      reasonLabel: StaffRequestTexts.rejectReason,
      maxLength: StaffRequestRules.noteMax,
    );
    if (note == null) return;
    await controller.decide(request, approve: false, note: note);
    if (context.mounted) AppSnack.success(context, StaffRequestTexts.rejected(name));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(staffRequestsProvider.notifier);
    return StaffPage(
      title: StaffRequestTexts.hrTitle,
      subtitle: StaffRequestTexts.hrSubtitle,
      permission: PermissionCodes.staffRequestHandle,
      onRefresh: controller.refresh,
      children: [
        FilterChips<StaffRequestStatus>(
          options: [
            for (final status in StaffRequestStatus.values)
              FilterOption(value: status, label: StatusStyles.staffRequest[status]!.label),
            const FilterOption<StaffRequestStatus>(value: null, label: StaffRequestTexts.all),
          ],
          selected: ref.watch(staffRequestStatusFilterProvider),
          onSelected: ref.read(staffRequestStatusFilterProvider.notifier).set,
        ),
        const SizedBox(height: AppSpacing.medium),
        PagedList<StaffRequest>(
          value: ref.watch(staffRequestsProvider),
          idOf: (r) => r.id,
          emptyIcon: Icons.assignment_turned_in_rounded,
          emptyTitle: StaffRequestTexts.hrEmpty,
          emptyHint: StaffRequestTexts.hrEmptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (r) => HrRequestCard(
            request: r,
            onApprove: () => _approve(context, controller, r),
            onReject: () => _reject(context, controller, r),
          ),
        ),
      ],
    );
  }
}
