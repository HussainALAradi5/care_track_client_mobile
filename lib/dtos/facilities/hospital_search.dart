import '../../enums/facilities/hospital_type.dart';
import '../../enums/facilities/opening_state.dart';

/// Filters of the public hospital list (PublicHospitalParams); unset ones are left out of the query.
class HospitalSearch {
  const HospitalSearch({this.countryId, this.cityId, this.type, this.openingState, this.name});

  final String? countryId;
  final String? cityId;
  final HospitalType? type;
  final OpeningState? openingState;
  final String? name;

  Map<String, Object?> toFilters() => {
    'countryId': countryId,
    'cityId': cityId,
    'type': type?.wire,
    'openingState': openingState?.wire,
    'q': name == null || name!.isEmpty ? null : name,
  };
}
