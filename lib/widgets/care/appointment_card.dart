import 'package:flutter/material.dart';

import '../../constants/status_styles.dart';
import '../../constants/texts/appointment_texts.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/care/appointment.dart';
import '../../utilities/time/dates.dart';
import '../../enums/ui/avatar_tone.dart';
import '../common/buttons/app_button.dart';
import '../common/display/avatar.dart';
import '../common/progress/countdown_meter.dart';
import '../common/status/status_chip.dart';
import '../../utilities/care/visit_place.dart';
import 'visit_place.dart';

/// One appointment: when, with whom (the doctor's or nurse's title on their name) and where (hospital, department
/// and room badges). While scheduled, a draining meter shows how long free cancellation stays open
/// (the server's stored deadline); the cancel action disappears once the window has closed.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.clinicianName,
    required this.now,
    this.highlight = false,
    this.onCancel,
  });

  final Appointment appointment;
  final String clinicianName;
  final DateTime now;
  final bool highlight;
  final Future<void> Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final a = appointment;
    final onCard = highlight ? scheme.onPrimary : null;
    final canCancel = a.scheduled && a.cancellationDeadlineAt.isAfter(now) && onCancel != null;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: highlight ? scheme.primary : scheme.surfaceContainerLowest,
        border: highlight ? null : Border.all(color: scheme.outlineVariant),
        boxShadow: highlight
            ? [BoxShadow(color: scheme.primary.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8))]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Avatar(icon: Icons.medical_services_rounded, tone: highlight ? AvatarTone.inverse : AvatarTone.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(visitTime(a.startsAt, a.endsAt), style: theme.textTheme.titleSmall?.copyWith(color: onCard)),
                    Text(
                      a.clinicianName.isNotEmpty ? clinicianLabel(a) : (clinicianName.isEmpty ? a.code : clinicianName),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: onCard?.withValues(alpha: 0.85) ?? scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              StatusChip(status: StatusStyles.appointment[a.status]!),
            ],
          ),
          const SizedBox(height: 12),
          VisitPlace(appointment: a),
          if (a.scheduled) ...[
            const SizedBox(height: 16),
            CountdownMeter(
              opensAt: a.createdAt,
              closesAt: a.cancellationDeadlineAt,
              label: AppointmentTexts.cancelWindow,
              closedLabel: AppointmentTexts.cancelWindowClosed,
              onColor: onCard,
            ),
          ],
          if (canCancel)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Theme(
                  data: highlight
                      ? theme.copyWith(
                          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: scheme.onPrimary)),
                        )
                      : theme,
                  child: AppButton(label: AppointmentTexts.cancel, variant: ButtonVariant.text, onPressed: onCancel),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
