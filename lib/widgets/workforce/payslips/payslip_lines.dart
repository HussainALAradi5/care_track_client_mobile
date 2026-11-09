import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/payslip_texts.dart';
import '../../../models/workforce/payslip.dart';
import '../../../models/workforce/payslip_line.dart';
import '../../../utilities/accounting/money_format.dart';
import '../../common/display/section_card.dart';

/// A payslip's figures and each of its lines.
class PayslipLines extends StatelessWidget {
  const PayslipLines({super.key, required this.payslip});

  final Payslip payslip;

  Widget _figure(BuildContext context, String label, num amount, {bool strong = false}) {
    final style = strong ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.tiny),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Flexible(child: Text(label, style: style)), Text(formatMoney(amount), style: style)],
      ),
    );
  }

  String _lineLabel(PayslipLine line) =>
      line.days == null ? line.label : '${line.label} · ${PayslipTexts.days(line.days!)}';

  @override
  Widget build(BuildContext context) {
    final p = payslip;
    return SectionCard(
      title: PayslipTexts.lines,
      children: [
        _figure(context, PayslipTexts.basic, p.basic),
        _figure(context, PayslipTexts.allowances, p.allowances),
        _figure(context, PayslipTexts.deductions, p.deductions),
        _figure(context, PayslipTexts.adjustments, p.adjustments),
        const Divider(),
        for (final line in p.lines) _figure(context, _lineLabel(line), line.amount),
        if (p.unpaidLeaveDays > 0) Text(PayslipTexts.unpaidLeave(p.unpaidLeaveDays)),
        if (p.absentDays > 0) Text(PayslipTexts.absent(p.absentDays)),
        const Divider(),
        _figure(context, PayslipTexts.net, p.net, strong: true),
      ],
    );
  }
}
