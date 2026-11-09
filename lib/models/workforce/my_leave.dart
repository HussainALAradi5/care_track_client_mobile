import 'leave_balance.dart';
import 'leave_request.dart';

/// Server MyLeaveDto: the caller's leave in one year.
class MyLeave {
  const MyLeave({required this.year, required this.employed, required this.balances, required this.requests});

  final int year;
  final bool employed;
  final List<LeaveBalance> balances;
  final List<LeaveRequest> requests;

  factory MyLeave.fromJson(Map<String, dynamic> json) => MyLeave(
    year: (json['year'] as num).toInt(),
    employed: json['employed'] as bool,
    balances: [for (final b in json['balances'] as List<dynamic>) LeaveBalance.fromJson(b as Map<String, dynamic>)],
    requests: [for (final r in json['requests'] as List<dynamic>) LeaveRequest.fromJson(r as Map<String, dynamic>)],
  );
}
