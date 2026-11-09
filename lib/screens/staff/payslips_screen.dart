import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../constants/texts/payslip_texts.dart';
import '../../controllers/workforce/payslips_controller.dart';
import '../../models/workforce/payslip.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/payslips/payslip_row.dart';

/// The caller's pay each month, once HR approves it.
class PayslipsScreen extends ConsumerWidget {
  const PayslipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(payslipsProvider.notifier);
    return StaffPage(
      title: PayslipTexts.title,
      subtitle: PayslipTexts.subtitle,
      onRefresh: controller.refresh,
      children: [
        PagedList<Payslip>(
          value: ref.watch(payslipsProvider),
          idOf: (p) => p.id,
          emptyIcon: Icons.receipt_long_rounded,
          emptyTitle: PayslipTexts.emptyTitle,
          emptyHint: PayslipTexts.emptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (p) => PayslipRow(payslip: p, onTap: () => context.push(RoutePaths.staffPayslip(p.id))),
        ),
      ],
    );
  }
}
