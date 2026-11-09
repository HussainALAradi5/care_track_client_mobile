import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/facilities/hospital_summary.dart';
import '../api/api_client.dart';

class HospitalService {
  HospitalService(this._api);

  final ApiClient _api;

  /// Hospitals in or serving the caller's city; RESIDENCE_REQUIRED when no home address is on file.
  Future<PageResult<HospitalSummary>> nearMe(PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.hospitalsNearMe, query: request.toQuery()),
    HospitalSummary.fromJson,
  );
}
