/// Server AccountingStatusDto (the fields the app uses).
class AccountingStatus {
  const AccountingStatus({required this.setUp, required this.currentPeriodName});

  final bool setUp;
  final String? currentPeriodName;

  factory AccountingStatus.fromJson(Map<String, dynamic> json) => AccountingStatus(
    setUp: json['setUp'] as bool,
    currentPeriodName: (json['currentPeriod'] as Map<String, dynamic>?)?['name'] as String?,
  );
}
