import '../../enums/facilities/hospital_type.dart';
import 'opening_status.dart';

/// What a hospital card shows, from PublicHospitalDto or HospitalDto (same field names; the country is public only).
class HospitalSummary {
  const HospitalSummary({
    required this.id,
    required this.name,
    required this.type,
    this.city,
    this.addressLine,
    this.countryName,
    this.flagEmoji,
    this.opening,
  });

  final String id;
  final String name;
  final HospitalType type;
  final String? city;
  final String? addressLine;
  final String? countryName;
  final String? flagEmoji;
  final OpeningStatus? opening;

  factory HospitalSummary.fromJson(Map<String, dynamic> json) => HospitalSummary(
    id: json['id'] as String,
    name: json['name'] as String,
    type: HospitalType.fromWire(json['type'] as String),
    city: json['city'] as String?,
    addressLine: json['addressLine'] as String?,
    countryName: json['countryName'] as String?,
    flagEmoji: json['flagEmoji'] as String?,
    opening: json['opening'] == null ? null : OpeningStatus.fromJson(json['opening'] as Map<String, dynamic>),
  );
}
