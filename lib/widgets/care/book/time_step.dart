import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/care/booking_draft_controller.dart';
import '../../../controllers/ui/clock_controller.dart';
import '../slot_picker.dart';

/// Step 3: day, length and start time.
class TimeStep extends ConsumerWidget {
  const TimeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final controller = ref.read(bookingDraftProvider.notifier);
    return SlotPicker(
      day: draft.day,
      durationMinutes: draft.durationMinutes,
      selected: draft.slot,
      now: ref.watch(nowProvider),
      onDay: controller.chooseDay,
      onDuration: controller.chooseDuration,
      onSlot: controller.chooseSlot,
    );
  }
}
