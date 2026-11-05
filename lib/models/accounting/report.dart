import 'report_column.dart';
import 'report_row.dart';

/// Server ReportDto: every statement as one table.
class Report {
  const Report({
    required this.title,
    required this.subtitle,
    required this.currency,
    required this.columns,
    required this.rows,
  });

  final String title;
  final String subtitle;
  final String currency;
  final List<ReportColumn> columns;
  final List<ReportRow> rows;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    currency: json['currency'] as String,
    columns: (json['columns'] as List<dynamic>).map((e) => ReportColumn.fromJson(e as Map<String, dynamic>)).toList(),
    rows: (json['rows'] as List<dynamic>).map((e) => ReportRow.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
