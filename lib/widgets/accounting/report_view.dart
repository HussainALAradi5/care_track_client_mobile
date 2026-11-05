import 'package:flutter/material.dart';

import '../../models/accounting/report.dart';
import '../../utilities/accounting/money_format.dart';

/// A statement as a phone-friendly list: section headings, account lines with their amounts, and bold totals.
/// The account column and the money columns come from the report itself, so every statement uses this view.
class ReportView extends StatelessWidget {
  const ReportView({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final money = report.columns.where((c) => c.money).toList();
    final numbers = const [FontFeature.tabularFigures()];
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(report.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('${report.subtitle} · ${report.currency}', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            if (money.length > 1)
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  for (final c in money)
                    SizedBox(
                      width: 92,
                      child: Text(c.label, textAlign: TextAlign.end, style: theme.textTheme.labelSmall),
                    ),
                ],
              ),
            for (final row in report.rows)
              if (row.isGroup)
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 4),
                  child: Text(
                    row.values['account'] ?? '',
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: row.isTotal ? BorderSide(color: scheme.outline, width: 1.5) : BorderSide.none,
                      bottom: row.isTotal
                          ? BorderSide.none
                          : BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            if (row.values['number'] != null) row.values['number'],
                            row.values['account'] ?? '',
                          ].join('  '),
                          style: row.isTotal ? const TextStyle(fontWeight: FontWeight.w700) : null,
                        ),
                      ),
                      for (final c in money)
                        SizedBox(
                          width: 92,
                          child: Text(
                            formatMoney(row.values[c.key]),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFeatures: numbers,
                              fontWeight: row.isTotal ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
