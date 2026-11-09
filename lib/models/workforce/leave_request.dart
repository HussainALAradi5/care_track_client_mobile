import '../../enums/workforce/leave_status.dart';
import 'sick_note_summary.dart';

/// Server LeaveRequestDto, with what the caller may do with it now.
class LeaveRequest {
  const LeaveRequest({
    required this.id,
    required this.code,
    required this.userId,
    required this.userName,
    required this.leaveTypeName,
    required this.paid,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.version,
    required this.canDecide,
    required this.canCancel,
    this.reason,
    this.decidedByName,
    this.decisionNote,
    this.sickNote,
  });

  final String id;
  final String code;
  final String userId;
  final String userName;
  final String leaveTypeName;
  final bool paid;
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final String? reason;
  final LeaveStatus status;
  final String? decidedByName;
  final String? decisionNote;
  final int version;
  final bool canDecide;
  final bool canCancel;
  final SickNoteSummary? sickNote;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
    id: json['id'] as String,
    code: json['code'] as String,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    leaveTypeName: json['leaveTypeName'] as String,
    paid: json['paid'] as bool,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    days: (json['days'] as num).toInt(),
    reason: json['reason'] as String?,
    status: LeaveStatus.fromWire(json['status'] as String),
    decidedByName: json['decidedByName'] as String?,
    decisionNote: json['decisionNote'] as String?,
    version: (json['version'] as num).toInt(),
    canDecide: json['canDecide'] as bool,
    canCancel: json['canCancel'] as bool,
    sickNote: json['sickNote'] == null ? null : SickNoteSummary.fromJson(json['sickNote'] as Map<String, dynamic>),
  );
}
