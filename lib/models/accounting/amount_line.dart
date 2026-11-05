/// A named amount of the month summary (one of the largest revenue or expense accounts).
class AmountLine {
  const AmountLine({required this.accountId, required this.name, required this.amount});

  final String accountId;
  final String name;
  final double amount;

  factory AmountLine.fromJson(Map<String, dynamic> json) => AmountLine(
    accountId: json['accountId'] as String,
    name: json['name'] as String,
    amount: (json['amount'] as num).toDouble(),
  );
}
