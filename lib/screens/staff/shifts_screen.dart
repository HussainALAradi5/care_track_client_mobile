import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/texts/shift_texts.dart';
import '../../controllers/ui/clock_controller.dart';
import '../../controllers/workforce/shift_filter_controller.dart';
import '../../controllers/workforce/shifts_controller.dart';
import '../../models/ui/confirm_config.dart';
import '../../models/workforce/clinician_shift.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/confirm_sheet.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/shift_form.dart';
import '../../widgets/workforce/shift_row.dart';

/// Shift planning: add a doctor's or nurse's hours, see who works next, remove a shift before it starts.
class ShiftsScreen extends ConsumerWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(shiftsProvider.notifier);
    final clinicians = ref.watch(shiftCliniciansProvider);
    final filter = ref.watch(shiftFilterProvider);
    final now = ref.watch(nowProvider);
    return StaffPage(
      title: ShiftTexts.title,
      subtitle: ShiftTexts.subtitle,
      permission: PermissionCodes.shiftWrite,
      onRefresh: () async {
        ref.invalidate(shiftCliniciansProvider);
        await controller.refresh();
      },
      children: [
        AsyncBody(
          value: clinicians,
          skeletonRows: 1,
          onRetry: () => ref.invalidate(shiftCliniciansProvider),
          data: (people) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShiftForm(clinicians: people),
              const SizedBox(height: 16),
              if (people.length > 1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final entry in <String?, String>{
                        null: ShiftTexts.everyone,
                        for (final p in people) p.id: p.name,
                      }.entries)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(entry.value),
                            selected: filter == entry.key,
                            onSelected: (_) => ref.read(shiftFilterProvider.notifier).select(entry.key),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PagedList<ClinicianShift>(
          value: ref.watch(shiftsProvider),
          idOf: (s) => s.id,
          emptyIcon: Icons.schedule_rounded,
          emptyTitle: ShiftTexts.empty,
          emptyHint: ShiftTexts.emptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (s) => ShiftRow(shift: s, now: now, onRemove: () => _remove(context, controller, s)),
        ),
      ],
    );
  }

  Future<void> _remove(BuildContext context, ShiftsController controller, ClinicianShift shift) async {
    const config = ConfirmConfig(
      title: ShiftTexts.removeTitle,
      message: ShiftTexts.removeBody,
      confirmLabel: ShiftTexts.remove,
      danger: true,
    );
    if (!await showConfirmSheet(context, config)) return;
    await controller.remove(shift);
    if (context.mounted) AppSnack.success(context, ShiftTexts.removed);
  }
}
