/// One report row: a heading (GROUP), an account line (LINE) or a total (TOTAL), with text values by column key.
class ReportRow {
  const ReportRow({required this.kind, required this.values});

  final String kind;
  final Map<String, String> values;

  bool get isGroup => kind == 'GROUP';
  bool get isTotal => kind == 'TOTAL';

  factory ReportRow.fromJson(Map<String, dynamic> json) => ReportRow(
    kind: json['kind'] as String,
    values: (json['values'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String)),
  );
}
