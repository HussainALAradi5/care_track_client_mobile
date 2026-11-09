import '../../utilities/time/dates.dart';

/// POST /api/organizations/{organizationId}/leave/requests body (CreateLeaveRequest).
class CreateLeaveRequest {
  const CreateLeaveRequest({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    this.reason,
    this.sickNoteId,
  });

  final String leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;
  final String? sickNoteId;

  Map<String, dynamic> toJson() => {
    'leaveTypeId': leaveTypeId,
    'startDate': isoDay(startDate),
    'endDate': isoDay(endDate),
    'reason': reason,
    'sickNoteId': sickNoteId,
  };
}
