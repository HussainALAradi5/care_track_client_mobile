import 'package:flutter/material.dart';

import '../../constants/texts/accounting_texts.dart';
import '../../models/accounting/amount_line.dart';
import '../../utilities/accounting/money_format.dart';

/// One of the books screen's cards: the accounts that moved the most this month.
class TopAccountsList extends StatelessWidget {
  const TopAccountsList({super.key, required this.title, required this.lines});

  final String title;
  final List<AmountLine> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            if (lines.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(AccountingTexts.nothingYet, style: theme.textTheme.bodySmall),
              ),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(line.name, overflow: TextOverflow.ellipsis)),
                    Text(
                      formatMoney(line.amount),
                      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
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
