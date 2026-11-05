import 'package:flutter/material.dart';

import '../../constants/texts/shift_texts.dart';
import '../../enums/ui/avatar_tone.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/workforce/clinician_shift.dart';
import '../../utilities/time/countdown.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/display/avatar.dart';
import '../common/progress/countdown_meter.dart';

/// One upcoming or running shift: who and when, "starts in" before it begins, a draining meter while it runs,
/// and remove until it starts.
class ShiftRow extends StatelessWidget {
  const ShiftRow({super.key, required this.shift, required this.now, this.onRemove});

  final ClinicianShift shift;
  final DateTime now;
  final Future<void> Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = shift;
    final started = s.startedAt(now);
    final startsIn = remainingLabel(s.startsAt, now);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: started ? scheme.primary : scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Avatar(name: s.clinicianName, tone: started ? AvatarTone.solid : AvatarTone.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.clinicianName, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(
                        visitTime(s.startsAt, s.endsAt),
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (!started && startsIn != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(ShiftTexts.startsIn(startsIn), style: theme.textTheme.labelSmall),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!started && onRemove != null)
                  AppButton(label: ShiftTexts.remove, variant: ButtonVariant.text, onPressed: onRemove),
              ],
            ),
            if (started) ...[
              const SizedBox(height: 12),
              CountdownMeter(
                opensAt: s.startsAt,
                closesAt: s.endsAt,
                label: ShiftTexts.onShift,
                closedLabel: ShiftTexts.shiftEnded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
