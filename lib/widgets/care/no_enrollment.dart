import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/booking_texts.dart';
import '../../constants/texts/care_mode_texts.dart';
import '../common/feedback/empty_state.dart';

/// Shown on patient screens when the signed-in person is not enrolled at any active Hospital.
class NoEnrollment extends StatelessWidget {
  const NoEnrollment({super.key});

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.domain_disabled_rounded,
    title: BookingTexts.noHospitals,
    hint: BookingTexts.noHospitalsHint,
    action: TextButton(
      onPressed: () => context.push(RoutePaths.hospitals),
      child: const Text(CareModeTexts.hospitals),
    ),
  );
}
