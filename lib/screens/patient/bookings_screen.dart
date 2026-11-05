import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/booking_texts.dart';
import '../../controllers/care/bookings_controller.dart';
import '../../controllers/care/care_team_controller.dart';
import '../../models/care/booking.dart';
import '../../models/ui/confirm_config.dart';
import '../../widgets/care/booking_card.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/confirm_sheet.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/layout/patient_page.dart';

/// The patient's booking requests, newest first, with withdraw while still waiting.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);
    final names = ref.watch(clinicianNamesProvider);
    final controller = ref.read(bookingsProvider.notifier);
    return PatientPage(
      title: BookingTexts.listTitle,
      onRefresh: controller.refresh,
      child: PagedList<Booking>(
        value: bookings,
        idOf: (item) => item.id,
        emptyIcon: Icons.event_note_rounded,
        emptyTitle: BookingTexts.emptyList,
        emptyHint: BookingTexts.emptyListHint,
        onRetry: controller.refresh,
        onLoadMore: controller.loadMore,
        itemBuilder: (item) => BookingCard(
          booking: item,
          clinicianName: names[item.clinicianId] ?? '',
          onWithdraw: () => _withdraw(context, ref, item),
        ),
      ),
    );
  }

  Future<void> _withdraw(BuildContext context, WidgetRef ref, Booking booking) async {
    const config = ConfirmConfig(
      title: BookingTexts.cancelTitle,
      message: BookingTexts.cancelBody,
      confirmLabel: BookingTexts.withdraw,
      danger: true,
    );
    if (!await showConfirmSheet(context, config)) return;
    await ref.read(bookingsProvider.notifier).withdraw(booking);
    if (context.mounted) AppSnack.success(context, BookingTexts.cancelled);
  }
}
