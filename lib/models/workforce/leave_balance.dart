/// Server LeaveBalanceDto: one leave type for one person in one year; [allowed] and [left] are null for no limit.
class LeaveBalance {
  const LeaveBalance({
    required this.leaveTypeId,
    required this.name,
    required this.paid,
    required this.taken,
    required this.waiting,
    this.allowed,
    this.left,
  });

  final String leaveTypeId;
  final String name;
  final bool paid;
  final int? allowed;
  final int taken;
  final int waiting;
  final int? left;

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => LeaveBalance(
    leaveTypeId: json['leaveTypeId'] as String,
    name: json['name'] as String,
    paid: json['paid'] as bool,
    allowed: (json['allowed'] as num?)?.toInt(),
    taken: (json['taken'] as num).toInt(),
    waiting: (json['waiting'] as num).toInt(),
    left: (json['left'] as num?)?.toInt(),
  );
}
