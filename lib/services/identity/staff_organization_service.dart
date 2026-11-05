import '../../config/endpoints.dart';
import '../../models/identity/staff_organization.dart';
import '../api/api_client.dart';

class StaffOrganizationService {
  StaffOrganizationService(this._api);

  final ApiClient _api;

  /// Organizations where the caller holds Organization-wide grants (accountants, administrators), by name.
  Future<List<StaffOrganization>> myOrganizations() async =>
      (await _api.getList(Endpoints.myOrganizations))
          .map((e) => StaffOrganization.fromJson(e as Map<String, dynamic>))
          .toList();
}
