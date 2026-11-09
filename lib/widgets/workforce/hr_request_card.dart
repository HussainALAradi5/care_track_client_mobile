import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/status_styles.dart';
import '../../constants/texts/staff_request_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/workforce/staff_request.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/status/status_chip.dart';

/// One staff request as HR sees it; approve and reject show only while the server allows them.
class HrRequestCard extends StatelessWidget {
  const HrRequestCard({super.key, required this.request, required this.onApprove, required this.onReject});

  final StaffRequest request;
  final Future<void> Function() onApprove;
  final Future<void> Function() onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final r = request;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(r.userName ?? '', style: theme.textTheme.titleSmall)),
                const SizedBox(width: AppSpacing.small),
                StatusChip(status: StatusStyles.staffRequest[r.status]!),
              ],
            ),
            const SizedBox(height: AppSpacing.tiny),
            Text(StaffRequestTexts.types[r.type]!, style: theme.textTheme.bodyMedium),
            Text(r.details),
            const SizedBox(height: AppSpacing.tiny),
            Text('${r.code} · ${StaffRequestTexts.raised(shortDateTime(r.requestedAt.toLocal()))}', style: muted),
            if (r.decidedByName != null)
              Text([StaffRequestTexts.decidedBy(r.decidedByName!), ?r.decisionNote].join(' · '), style: muted),
            if (r.canDecide) ...[
              const SizedBox(height: AppSpacing.small),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.small,
                children: [
                  AppButton(label: StaffRequestTexts.reject, variant: ButtonVariant.text, onPressed: onReject),
                  AppButton(label: StaffRequestTexts.approve, variant: ButtonVariant.tonal, onPressed: onApprove),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
