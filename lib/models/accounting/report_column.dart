/// One column of a report: its key in each row's values, its heading and whether it holds money.
class ReportColumn {
  const ReportColumn({required this.key, required this.label, required this.money});

  final String key;
  final String label;
  final bool money;

  factory ReportColumn.fromJson(Map<String, dynamic> json) =>
      ReportColumn(key: json['key'] as String, label: json['label'] as String, money: json['type'] == 'MONEY');
}
