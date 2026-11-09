import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/team_texts.dart';
import '../../controllers/workforce/team_controller.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/team/department_tile.dart';

/// The caller's colleagues in the departments they work in, read-only.
class DepartmentScreen extends ConsumerWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => StaffPage(
    title: TeamTexts.departmentTitle,
    subtitle: TeamTexts.departmentSubtitle,
    onRefresh: () async => ref.refresh(myDepartmentsProvider.future),
    children: [
      AsyncBody(
        value: ref.watch(myDepartmentsProvider),
        onRetry: () => ref.invalidate(myDepartmentsProvider),
        data: (departments) => departments.isEmpty
            ? const EmptyState(
                icon: Icons.account_tree_rounded,
                title: TeamTexts.departmentEmpty,
                hint: TeamTexts.departmentEmptyHint,
              )
            : Column(children: [for (final d in departments) DepartmentTile(department: d)]),
      ),
    ],
  );
}
