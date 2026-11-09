import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/facilities/hospital_summary.dart';
import '../auth/auth_controller.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';
import 'near_opening_filter_controller.dart';

/// The person's nearby hospitals: keyed on who is signed in, so sign-out empties the list.
class HospitalsNearController extends HospitalPagedController<HospitalSummary> {
  @override
  String? watchHospitalId() {
    ref.watch(nearOpeningFilterProvider);
    return ref.watch(signedInUserIdProvider);
  }

  @override
  String? readHospitalId() => ref.read(signedInUserIdProvider);

  @override
  Future<PageResult<HospitalSummary>> fetch(String hospitalId, PageRequest request) {
    final filtered = PageRequest(
      page: request.page,
      pageSize: request.pageSize,
      filters: {'openingState': ref.read(nearOpeningFilterProvider)?.wire},
    );
    return ref.read(hospitalServiceProvider).nearMe(filtered);
  }
}

final hospitalsNearProvider = AsyncNotifierProvider.autoDispose<HospitalsNearController, PagedItems<HospitalSummary>>(
  HospitalsNearController.new,
);
