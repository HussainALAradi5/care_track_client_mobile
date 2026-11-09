import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../dtos/facilities/hospital_search.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/facilities/hospital_summary.dart';
import '../care/hospital_paged_controller.dart';
import '../core/service_providers.dart';
import 'hospital_search_controller.dart';

/// The public list: one fixed key, reloaded whenever a filter changes.
class PublicHospitalsController extends HospitalPagedController<HospitalSummary> {
  static const _publicList = 'public';

  @override
  String? watchHospitalId() {
    ref.watch(hospitalSearchProvider);
    return _publicList;
  }

  @override
  String? readHospitalId() => _publicList;

  @override
  Future<PageResult<HospitalSummary>> fetch(String hospitalId, PageRequest request) {
    final filters = ref.read(hospitalSearchProvider);
    final search = HospitalSearch(
      countryId: filters.country?.id,
      cityId: filters.city?.id,
      type: filters.type,
      openingState: filters.openingState,
    );
    return ref.read(publicCatalogServiceProvider).hospitals(search, request.page, request.pageSize);
  }
}

final publicHospitalsProvider =
    AsyncNotifierProvider.autoDispose<PublicHospitalsController, PagedItems<HospitalSummary>>(
      PublicHospitalsController.new,
    );
