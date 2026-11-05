import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/texts/accounting_texts.dart';
import '../../controllers/accounting/books_controller.dart';
import '../../controllers/accounting/journal_controller.dart';
import '../../enums/ui/status_tone.dart';
import '../../models/accounting/journal_entry.dart';
import '../../models/ui/status_style.dart';
import '../../utilities/accounting/money_format.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/status/status_chip.dart';
import '../../widgets/layout/books_page.dart';

const _statusStyles = {
  'DRAFT': StatusStyle(label: AccountingTexts.draft, tone: StatusTone.info, icon: Icons.edit_note_rounded),
  'POSTED': StatusStyle(label: AccountingTexts.posted, tone: StatusTone.success, icon: Icons.task_alt_rounded),
  'REVERSED': StatusStyle(label: AccountingTexts.reversed, tone: StatusTone.neutral, icon: Icons.undo_rounded),
};

/// The journal, newest first; tap an entry to see its lines. Entries are written and posted on the web.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(journalProvider.notifier);
    return BooksPage(
      title: AccountingTexts.journalTitle,
      subtitle: AccountingTexts.journalSubtitle,
      permission: PermissionCodes.journalRead,
      onRefresh: controller.refresh,
      children: [
        PagedList<JournalEntry>(
          value: ref.watch(journalProvider),
          idOf: (e) => e.id,
          emptyIcon: Icons.menu_book_rounded,
          emptyTitle: AccountingTexts.journalEmpty,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (e) => Card.outlined(
            margin: EdgeInsets.zero,
            child: ListTile(
              onTap: () => _open(context, e),
              title: Text(e.description, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${e.entryNumber ?? '—'} · ${e.entryDate}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatMoney(e.totalAmount), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  if (_statusStyles[e.status] case final style?) StatusChip(status: style),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, JournalEntry entry) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => Consumer(
      builder: (context, ref, _) => AsyncBody(
        value: ref.watch(journalEntryProvider(entry.id)),
        data: (full) => full == null ? const SizedBox.shrink() : _EntryLines(entry: full),
      ),
    ),
  );
}

class _EntryLines extends StatelessWidget {
  const _EntryLines({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const numbers = TextStyle(fontFeatures: [FontFeature.tabularFigures()]);
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Text('${entry.entryNumber ?? '—'} · ${entry.periodName}', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(entry.description, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final line in entry.lines)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${line.accountNumber}  ${line.accountName}'),
                      Text(line.hospitalName ?? AccountingTexts.allHospitals, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                SizedBox(
                  width: 96,
                  child: Text(
                    line.debit > 0 ? '${AccountingTexts.debit} ${formatMoney(line.debit)}' : '',
                    textAlign: TextAlign.end,
                    style: numbers,
                  ),
                ),
                SizedBox(
                  width: 96,
                  child: Text(
                    line.credit > 0 ? '${AccountingTexts.credit} ${formatMoney(line.credit)}' : '',
                    textAlign: TextAlign.end,
                    style: numbers,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
