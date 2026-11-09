import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/staff_nav.dart';
import '../../constants/texts/staff_texts.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/layout/page_heading.dart';

/// Where staff land: it opens their first permitted screen at the selected Hospital (My requests is open to all).
class StaffOverviewScreen extends ConsumerWidget {
  const StaffOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(staffContextProvider);
    final hospital = staff.value?.hospital;
    final first = StaffNav.items.where((item) => item.isOpenAt(hospital)).firstOrNull;
    if (first != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(first.path);
      });
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PageHeading(title: hospital?.name ?? StaffTexts.overviewTitle),
        const SizedBox(height: 16),
        AsyncBody(
          value: staff,
          onRetry: () => ref.invalidate(staffContextProvider),
          data: (value) => value.hospital == null
              ? const EmptyState(
                  icon: Icons.badge_rounded,
                  title: StaffTexts.noStaffHospital,
                  hint: StaffTexts.noStaffHospitalHint,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
