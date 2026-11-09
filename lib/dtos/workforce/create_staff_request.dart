import '../../enums/workforce/staff_request_type.dart';

/// POST /api/organizations/{organizationId}/staff-requests body.
class CreateStaffRequest {
  const CreateStaffRequest({required this.type, required this.details});

  final StaffRequestType type;
  final String details;

  Map<String, dynamic> toJson() => {'type': type.wire, 'details': details.trim()};
}
