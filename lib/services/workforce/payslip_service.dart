import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/workforce/payslip.dart';
import '../api/api_client.dart';

class PayslipService {
  PayslipService(this._api);

  final ApiClient _api;

  Future<PageResult<Payslip>> mine(PageRequest request) async =>
      PageResult.fromJson(await _api.get(Endpoints.myPayslips, query: request.toQuery()), Payslip.fromJson);

  Future<Payslip> mineById(String payslipId) async => Payslip.fromJson(await _api.get(Endpoints.myPayslip(payslipId)));
}
