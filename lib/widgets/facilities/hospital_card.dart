import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/hospital_styles.dart';
import '../../models/facilities/hospital_summary.dart';
import '../../utilities/facilities/opening_label.dart';
import '../common/status/status_chip.dart';

/// One hospital in a list: name and place, public or private, open or closed now; [action] goes underneath.
class HospitalCard extends StatelessWidget {
  const HospitalCard({super.key, required this.hospital, this.action});

  final HospitalSummary hospital;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final h = hospital;
    final place = [
      ?h.flagEmoji,
      [?h.city, ?h.countryName].join(', '),
      ?h.addressLine,
    ].join(' · ');
    final next = nextChangeLabel(h.opening, DateTime.now());
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(h.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.tiny),
            Text(place, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.small),
            Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.tiny,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (h.opening != null) StatusChip(status: HospitalStyles.opening[h.opening!.state]!),
                StatusChip(status: HospitalStyles.type[h.type]!),
                if (next != null) Text(next, style: theme.textTheme.bodySmall),
              ],
            ),
            if (action != null) ...[const SizedBox(height: AppSpacing.medium), action!],
          ],
        ),
      ),
    );
  }
}
