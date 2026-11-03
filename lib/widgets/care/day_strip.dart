import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/motion.dart';
import '../../constants/scheduling.dart';
import '../../utilities/time/dates.dart';

/// Horizontally scrolling day chips for the next bookable days; the chosen day lifts and fills.
class DayStrip extends StatelessWidget {
  const DayStrip({super.key, required this.selected, required this.today, required this.onSelect});

  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = startOfDay(today);
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Scheduling.bookableDays,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = DateTime(first.year, first.month, first.day + i);
          final active = isSameDay(day, selected);
          final color = active ? scheme.onPrimary : scheme.onSurface;
          return Semantics(
            selected: active,
            button: true,
            child: GestureDetector(
              onTap: () => onSelect(day),
              child: AnimatedContainer(
                duration: Motion.medium,
                curve: Motion.standard,
                width: 60,
                margin: EdgeInsets.only(top: active ? 0 : 4, bottom: active ? 4 : 0),
                decoration: BoxDecoration(
                  color: active ? scheme.primary : scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: active ? scheme.primary : scheme.outlineVariant),
                  boxShadow: active
                      ? [BoxShadow(color: scheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat.E().format(day).toUpperCase(), style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
                    Text('${day.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
                    Text(DateFormat.MMM().format(day), style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
