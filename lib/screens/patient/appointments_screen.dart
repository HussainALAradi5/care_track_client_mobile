import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/scheduling.dart';
import '../../constants/texts/appointment_texts.dart';
import '../../controllers/care/appointments_controller.dart';
import '../../controllers/care/care_team_controller.dart';
import '../../controllers/ui/clock_controller.dart';
import '../../models/care/appointment.dart';
import '../../models/ui/confirm_config.dart';
import '../../widgets/care/appointment_card.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/feedback/reason_sheet.dart';
import '../../widgets/layout/patient_page.dart';

/// Confirmed visits with the remaining free-cancellation time and cancel-with-reason.
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final names = ref.watch(clinicianNamesProvider);
    final now = ref.watch(nowProvider);
    final controller = ref.read(appointmentsProvider.notifier);
    return PatientPage(
      title: AppointmentTexts.listTitle,
      onRefresh: controller.refresh,
      child: PagedList<Appointment>(
        value: appointments,
        idOf: (item) => item.id,
        emptyIcon: Icons.calendar_month_rounded,
        emptyTitle: AppointmentTexts.empty,
        emptyHint: AppointmentTexts.emptyHint,
        onRetry: controller.refresh,
        onLoadMore: controller.loadMore,
        itemBuilder: (item) => AppointmentCard(
          appointment: item,
          clinicianName: names[item.clinicianId] ?? '',
          now: now,
          onCancel: () => _cancel(context, ref, item),
        ),
      ),
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, Appointment appointment) async {
    const config = ConfirmConfig(
      title: AppointmentTexts.cancelTitle,
      message: AppointmentTexts.cancelBody,
      confirmLabel: AppointmentTexts.cancelConfirm,
      danger: true,
    );
    final reason = await showReasonSheet(
      context,
      config,
      reasonLabel: AppointmentTexts.cancelReason,
      maxLength: Scheduling.reasonMaxLength,
    );
    if (reason == null) return;
    await ref.read(appointmentsProvider.notifier).cancel(appointment, reason);
    if (context.mounted) AppSnack.success(context, AppointmentTexts.cancelled);
  }
}
