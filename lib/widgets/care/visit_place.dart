import 'package:flutter/material.dart';

import '../../models/care/appointment.dart';
import '../../utilities/care/visit_place.dart';
import '../common/status/status_chip.dart';

/// Where a visit happens as a wrap of badges: Hospital, the clinician's department and the room (planned until the
/// visit starts in it). Used on the patient's appointment cards, the desk and the clinician's visits.
class VisitPlace extends StatelessWidget {
  const VisitPlace({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [for (final badge in visitPlaceBadges(appointment)) StatusChip(status: badge)],
  );
}
