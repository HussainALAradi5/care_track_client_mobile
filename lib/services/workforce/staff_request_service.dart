import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/create_staff_request.dart';
import '../../dtos/workforce/decision_request.dart';
import '../../models/common/page_result.dart';
import '../../models/workforce/staff_request.dart';
import '../api/api_client.dart';

/// Staff requests in an Organization: the caller's own, and HR's list and decisions.
class StaffRequestService {
  StaffRequestService(this._api);

  final ApiClient _api;

  Future<PageResult<StaffRequest>> mine(String organizationId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.myStaffRequests(organizationId), query: request.toQuery()),
    StaffRequest.fromJson,
  );

  /// HR: the requests of the people working at its Hospitals.
  Future<PageResult<StaffRequest>> forHr(String organizationId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.staffRequests(organizationId), query: request.toQuery()),
    StaffRequest.fromJson,
  );

  Future<StaffRequest> decide(String organizationId, String requestId, DecisionRequest decision) async =>
      StaffRequest.fromJson(
        await _api.post(Endpoints.decideStaffRequest(organizationId, requestId), body: decision.toJson()),
      );

  Future<StaffRequest> create(String organizationId, CreateStaffRequest request) async =>
      StaffRequest.fromJson(await _api.post(Endpoints.staffRequests(organizationId), body: request.toJson()));

  Future<void> cancel(String organizationId, StaffRequest request) =>
      _api.post(Endpoints.cancelStaffRequest(organizationId, request.id), body: {'expectedVersion': request.version});
}
