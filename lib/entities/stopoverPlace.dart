/* Before becoming a proper "Stopover" this class is used to map the received
  data from the Nominatim API and create an object to use its infos */

class Place {
  final String cityName;
  final String cityState;
  final String cityCountry;
  final double latitude;
  final double longitude;

  Place({
    required this.cityName,
    required this.cityCountry,
    required this.cityState,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    try {
      return Place(
        cityName: json['name'] ?? 'not found',
        cityState: json['address']['state'] ?? 'not found',
        cityCountry: json["address"]["country"] ?? 'not found',
        latitude: double.tryParse(json['lat']) ?? 0.0,
        longitude: double.tryParse(json['lon']) ?? 0.0,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
