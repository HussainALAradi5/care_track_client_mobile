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
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/feedback/load_more_footer.dart';
import '../../widgets/common/feedback/reason_sheet.dart';
import '../../widgets/common/motion/fade_slide_in.dart';
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
      child: AsyncBody(
        value: appointments,
        onRetry: controller.refresh,
        data: (paged) => paged.items.isEmpty
            ? const EmptyState(icon: Icons.calendar_month_rounded, title: AppointmentTexts.empty, hint: AppointmentTexts.emptyHint)
            : Column(
                children: [
                  for (var i = 0; i < paged.items.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FadeSlideIn(
                        key: ValueKey(paged.items[i].id),
                        index: i,
                        child: AppointmentCard(
                          appointment: paged.items[i],
                          clinicianName: names[paged.items[i].clinicianId] ?? '',
                          now: now,
                          onCancel: () => _cancel(context, ref, paged.items[i]),
                        ),
                      ),
                    ),
                  LoadMoreFooter(hasNext: paged.hasNext, onLoadMore: controller.loadMore),
                ],
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
