import 'package:flutter/material.dart';

import '../../constants/texts/booking_texts.dart';
import '../common/feedback/empty_state.dart';

/// Shown on patient screens when the signed-in person is not enrolled at any active Hospital.
class NoEnrollment extends StatelessWidget {
  const NoEnrollment({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
    icon: Icons.domain_disabled_rounded,
    title: BookingTexts.noHospitals,
    hint: BookingTexts.noHospitalsHint,
  );
}
