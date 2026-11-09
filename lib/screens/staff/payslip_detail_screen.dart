import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_spacing.dart';
import '../../constants/payroll_styles.dart';
import '../../controllers/workforce/payslips_controller.dart';
import '../../utilities/time/period.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/status/status_chip.dart';
import '../../widgets/layout/page_heading.dart';
import '../../widgets/workforce/payslips/payslip_lines.dart';

/// One month's pay with its lines.
class PayslipDetailScreen extends ConsumerWidget {
  const PayslipDetailScreen({super.key, required this.payslipId});

  final String payslipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(payslipProvider(payslipId)),
    onRetry: () => ref.invalidate(payslipProvider(payslipId)),
    data: (p) => ListView(
      padding: AppSpacing.page,
      children: [
        PageHeading(title: monthPeriod(p.year, p.month), subtitle: p.hospitalName),
        const SizedBox(height: AppSpacing.small),
        Align(alignment: Alignment.centerLeft, child: StatusChip(status: PayrollStyles.run[p.status]!)),
        const SizedBox(height: AppSpacing.medium),
        PayslipLines(payslip: p),
      ],
    ),
  );
}
