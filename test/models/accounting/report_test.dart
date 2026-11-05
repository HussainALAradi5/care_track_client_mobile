import 'package:care_track_client_mobile/models/accounting/journal_entry.dart';
import 'package:care_track_client_mobile/models/accounting/month_summary.dart';
import 'package:care_track_client_mobile/models/accounting/report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a ReportDto with headings, lines and totals', () {
    final report = Report.fromJson({
      'title': 'Income statement',
      'subtitle': '2026-01-01 to 2026-11-05',
      'currency': 'BHD',
      'columns': [
        {'key': 'number', 'label': 'No.', 'type': 'TEXT'},
        {'key': 'account', 'label': 'Account', 'type': 'TEXT'},
        {'key': 'amount', 'label': 'Amount', 'type': 'MONEY'},
      ],
      'rows': [
        {
          'kind': 'GROUP',
          'accountId': null,
          'values': {'account': 'Revenue'},
        },
        {
          'kind': 'LINE',
          'accountId': 'a1',
          'values': {'number': '4100', 'account': 'Consultation', 'amount': '250.000'},
        },
        {
          'kind': 'TOTAL',
          'accountId': null,
          'values': {'account': 'Total revenue', 'amount': '250.000'},
        },
      ],
    });
    expect(report.columns.where((c) => c.money).map((c) => c.key), ['amount']);
    expect(report.rows.first.isGroup, isTrue);
    expect(report.rows.last.isTotal, isTrue);
    expect(report.rows[1].values['amount'], '250.000');
  });

  test('parses a MonthSummaryDto and a JournalEntryDto', () {
    final summary = MonthSummary.fromJson({
      'month': '2026-11',
      'previousMonth': '2026-10',
      'currency': 'BHD',
      'revenue': 250,
      'previousRevenue': 0,
      'expenses': 0,
      'previousExpenses': 0,
      'netResult': 250,
      'previousNetResult': 0,
      'cashAndBank': 250,
      'previousCashAndBank': 0,
      'entriesPosted': 1,
      'draftEntries': 0,
      'topRevenue': [
        {'accountId': 'a1', 'name': 'Consultation', 'amount': 250.0},
      ],
      'topExpenses': [],
    });
    expect(summary.revenue, 250.0);
    expect(summary.topRevenue.single.name, 'Consultation');

    final entry = JournalEntry.fromJson({
      'id': 'e1',
      'entryNumber': null,
      'entryDate': '2026-11-05',
      'periodName': '2026-11',
      'type': 'MANUAL',
      'status': 'DRAFT',
      'description': 'Consultations',
      'totalAmount': 100.5,
      'lines': [
        {'id': 'l1', 'accountNumber': '1110', 'accountName': 'Cash', 'hospitalName': null, 'debit': 100.5, 'credit': 0},
      ],
    });
    expect(entry.entryNumber, isNull);
    expect(entry.lines.single.debit, 100.5);
  });
}
