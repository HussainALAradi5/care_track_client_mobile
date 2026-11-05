import '../../constants/texts/accounting_texts.dart';

/// The statements the reports screen offers; [path] is the server's report path.
enum ReportKind {
  trialBalance('trial-balance', AccountingTexts.trialBalance, asOf: true),
  incomeStatement('income-statement', AccountingTexts.incomeStatement, asOf: false),
  balanceSheet('balance-sheet', AccountingTexts.balanceSheet, asOf: true);

  const ReportKind(this.path, this.label, {required this.asOf});
  final String path;
  final String label;

  /// As-of statements take one date; the others a range.
  final bool asOf;
}
