import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/permission_codes.dart';
import '../../constants/status_styles.dart';
import '../../constants/texts/leave_texts.dart';
import '../../controllers/workforce/leave_requests_controller.dart';
import '../../controllers/workforce/leave_status_filter_controller.dart';
import '../../enums/workforce/leave_status.dart';
import '../../models/ui/filter_option.dart';
import '../../models/workforce/leave_request.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/inputs/filter_chips.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/leave/leave_request_card.dart';
import '../../widgets/workforce/leave/leave_request_flows.dart';

/// HR and managers: everyone's leave in the Organization by status; approve or reject what is waiting.
class LeaveRequestsScreen extends ConsumerWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(leaveRequestsProvider.notifier);
    final options = [
      for (final status in LeaveStatus.values) FilterOption(value: status, label: StatusStyles.leave[status]!.label),
      const FilterOption<LeaveStatus>(value: null, label: LeaveTexts.all),
    ];
    return StaffPage(
      title: LeaveTexts.requestsTitle,
      subtitle: LeaveTexts.requestsSubtitle,
      permission: PermissionCodes.leaveReadAll,
      onRefresh: controller.refresh,
      children: [
        FilterChips<LeaveStatus>(
          options: options,
          selected: ref.watch(leaveStatusFilterProvider),
          onSelected: ref.read(leaveStatusFilterProvider.notifier).set,
        ),
        const SizedBox(height: AppSpacing.medium),
        PagedList<LeaveRequest>(
          value: ref.watch(leaveRequestsProvider),
          idOf: (r) => r.id,
          emptyIcon: Icons.event_busy_rounded,
          emptyTitle: LeaveTexts.requestsEmpty,
          emptyHint: LeaveTexts.requestsEmptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (r) => LeaveRequestCard(
            request: r,
            onApprove: () => LeaveRequestFlows.approve(context, ref, r),
            onReject: () => LeaveRequestFlows.reject(context, ref, r),
            onCancel: () => LeaveRequestFlows.cancel(context, ref, r),
          ),
        ),
      ],
    );
  }
}
