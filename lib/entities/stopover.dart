/// A trip can have multiple stopovers, and this class represents each one.
/// It holds essential information about a specific location on a trip,
/// including its name, dates, and geographic coordinates.
class Stopover {
  /// The unique identifier for the stopover.
  /// This is optional, it may be null before it's saved into the database.
  int? id;

  /// The name of the city where the stopover takes place.
  String cityName;

  /// The date and time of arrival at the stopover location.
  DateTime arrivalDate;

  /// The date and time of the departure from the stopover location.
  DateTime departureDate;

  /// The latitude coordinate of the stopover location.
  double latitude;

  /// The longitude coordinate of the stopover location.
  double longitude;

  /// An optional description of activities at the stopover
  String? actvDescription; //Not required anymore for testing purposes

  /// Constructs a [Stopover] instance.
  ///
  /// The [id] is optional and is filled by the database.
  /// All other fields are required to create a new stopover.
  Stopover({
    this.id,
    required this.cityName,
    required this.arrivalDate,
    required this.departureDate,
    required this.latitude,
    required this.longitude,
    this.actvDescription,
  });

  /// Converts this [Stopover] object into a [Map] for database operations.
  ///
  /// Returns a [Map] containing the stopover's data, formatted for insertion
  /// or update in a database table.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_name': cityName,
      'arrival_date': arrivalDate.toIso8601String(),
      'departure_date': departureDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Creates a [Stopover] object from a [Map] retrieved from the database.
  ///
  /// This factory method is useful for converting a database row into an
  /// object.
  /// Returns a new [Stopover] instance.
  static Stopover fromMap(Map<String, dynamic> map) {
    return Stopover(
      id: map['id'],
      cityName: map['city_name'],
      arrivalDate: DateTime.parse(map['arrival_date']),
      departureDate: DateTime.parse(map['departure_date']),
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

/// A temporary data class used to map information received from Nominatim  API
///before it is converted into a proper [Stopover] object.
class Place {
  /// The name of the city.
  final String cityName;

  /// The name of the state or province where the city is located.
  final String cityState;

  /// The The name of the country where tge city is located
  final String cityCountry;

  /// The latitude coordinate of the place
  final double latitude;

  /// The longitude coordinate of the place
  final double longitude;

  /// Constructs a [Place] instance.
  ///
  /// All fields are required to create a valid place object.
  Place({
    required this.cityName,
    required this.cityCountry,
    required this.cityState,
    required this.latitude,
    required this.longitude,
  });

  /// Creates a [Place] object from a JSON map returned by the API.
  ///
  /// This factory constructor picks relevant data from the
  /// API response and creates a [Place]. It includes error handling to
  /// prevent crashes if the expected data is missing or invalid.
  factory Place.fromJson(Map<String, dynamic> json) {
    try {
      return Place(
        cityName: json['name'] ?? 'not found',
        cityState: json['address']['state'] ?? 'not found',
        cityCountry: json['address']['country'] ?? 'not found',
        latitude: double.tryParse(json['lat']) ?? 0.0,
        longitude: double.tryParse(json['lon']) ?? 0.0,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
