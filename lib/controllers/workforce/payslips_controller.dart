import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/workforce/payslip.dart';
import '../auth/auth_controller.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';

/// The caller's payslips, keyed on who is signed in so sign-out empties the list.
class PayslipsController extends HospitalPagedController<Payslip> {
  @override
  String? watchHospitalId() => ref.watch(signedInUserIdProvider);

  @override
  String? readHospitalId() => ref.read(signedInUserIdProvider);

  @override
  Future<PageResult<Payslip>> fetch(String hospitalId, PageRequest request) =>
      ref.read(payslipServiceProvider).mine(request);
}

final payslipsProvider = AsyncNotifierProvider.autoDispose<PayslipsController, PagedItems<Payslip>>(
  PayslipsController.new,
);

/// One of the caller's payslips with its lines.
final payslipProvider = FutureProvider.autoDispose.family<Payslip, String>((ref, id) {
  ref.watch(signedInUserIdProvider);
  return ref.read(payslipServiceProvider).mineById(id);
});
