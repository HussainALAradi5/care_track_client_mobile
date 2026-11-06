import 'package:flutter/material.dart';

import '../../constants/status_styles.dart';
import '../../constants/texts/staff_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/care/appointment.dart';
import '../../utilities/time/dates.dart';
import '../common/buttons/app_button.dart';
import '../common/display/avatar.dart';
import '../common/status/status_chip.dart';
import '../../utilities/care/visit_place.dart';
import 'visit_place.dart';

/// One appointment at the desk: patient, clinician, time, status, and only the actions open to this staff
/// member right now (a null callback hides its button).
class DeskRow extends StatelessWidget {
  const DeskRow({super.key, required this.appointment, this.onCheckIn, this.onNoShow, this.onNotSeen});

  final Appointment appointment;
  final Future<void> Function()? onCheckIn;
  final Future<void> Function()? onNoShow;
  final Future<void> Function()? onNotSeen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = appointment;
    final hasActions = onCheckIn != null || onNoShow != null || onNotSeen != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Avatar(name: a.patientName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.patientName, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(
                        '${visitTime(a.startsAt, a.endsAt)} · ${StaffTexts.withClinician(clinicianLabel(a))}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(status: StatusStyles.appointment[a.status]!),
              ],
            ),
            const SizedBox(height: 10),
            VisitPlace(appointment: a),
            if (hasActions) ...[
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onNoShow != null)
                    AppButton(label: StaffTexts.noShow, variant: ButtonVariant.text, onPressed: onNoShow),
                  if (onNotSeen != null)
                    AppButton(label: StaffTexts.notSeen, variant: ButtonVariant.text, onPressed: onNotSeen),
                  if (onCheckIn != null)
                    AppButton(label: StaffTexts.checkIn, icon: Icons.how_to_reg_rounded, onPressed: onCheckIn),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
