import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/create_leave_request.dart';
import '../../dtos/workforce/decision_request.dart';
import '../../models/common/page_result.dart';
import '../../models/workforce/leave_request.dart';
import '../../models/workforce/my_leave.dart';
import '../api/api_client.dart';

/// Leave in an Organization: the caller's own, the decision queue and each request.
class LeaveService {
  LeaveService(this._api);

  final ApiClient _api;

  Future<MyLeave> mine(String organizationId, int year) async =>
      MyLeave.fromJson(await _api.get(Endpoints.myLeave(organizationId), query: {'year': year}));

  /// HR: every request; a manager: their direct reports'.
  Future<PageResult<LeaveRequest>> queue(String organizationId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.leaveRequests(organizationId), query: request.toQuery()),
    LeaveRequest.fromJson,
  );

  Future<LeaveRequest> ask(String organizationId, CreateLeaveRequest request) async =>
      LeaveRequest.fromJson(await _api.post(Endpoints.leaveRequests(organizationId), body: request.toJson()));

  Future<LeaveRequest> decide(String organizationId, String requestId, DecisionRequest decision) async =>
      LeaveRequest.fromJson(await _api.post(Endpoints.leaveDecision(organizationId, requestId), body: decision.toJson()));

  Future<LeaveRequest> cancel(String organizationId, LeaveRequest request) async => LeaveRequest.fromJson(
    await _api.post(Endpoints.leaveCancel(organizationId, request.id), body: {'note': null, 'expectedVersion': request.version}),
  );
}
