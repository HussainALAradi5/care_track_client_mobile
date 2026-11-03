import 'package:flutter/material.dart';

import '../../constants/scheduling.dart';
import '../../constants/texts/booking_texts.dart';
import '../../models/care/time_slot.dart';
import '../../utilities/time/slots.dart';
import '../common/motion/fade_slide_in.dart';
import 'day_strip.dart';
import 'slot_chip.dart';

/// Day strip, length choice and a grid of start times; past times stay visible but disabled.
class SlotPicker extends StatelessWidget {
  const SlotPicker({
    super.key,
    required this.day,
    required this.durationMinutes,
    required this.selected,
    required this.now,
    required this.onDay,
    required this.onDuration,
    required this.onSlot,
  });

  final DateTime day;
  final int durationMinutes;
  final TimeSlot? selected;
  final DateTime now;
  final ValueChanged<DateTime> onDay;
  final ValueChanged<int> onDuration;
  final ValueChanged<TimeSlot> onSlot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final slots = daySlots(day, durationMinutes, now);
    final anyFree = slots.any((s) => !s.past);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DayStrip(selected: day, today: now, onSelect: onDay),
        const SizedBox(height: 16),
        Text(BookingTexts.duration, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: [
            for (final m in Scheduling.durationOptions) ButtonSegment(value: m, label: Text(BookingTexts.minutes(m))),
          ],
          selected: {durationMinutes},
          onSelectionChanged: (value) => onDuration(value.first),
        ),
        const SizedBox(height: 16),
        if (!anyFree)
          Row(
            children: [
              Icon(Icons.event_busy_rounded, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(BookingTexts.noSlots, style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < slots.length; i++)
                FadeSlideIn(
                  key: ValueKey('${day.day}-$durationMinutes-$i'),
                  index: i,
                  child: SlotChip(
                    slot: slots[i],
                    selected: selected?.startsAt == slots[i].startsAt,
                    onTap: () => onSlot(slots[i]),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
