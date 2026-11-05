import 'package:flutter/material.dart';

import '../../constants/texts/accounting_texts.dart';
import '../../utilities/accounting/money_format.dart';

/// An amount with its currency and the change against the month before (up is good unless [lowerIsBetter]).
class MoneyTile extends StatelessWidget {
  const MoneyTile({
    super.key,
    required this.label,
    required this.amount,
    required this.previous,
    required this.previousMonth,
    required this.currency,
    required this.icon,
    this.lowerIsBetter = false,
  });

  final String label;
  final double amount;
  final double previous;
  final String previousMonth;
  final String currency;
  final IconData icon;
  final bool lowerIsBetter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final change = amount - previous;
    final good = lowerIsBetter ? change <= 0 : change >= 0;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label, style: theme.textTheme.labelMedium, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatMoney(amount)} $currency',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${change >= 0 ? '▲' : '▼'} ${formatMoney(change.abs())} ${AccountingTexts.versus(previousMonth)}',
              style: theme.textTheme.bodySmall?.copyWith(color: good ? Colors.green.shade700 : scheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
