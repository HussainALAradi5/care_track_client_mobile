import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/identity/staff_hospital.dart';
import '../api/api_client.dart';

class StaffHospitalService {
  StaffHospitalService(this._api);

  final ApiClient _api;

  /// Hospitals where the caller holds a staff role, by name, each with the permission codes granted there.
  Future<PageResult<StaffHospital>> myHospitals(PageRequest request) async =>
      PageResult.fromJson(await _api.get(Endpoints.myStaffHospitals, query: request.toQuery()), StaffHospital.fromJson);
}
