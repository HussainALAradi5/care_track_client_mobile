import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/texts/accounting_texts.dart';
import '../../controllers/accounting/books_controller.dart';
import '../../models/accounting/month_summary.dart';
import '../../widgets/accounting/money_tile.dart';
import '../../widgets/accounting/top_accounts_list.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/progress/stat_tile.dart';
import '../../widgets/layout/books_page.dart';

/// The accountant's start screen: the month next to the month before, and its largest accounts.
class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BooksPage(
      title: AccountingTexts.booksTitle,
      subtitle: AccountingTexts.booksSubtitle,
      permission: PermissionCodes.accountRead,
      onRefresh: () async {
        ref.invalidate(booksStatusProvider);
        await ref.read(monthSummaryProvider.future);
      },
      children: [
        AsyncBody(
          value: ref.watch(monthSummaryProvider),
          onRetry: () => ref.invalidate(monthSummaryProvider),
          data: (summary) => summary == null
              ? const EmptyState(
                  icon: Icons.menu_book_rounded,
                  title: AccountingTexts.notSetUp,
                  hint: AccountingTexts.notSetUpHint,
                )
              : _Summary(summary: summary),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary});

  final MonthSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    Widget tile(String label, double amount, double previous, IconData icon, {bool lowerIsBetter = false}) => MoneyTile(
      label: label,
      amount: amount,
      previous: previous,
      previousMonth: s.previousMonth,
      currency: s.currency,
      icon: icon,
      lowerIsBetter: lowerIsBetter,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            tile(AccountingTexts.revenue, s.revenue, s.previousRevenue, Icons.trending_up_rounded),
            tile(
              AccountingTexts.expenses,
              s.expenses,
              s.previousExpenses,
              Icons.trending_down_rounded,
              lowerIsBetter: true,
            ),
            tile(AccountingTexts.netResult, s.netResult, s.previousNetResult, Icons.savings_rounded),
            tile(
              AccountingTexts.cashAndBank,
              s.cashAndBank,
              s.previousCashAndBank,
              Icons.account_balance_wallet_rounded,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: AccountingTexts.entriesPosted,
                value: s.entriesPosted,
                icon: Icons.task_alt_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(label: AccountingTexts.drafts, value: s.draftEntries, icon: Icons.edit_note_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TopAccountsList(title: AccountingTexts.topRevenue, lines: s.topRevenue),
        const SizedBox(height: 12),
        TopAccountsList(title: AccountingTexts.topExpenses, lines: s.topExpenses),
      ],
    );
  }
}
