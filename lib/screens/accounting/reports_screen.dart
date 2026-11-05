import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../constants/texts/accounting_texts.dart';
import '../../controllers/accounting/books_controller.dart';
import '../../enums/accounting/report_kind.dart';
import '../../widgets/accounting/report_view.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/layout/books_page.dart';

/// Statements up to today: pick one; the full report view (dates, hospitals, account statements) is on the web.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportKind _kind = ReportKind.trialBalance;

  @override
  Widget build(BuildContext context) {
    return BooksPage(
      title: AccountingTexts.reportsTitle,
      subtitle: AccountingTexts.reportsSubtitle,
      permission: PermissionCodes.financeReportRead,
      onRefresh: () => ref.refresh(reportProvider(_kind).future),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<ReportKind>(
            showSelectedIcon: false,
            segments: [for (final k in ReportKind.values) ButtonSegment(value: k, label: Text(k.label))],
            selected: {_kind},
            onSelectionChanged: (picked) => setState(() => _kind = picked.first),
          ),
        ),
        const SizedBox(height: 16),
        AsyncBody(
          value: ref.watch(reportProvider(_kind)),
          onRetry: () => ref.invalidate(reportProvider(_kind)),
          data: (report) => report == null ? const SizedBox.shrink() : ReportView(report: report),
        ),
      ],
    );
  }
}
