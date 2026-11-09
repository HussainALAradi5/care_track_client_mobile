import '../../models/facilities/hospital_summary.dart';
import '../../models/facilities/public_city.dart';
import '../../models/facilities/public_country.dart';
import '../../models/ui/search_option.dart';

SearchOption countryOption(PublicCountry country) => SearchOption(
  id: country.id,
  label: [?country.flagEmoji, country.name].join(' '),
  detail: country.dialingCode,
);

SearchOption cityOption(PublicCity city) => SearchOption(id: city.id, label: city.name);

SearchOption hospitalOption(HospitalSummary hospital) =>
    SearchOption(id: hospital.id, label: hospital.name, detail: hospital.city);
