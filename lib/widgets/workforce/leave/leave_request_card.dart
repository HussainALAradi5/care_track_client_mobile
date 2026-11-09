import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/status_styles.dart';
import '../../../constants/texts/leave_texts.dart';
import '../../../enums/ui/button_variant.dart';
import '../../../models/workforce/leave_request.dart';
import '../../../utilities/time/dates.dart';
import '../../common/buttons/app_button.dart';
import '../../common/status/status_chip.dart';

/// One leave request; each action shows only when the server says this person may take it now.
class LeaveRequestCard extends StatelessWidget {
  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onCancel,
    this.showName = true,
  });

  final LeaveRequest request;
  final Future<void> Function() onApprove;
  final Future<void> Function() onReject;
  final Future<void> Function() onCancel;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final r = request;
    final title = showName ? r.userName : r.leaveTypeName;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
                const SizedBox(width: AppSpacing.small),
                StatusChip(status: StatusStyles.leave[r.status]!),
              ],
            ),
            const SizedBox(height: AppSpacing.tiny),
            Text('${r.leaveTypeName} · ${dayRange(r.startDate, r.endDate)} · ${LeaveTexts.days(r.days)}'),
            if (r.reason != null) Text(r.reason!, style: muted),
            if (r.sickNote != null) Text(LeaveTexts.sickNote(r.sickNote!.hospitalName, r.sickNote!.doctorName), style: muted),
            if (r.decidedByName != null)
              Text([LeaveTexts.decidedBy(r.decidedByName!), ?r.decisionNote].join(' · '), style: muted),
            if (r.canDecide || r.canCancel) ...[
              const SizedBox(height: AppSpacing.small),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.small,
                children: [
                  if (r.canDecide) AppButton(label: LeaveTexts.reject, variant: ButtonVariant.text, onPressed: onReject),
                  if (r.canDecide) AppButton(label: LeaveTexts.approve, variant: ButtonVariant.tonal, onPressed: onApprove),
                  if (r.canCancel) AppButton(label: LeaveTexts.cancel, variant: ButtonVariant.text, onPressed: onCancel),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
