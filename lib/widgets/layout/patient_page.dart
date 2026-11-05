import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/care/patient_context_controller.dart';
import '../care/no_enrollment.dart';
import '../common/feedback/async_body.dart';
import 'page_heading.dart';

/// Scrollable patient page with pull-to-refresh and a title; shows the not-enrolled state when there is
/// no Hospital, so each screen only builds its own content.
class PatientPage extends ConsumerWidget {
  const PatientPage({
    super.key,
    required this.title,
    required this.child,
    required this.onRefresh,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Future<void> Function() onRefresh;
  final Widget? action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientContextProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(patientContextProvider);
        await onRefresh();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          PageHeading(title: title, subtitle: subtitle, action: action),
          const SizedBox(height: 16),
          AsyncBody(
            value: patient,
            onRetry: () => ref.invalidate(patientContextProvider),
            data: (value) => value.hospital == null ? const NoEnrollment() : child,
          ),
        ],
      ),
    );
  }
}
