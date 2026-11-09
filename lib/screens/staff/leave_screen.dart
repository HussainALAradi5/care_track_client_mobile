import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/leave_texts.dart';
import '../../controllers/workforce/leave_form_controller.dart';
import '../../controllers/workforce/my_leave_controller.dart';
import '../../models/workforce/leave_request.dart';
import '../../models/workforce/my_leave.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/leave/leave_balance_tile.dart';
import '../../widgets/workforce/leave/leave_form.dart';
import '../../widgets/workforce/leave/leave_request_card.dart';
import '../../widgets/workforce/leave/leave_request_flows.dart';

/// My leave: each type's days, asking for more, cancelling, and for managers their people's requests to decide.
class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key, this.sickNoteId});

  /// From a sick note's Use for my leave.
  final String? sickNoteId;

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  @override
  void initState() {
    super.initState();
    final noteId = widget.sickNoteId;
    if (noteId != null) WidgetsBinding.instance.addPostFrameCallback((_) => _attach(noteId));
  }

  Future<void> _attach(String noteId) async {
    try {
      await ref.read(leaveFormProvider.notifier).attachSickNote(noteId);
    } catch (error) {
      if (mounted) AppSnack.error(context, error);
    }
  }

  Widget _request(LeaveRequest r, {required bool showName}) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
    child: LeaveRequestCard(
      key: ValueKey(r.id),
      request: r,
      showName: showName,
      onApprove: () => LeaveRequestFlows.approve(context, ref, r),
      onReject: () => LeaveRequestFlows.reject(context, ref, r),
      onCancel: () => LeaveRequestFlows.cancel(context, ref, r),
    ),
  );

  Widget _body(MyLeave? mine) {
    if (mine == null) return const SizedBox.shrink();
    if (!mine.employed) return const EmptyState(icon: Icons.badge_rounded, title: LeaveTexts.notEmployed);
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final b in mine.balances)
          Padding(padding: const EdgeInsets.only(bottom: AppSpacing.small), child: LeaveBalanceTile(balance: b)),
        if (mine.balances.isEmpty) const EmptyState(icon: Icons.event_busy_rounded, title: LeaveTexts.noTypes),
        const SizedBox(height: AppSpacing.small),
        LeaveForm(balances: mine.balances),
        const SizedBox(height: AppSpacing.large),
        Text(LeaveTexts.mineTitle, style: theme.titleMedium),
        const SizedBox(height: AppSpacing.small),
        if (mine.requests.isEmpty) const Text(LeaveTexts.noRequests),
        for (final r in mine.requests) _request(r, showName: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the form (and any attached sick note) alive before the balances have loaded.
    ref.listen(leaveFormProvider, (_, _) {});
    final toDecide = ref.watch(leaveToDecideProvider).value ?? const <LeaveRequest>[];
    return StaffPage(
      title: LeaveTexts.title,
      subtitle: LeaveTexts.subtitle,
      onRefresh: () => ref.read(myLeaveProvider.notifier).refresh(),
      children: [
        if (toDecide.isNotEmpty) ...[
          Text(LeaveTexts.toDecideTitle, style: Theme.of(context).textTheme.titleMedium),
          const Text(LeaveTexts.toDecideLead),
          const SizedBox(height: AppSpacing.small),
          for (final r in toDecide) _request(r, showName: true),
        ],
        AsyncBody(
          value: ref.watch(myLeaveProvider),
          onRetry: () => ref.invalidate(myLeaveProvider),
          data: _body,
        ),
      ],
    );
  }
}
