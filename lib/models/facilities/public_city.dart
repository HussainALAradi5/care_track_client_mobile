/// Server PublicCityDto: a city in a search picker.
class PublicCity {
  const PublicCity({required this.id, required this.name});

  final String id;
  final String name;

  factory PublicCity.fromJson(Map<String, dynamic> json) =>
      PublicCity(id: json['id'] as String, name: json['name'] as String);
}
