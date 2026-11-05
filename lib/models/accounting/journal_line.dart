/// Server JournalLineDto.
class JournalLine {
  const JournalLine({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    required this.hospitalName,
    required this.debit,
    required this.credit,
  });

  final String id;
  final String accountNumber;
  final String accountName;
  final String? hospitalName;
  final double debit;
  final double credit;

  factory JournalLine.fromJson(Map<String, dynamic> json) => JournalLine(
    id: json['id'] as String,
    accountNumber: json['accountNumber'] as String,
    accountName: json['accountName'] as String,
    hospitalName: json['hospitalName'] as String?,
    debit: (json['debit'] as num).toDouble(),
    credit: (json['credit'] as num).toDouble(),
  );
}
