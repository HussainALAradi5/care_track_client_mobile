/// Server PayslipLineDto; deductions are negative.
class PayslipLine {
  const PayslipLine({required this.id, required this.label, required this.amount, this.days});

  final String id;
  final String label;
  final double amount;
  final int? days;

  factory PayslipLine.fromJson(Map<String, dynamic> json) => PayslipLine(
    id: json['id'] as String,
    label: json['label'] as String,
    amount: (json['amount'] as num).toDouble(),
    days: (json['days'] as num?)?.toInt(),
  );
}
