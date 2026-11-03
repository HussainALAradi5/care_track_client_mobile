import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/booking_texts.dart';
import '../../controllers/care/bookings_controller.dart';
import '../../controllers/care/care_team_controller.dart';
import '../../models/care/booking.dart';
import '../../models/ui/confirm_config.dart';
import '../../widgets/care/booking_card.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/confirm_sheet.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/feedback/load_more_footer.dart';
import '../../widgets/common/motion/fade_slide_in.dart';
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
      child: AsyncBody(
        value: bookings,
        onRetry: controller.refresh,
        data: (paged) => paged.items.isEmpty
            ? const EmptyState(icon: Icons.event_note_rounded, title: BookingTexts.emptyList, hint: BookingTexts.emptyListHint)
            : Column(
                children: [
                  for (var i = 0; i < paged.items.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FadeSlideIn(
                        key: ValueKey(paged.items[i].id),
                        index: i,
                        child: BookingCard(
                          booking: paged.items[i],
                          clinicianName: names[paged.items[i].clinicianId] ?? '',
                          onWithdraw: () => _withdraw(context, ref, paged.items[i]),
                        ),
                      ),
                    ),
                  LoadMoreFooter(hasNext: paged.hasNext, onLoadMore: controller.loadMore),
                ],
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
