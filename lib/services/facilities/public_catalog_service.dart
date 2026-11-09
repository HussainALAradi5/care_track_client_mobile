import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/facilities/hospital_search.dart';
import '../../models/common/page_result.dart';
import '../../models/facilities/hospital_summary.dart';
import '../../models/facilities/public_city.dart';
import '../../models/facilities/public_country.dart';
import '../api/api_client.dart';

/// The public hospital search; every route works without signing in.
class PublicCatalogService {
  PublicCatalogService(this._api);

  final ApiClient _api;

  /// Countries with hospitals (the search filter).
  Future<PageResult<PublicCountry>> countries(PageRequest request) => _countries(Endpoints.publicCountries, request);

  /// Every active country (nationality and residence when signing up).
  Future<PageResult<PublicCountry>> allCountries(PageRequest request) =>
      _countries(Endpoints.publicAllCountries, request);

  /// A country's cities with hospitals.
  Future<PageResult<PublicCity>> cities(String countryId, PageRequest request) =>
      _cities(Endpoints.publicCities(countryId), request);

  /// Every active city of a country.
  Future<PageResult<PublicCity>> allCities(String countryId, PageRequest request) =>
      _cities(Endpoints.publicAllCities(countryId), request);

  Future<PageResult<HospitalSummary>> hospitals(HospitalSearch search, int page, int pageSize) async =>
      PageResult.fromJson(
        await _api.get(
          Endpoints.publicHospitals,
          query: PageRequest(page: page, pageSize: pageSize, filters: search.toFilters()).toQuery(),
        ),
        HospitalSummary.fromJson,
      );

  Future<PageResult<PublicCountry>> _countries(String path, PageRequest request) async =>
      PageResult.fromJson(await _api.get(path, query: request.toQuery()), PublicCountry.fromJson);

  Future<PageResult<PublicCity>> _cities(String path, PageRequest request) async =>
      PageResult.fromJson(await _api.get(path, query: request.toQuery()), PublicCity.fromJson);
}
