/// Server PublicCountryDto: a country in a search picker.
class PublicCountry {
  const PublicCountry({required this.id, required this.name, required this.isoCode, this.flagEmoji, this.dialingCode});

  final String id;
  final String name;
  final String isoCode;
  final String? flagEmoji;
  final String? dialingCode;

  factory PublicCountry.fromJson(Map<String, dynamic> json) => PublicCountry(
    id: json['id'] as String,
    name: json['name'] as String,
    isoCode: json['isoCode'] as String,
    flagEmoji: json['flagEmoji'] as String?,
    dialingCode: json['dialingCode'] as String?,
  );
}
