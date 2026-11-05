import 'amount_line.dart';

/// Server MonthSummaryDto: the month next to the month before.
class MonthSummary {
  const MonthSummary({
    required this.month,
    required this.previousMonth,
    required this.currency,
    required this.revenue,
    required this.previousRevenue,
    required this.expenses,
    required this.previousExpenses,
    required this.netResult,
    required this.previousNetResult,
    required this.cashAndBank,
    required this.previousCashAndBank,
    required this.entriesPosted,
    required this.draftEntries,
    required this.topRevenue,
    required this.topExpenses,
  });

  final String month;
  final String previousMonth;
  final String currency;
  final double revenue;
  final double previousRevenue;
  final double expenses;
  final double previousExpenses;
  final double netResult;
  final double previousNetResult;
  final double cashAndBank;
  final double previousCashAndBank;
  final int entriesPosted;
  final int draftEntries;
  final List<AmountLine> topRevenue;
  final List<AmountLine> topExpenses;

  static double _money(Object? value) => (value as num).toDouble();
  static List<AmountLine> _lines(Object? value) =>
      (value as List<dynamic>).map((e) => AmountLine.fromJson(e as Map<String, dynamic>)).toList();

  factory MonthSummary.fromJson(Map<String, dynamic> json) => MonthSummary(
    month: json['month'] as String,
    previousMonth: json['previousMonth'] as String,
    currency: json['currency'] as String,
    revenue: _money(json['revenue']),
    previousRevenue: _money(json['previousRevenue']),
    expenses: _money(json['expenses']),
    previousExpenses: _money(json['previousExpenses']),
    netResult: _money(json['netResult']),
    previousNetResult: _money(json['previousNetResult']),
    cashAndBank: _money(json['cashAndBank']),
    previousCashAndBank: _money(json['previousCashAndBank']),
    entriesPosted: (json['entriesPosted'] as num).toInt(),
    draftEntries: (json['draftEntries'] as num).toInt(),
    topRevenue: _lines(json['topRevenue']),
    topExpenses: _lines(json['topExpenses']),
  );
}
