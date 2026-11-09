import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/facilities/hospital_type.dart';
import '../../enums/facilities/opening_state.dart';
import '../../interfaces/ui/search_loader.dart';
import '../../models/common/page_result.dart';
import '../../models/facilities/hospital_search_filters.dart';
import '../../models/ui/search_option.dart';
import '../../utilities/facilities/search_options.dart';
import '../core/service_providers.dart';

/// The public search's filters; dropped when the screen closes.
class HospitalSearchController extends Notifier<HospitalSearchFilters> {
  @override
  HospitalSearchFilters build() => const HospitalSearchFilters();

  /// A new country clears the city, which belonged to the old one.
  void setCountry(SearchOption? value) =>
      state = HospitalSearchFilters(country: value, type: state.type, openingState: state.openingState);

  void setCity(SearchOption? value) => state = HospitalSearchFilters(
    country: state.country,
    city: value,
    type: state.type,
    openingState: state.openingState,
  );

  void setType(HospitalType? value) => state = HospitalSearchFilters(
    country: state.country,
    city: state.city,
    type: value,
    openingState: state.openingState,
  );

  void setOpeningState(OpeningState? value) => state = HospitalSearchFilters(
    country: state.country,
    city: state.city,
    type: state.type,
    openingState: value,
  );

  PageRequest _page(String term, int page) => PageRequest(
    page: page,
    pageSize: AppConstants.searchPageSize,
    filters: {'q': term.isEmpty ? null : term},
  );

  SearchLoader get countryLoader => (term, page) async =>
      (await ref.read(publicCatalogServiceProvider).countries(_page(term, page))).map(countryOption);

  SearchLoader get cityLoader {
    final countryId = state.country?.id;
    return (term, page) async {
      if (countryId == null) return PageResult.empty();
      return (await ref.read(publicCatalogServiceProvider).cities(countryId, _page(term, page))).map(cityOption);
    };
  }
}

final hospitalSearchProvider = NotifierProvider.autoDispose<HospitalSearchController, HospitalSearchFilters>(
  HospitalSearchController.new,
);
