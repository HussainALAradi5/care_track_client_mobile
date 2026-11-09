import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/identity/enrolled_hospital.dart';
import '../api/api_client.dart';

class EnrollmentService {
  EnrollmentService(this._api);

  final ApiClient _api;

  /// Registers the caller as a patient at a Hospital (anyone: staff elsewhere or here too).
  Future<EnrolledHospital> enrollMe(String hospitalId) async =>
      EnrolledHospital.fromJson(await _api.post(Endpoints.enrollMe, body: {'hospitalId': hospitalId}));

  Future<PageResult<EnrolledHospital>> myHospitals(PageRequest request) async =>
      PageResult.fromJson(await _api.get(Endpoints.myHospitals, query: request.toQuery()), EnrolledHospital.fromJson);
}
