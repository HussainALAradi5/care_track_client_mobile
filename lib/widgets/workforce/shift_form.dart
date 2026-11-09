import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/shift_rules.dart';
import '../../constants/texts/shift_texts.dart';
import '../../controllers/ui/clock_controller.dart';
import '../../controllers/workforce/shifts_controller.dart';
import '../../dtos/workforce/create_shift_request.dart';
import '../../models/workforce/shift_clinician.dart';
import '../../utilities/time/dates.dart';
import '../../utilities/workforce/shift_interval.dart';
import '../common/buttons/app_button.dart';
import '../common/feedback/app_snack.dart';
import '../common/inputs/picker_field.dart';
import '../common/pickers/app_pickers.dart';
import 'shift_preview.dart';
import 'shift_quick_starts.dart';

/// Add a shift: who, the day (calendar from today), the start (one-tap usual starts or the clock picker) and
/// the length, with a live preview that refuses a start in the past.
class ShiftForm extends ConsumerStatefulWidget {
  const ShiftForm({super.key, required this.clinicians});

  final List<ShiftClinician> clinicians;

  @override
  ConsumerState<ShiftForm> createState() => _ShiftFormState();
}

class _ShiftFormState extends ConsumerState<ShiftForm> {
  String? _clinicianId;
  late DateTime _day = startOfDay(DateTime.now()).add(const Duration(days: 1));
  TimeOfDay _time = ShiftRules.defaultStart;
  int _hours = ShiftRules.defaultHours;

  Future<void> _pickDay() async {
    final today = startOfDay(DateTime.now());
    final picked = await AppPickers.date(
      context,
      initialDate: _day.isBefore(today) ? today : _day,
      firstDate: today,
      lastDate: today.add(const Duration(days: ShiftRules.plannableDays)),
    );
    if (picked != null) setState(() => _day = picked);
  }

  Future<void> _pickTime() async {
    final picked = await AppPickers.time(context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _add() async {
    final interval = shiftInterval(_day, _time, _hours);
    await ref
        .read(shiftsProvider.notifier)
        .add(CreateShiftRequest(clinicianId: _clinicianId!, startsAt: interval.startsAt, endsAt: interval.endsAt));
    if (mounted) AppSnack.success(context, ShiftTexts.added);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final interval = shiftInterval(_day, _time, _hours);
    final inPast = !interval.startsAt.isAfter(ref.watch(nowProvider));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(ShiftTexts.addTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (widget.clinicians.isEmpty)
              Text(ShiftTexts.noClinicians, style: muted)
            else
              DropdownButtonFormField<String>(
                initialValue: _clinicianId,
                decoration: const InputDecoration(labelText: ShiftTexts.clinician),
                items: [for (final c in widget.clinicians) DropdownMenuItem(value: c.id, child: Text(c.name))],
                onChanged: (id) => setState(() => _clinicianId = id),
              ),
            const SizedBox(height: 12),
            PickerField(
              label: ShiftTexts.date,
              value: longDate(_day),
              icon: Icons.calendar_month_rounded,
              onTap: _pickDay,
            ),
            const SizedBox(height: 12),
            ShiftQuickStarts(selected: _time, onPick: (time) => setState(() => _time = time)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PickerField(
                    label: ShiftTexts.start,
                    value: hourMinute(_time),
                    icon: Icons.schedule_rounded,
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _hours,
                    decoration: const InputDecoration(labelText: ShiftTexts.length),
                    items: [
                      for (final h in ShiftRules.lengthOptions)
                        DropdownMenuItem(value: h, child: Text(ShiftTexts.hours(h))),
                    ],
                    onChanged: (h) => setState(() => _hours = h ?? _hours),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ShiftPreview(startsAt: interval.startsAt, endsAt: interval.endsAt, inPast: inPast),
            if (_clinicianId == null && widget.clinicians.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(ShiftTexts.pickClinician, style: muted),
            ],
            const SizedBox(height: 12),
            AppButton(
              label: ShiftTexts.add,
              icon: Icons.add_rounded,
              expand: true,
              onPressed: _clinicianId != null && !inPast ? _add : null,
            ),
          ],
        ),
      ),
    );
  }
}
