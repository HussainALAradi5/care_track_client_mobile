import '../../enums/facilities/hospital_type.dart';
import '../../enums/facilities/opening_state.dart';
import '../ui/search_option.dart';

/// What the public hospital search is narrowed to; each is optional.
class HospitalSearchFilters {
  const HospitalSearchFilters({this.country, this.city, this.type, this.openingState});

  final SearchOption? country;
  final SearchOption? city;
  final HospitalType? type;
  final OpeningState? openingState;
}
