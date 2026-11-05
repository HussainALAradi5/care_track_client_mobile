import 'package:flutter/material.dart';

import '../../constants/status_styles.dart';
import '../../constants/texts/booking_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/care/booking.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/display/avatar.dart';
import '../common/status/status_chip.dart';

/// One booking request: when, with whom, its decision, the decline reason and a withdraw action while waiting.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.clinicianName, this.onWithdraw});

  final Booking booking;
  final String clinicianName;
  final Future<void> Function()? onWithdraw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Avatar(icon: Icons.event_note_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(visitTime(booking.startsAt, booking.endsAt), style: theme.textTheme.titleSmall),
                      Text(
                        clinicianName.isEmpty ? booking.code : clinicianName,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StatusChip(status: StatusStyles.booking[booking.status]!, live: booking.waiting),
              ],
            ),
            if (booking.rejectionReason != null) ...[
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '${BookingTexts.rejectedBecause}: ', style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: booking.rejectionReason),
                  ],
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (booking.waiting && onWithdraw != null)
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(label: BookingTexts.withdraw, variant: ButtonVariant.text, onPressed: onWithdraw),
              ),
          ],
        ),
      ),
    );
  }
}
