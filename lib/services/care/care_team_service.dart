import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/care/assigned_clinician.dart';
import '../../models/common/page_result.dart';
import '../api/api_client.dart';

class CareTeamService {
  CareTeamService(this._api);

  final ApiClient _api;

  Future<PageResult<AssignedClinician>> myCareTeam(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.myCareTeam(hospitalId), query: request.toQuery()),
    AssignedClinician.fromJson,
  );
}
