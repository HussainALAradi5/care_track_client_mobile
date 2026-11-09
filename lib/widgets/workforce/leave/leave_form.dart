import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/leave_rules.dart';
import '../../../constants/texts/leave_texts.dart';
import '../../../controllers/workforce/leave_form_controller.dart';
import '../../../models/workforce/leave_balance.dart';
import '../../../utilities/time/dates.dart';
import '../../common/buttons/app_button.dart';
import '../../common/display/section_card.dart';
import '../../common/feedback/app_snack.dart';
import '../../common/inputs/picker_field.dart';
import '../../common/pickers/app_pickers.dart';
import 'sick_note_banner.dart';

/// Ask for leave: type, first and last day, optional reason, with the days counted as they are chosen.
class LeaveForm extends ConsumerWidget {
  const LeaveForm({super.key, required this.balances});

  final List<LeaveBalance> balances;

  Future<void> _pickDay(BuildContext context, DateTime? current, DateTime first, ValueChanged<DateTime> onPicked) async {
    final picked = await AppPickers.date(
      context,
      initialDate: current ?? first,
      firstDate: first,
      lastDate: DateTime(first.year + LeaveRules.maxYearsAhead, 12, 31),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _ask(BuildContext context, LeaveFormController form) async {
    await form.ask();
    if (context.mounted) AppSnack.success(context, LeaveTexts.asked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(leaveFormProvider);
    final form = ref.read(leaveFormProvider.notifier);
    final earliest = startOfDay(DateTime.now()).subtract(const Duration(days: LeaveRules.daysBack));
    final problem = form.problem(balances);
    final ready = draft.leaveTypeId != null && form.chosenDays > 0 && problem == null;
    return SectionCard(
      title: LeaveTexts.askTitle,
      children: [
        if (draft.sickNote != null) ...[
          SickNoteBanner(note: draft.sickNote!, onRemove: form.removeSickNote),
          const SizedBox(height: AppSpacing.medium),
        ],
        DropdownButtonFormField<String>(
          key: ValueKey(draft.leaveTypeId),
          initialValue: draft.leaveTypeId,
          decoration: const InputDecoration(labelText: LeaveTexts.type),
          items: [for (final b in balances) DropdownMenuItem(value: b.leaveTypeId, child: Text(b.name))],
          onChanged: form.setType,
        ),
        const SizedBox(height: AppSpacing.medium),
        PickerField(
          label: LeaveTexts.start,
          value: draft.start == null ? LeaveTexts.chooseDay : longDate(draft.start!),
          icon: Icons.event_rounded,
          onTap: () => _pickDay(context, draft.start, earliest, form.setStart),
        ),
        const SizedBox(height: AppSpacing.medium),
        PickerField(
          label: LeaveTexts.end,
          value: draft.end == null ? LeaveTexts.chooseDay : longDate(draft.end!),
          icon: Icons.event_rounded,
          onTap: () => _pickDay(context, draft.end, draft.start ?? earliest, form.setEnd),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          key: ValueKey(draft.sickNote == null && draft.start == null ? 'empty' : 'filled'),
          maxLength: LeaveRules.noteMax,
          decoration: const InputDecoration(labelText: LeaveTexts.reason),
          onChanged: form.setReason,
        ),
        if (form.chosenDays > 0) Text(LeaveTexts.days(form.chosenDays)),
        if (problem != null) Text(problem, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        const SizedBox(height: AppSpacing.small),
        AppButton(
          label: LeaveTexts.ask,
          icon: Icons.flight_takeoff_rounded,
          expand: true,
          onPressed: ready ? () => _ask(context, form) : null,
        ),
      ],
    );
  }
}
