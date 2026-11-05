import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/identity/staff_context_controller.dart';
import 'hospital_menu.dart';

/// Staff app bar title: the Hospital the staff screens work in, switchable when the person works at several.
class StaffHospitalSwitcher extends ConsumerWidget {
  const StaffHospitalSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(staffContextProvider).value;
    final hospital = staff?.hospital;
    return HospitalMenu(
      selectedName: hospital?.name,
      selectedId: hospital?.hospitalId,
      options: {for (final h in staff?.hospitals ?? const []) h.hospitalId: h.name},
      onSelect: (id) => ref.read(staffContextProvider.notifier).select(id),
    );
  }
}
