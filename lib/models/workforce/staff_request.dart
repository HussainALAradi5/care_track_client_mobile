import '../../enums/workforce/staff_request_status.dart';
import '../../enums/workforce/staff_request_type.dart';

/// Server StaffRequestDto as this person sees their own request.
class StaffRequest {
  const StaffRequest({
    required this.id,
    required this.code,
    required this.type,
    required this.details,
    required this.status,
    required this.requestedAt,
    required this.decidedByName,
    required this.decisionNote,
    required this.version,
    required this.canCancel,
    this.userName,
    this.canDecide = false,
  });

  final String id;
  final String code;
  final StaffRequestType type;
  final String details;
  final StaffRequestStatus status;
  final DateTime requestedAt;
  final String? decidedByName;
  final String? decisionNote;
  final int version;
  final bool canCancel;

  /// Who raised it, for HR's list.
  final String? userName;
  final bool canDecide;

  factory StaffRequest.fromJson(Map<String, dynamic> json) => StaffRequest(
    id: json['id'] as String,
    code: json['code'] as String,
    type: StaffRequestType.fromWire(json['type'] as String),
    details: json['details'] as String,
    status: StaffRequestStatus.fromWire(json['status'] as String),
    requestedAt: DateTime.parse(json['requestedAt'] as String),
    decidedByName: json['decidedByName'] as String?,
    decisionNote: json['decisionNote'] as String?,
    version: (json['version'] as num).toInt(),
    canCancel: json['canCancel'] as bool,
    userName: json['userName'] as String?,
    canDecide: json['canDecide'] as bool? ?? false,
  );
}
