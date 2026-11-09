import 'package:flutter/material.dart';

import '../../constants/status_styles.dart';
import '../../constants/texts/staff_request_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/workforce/staff_request.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/status/status_chip.dart';

/// One of the person's requests to HR: type, status, what was asked and the answer, with cancel while it waits.
class StaffRequestRow extends StatelessWidget {
  const StaffRequestRow({super.key, required this.request, required this.onCancel});

  final StaffRequest request;
  final Future<void> Function() onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final r = request;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(StaffRequestTexts.types[r.type]!, style: theme.textTheme.titleSmall)),
                const SizedBox(width: 8),
                StatusChip(status: StatusStyles.staffRequest[r.status]!),
              ],
            ),
            const SizedBox(height: 6),
            Text(r.details, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text('${r.code} · ${StaffRequestTexts.raised(shortDateTime(r.requestedAt.toLocal()))}', style: muted),
            if (r.decidedByName != null) ...[
              const SizedBox(height: 4),
              Text(
                [StaffRequestTexts.decidedBy(r.decidedByName!), ?r.decisionNote].join(' · '),
                style: muted,
              ),
            ],
            if (r.canCancel) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(label: StaffRequestTexts.cancel, variant: ButtonVariant.text, onPressed: onCancel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
