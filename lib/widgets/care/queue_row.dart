import 'package:flutter/material.dart';

import '../../constants/texts/staff_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/care/booking.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/display/avatar.dart';

/// One waiting request in the staff queue: who, with whom, when, and confirm / decline when allowed.
class QueueRow extends StatelessWidget {
  const QueueRow({super.key, required this.booking, this.onConfirm, this.onReject});

  final Booking booking;

  /// Null hides the decision buttons (the Hospital does not grant BOOKING:CONFIRM).
  final Future<void> Function()? onConfirm;
  final Future<void> Function()? onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = booking;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Avatar(name: b.patientName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.patientName, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(
                        '${visitTime(b.startsAt, b.endsAt)} · ${StaffTexts.withClinician(b.clinicianName)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onConfirm != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(label: StaffTexts.reject, variant: ButtonVariant.text, onPressed: onReject),
                  const SizedBox(width: 8),
                  AppButton(label: StaffTexts.confirm, icon: Icons.check_rounded, onPressed: onConfirm),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
