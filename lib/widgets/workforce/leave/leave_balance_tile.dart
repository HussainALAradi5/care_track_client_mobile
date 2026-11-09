import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/leave_texts.dart';
import '../../../models/workforce/leave_balance.dart';
import '../../../utilities/workforce/leave.dart';

/// One leave type this year: days allowed, taken, waiting and left.
class LeaveBalanceTile extends StatelessWidget {
  const LeaveBalanceTile({super.key, required this.balance});

  final LeaveBalance balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = balance;
    final fraction = usedFraction(b.allowed, b.taken, b.waiting);
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(b.name, style: theme.textTheme.titleSmall)),
                Text(b.paid ? LeaveTexts.paid : LeaveTexts.unpaid, style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.tiny),
            Text(
              [
                b.allowed == null ? LeaveTexts.noLimit : LeaveTexts.allowed(b.allowed!),
                LeaveTexts.taken(b.taken),
                LeaveTexts.waiting(b.waiting),
                if (b.left != null) LeaveTexts.left(b.left!),
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
            if (fraction != null) ...[
              const SizedBox(height: AppSpacing.small),
              LinearProgressIndicator(value: fraction),
            ],
          ],
        ),
      ),
    );
  }
}
