import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/payroll_styles.dart';
import '../../../constants/texts/payslip_texts.dart';
import '../../../models/workforce/payslip.dart';
import '../../../utilities/accounting/money_format.dart';
import '../../../utilities/time/period.dart';
import '../../common/status/status_chip.dart';

/// A month's payslip in the list; opens its detail.
class PayslipRow extends StatelessWidget {
  const PayslipRow({super.key, required this.payslip, required this.onTap});

  final Payslip payslip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.card,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(monthPeriod(payslip.year, payslip.month), style: theme.textTheme.titleSmall),
                    Text(payslip.hospitalName, style: theme.textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.tiny),
                    StatusChip(status: PayrollStyles.run[payslip.status]!),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(PayslipTexts.net, style: theme.textTheme.bodySmall),
                  Text(formatMoney(payslip.net), style: theme.textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
