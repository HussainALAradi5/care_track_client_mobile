import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/staff_request_texts.dart';
import '../../controllers/workforce/my_requests_controller.dart';
import '../../models/ui/confirm_config.dart';
import '../../models/workforce/staff_request.dart';
import '../../widgets/common/feedback/app_snack.dart';
import '../../widgets/common/feedback/confirm_sheet.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/staff_request_form.dart';
import '../../widgets/workforce/staff_request_row.dart';

/// The signed-in person's requests to HR: raise a new one, follow the answer, cancel one still waiting.
class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(myRequestsProvider.notifier);
    return StaffPage(
      title: StaffRequestTexts.title,
      subtitle: StaffRequestTexts.subtitle,
      onRefresh: controller.refresh,
      children: [
        const StaffRequestForm(),
        const SizedBox(height: 12),
        PagedList<StaffRequest>(
          value: ref.watch(myRequestsProvider),
          idOf: (r) => r.id,
          emptyIcon: Icons.assignment_outlined,
          emptyTitle: StaffRequestTexts.empty,
          emptyHint: StaffRequestTexts.emptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (r) => StaffRequestRow(request: r, onCancel: () => _cancel(context, controller, r)),
        ),
      ],
    );
  }

  Future<void> _cancel(BuildContext context, MyRequestsController controller, StaffRequest request) async {
    const config = ConfirmConfig(
      title: StaffRequestTexts.cancelTitle,
      message: StaffRequestTexts.cancelBody,
      confirmLabel: StaffRequestTexts.cancel,
      danger: true,
    );
    if (!await showConfirmSheet(context, config)) return;
    await controller.cancel(request);
    if (context.mounted) AppSnack.success(context, StaffRequestTexts.cancelled);
  }
}
