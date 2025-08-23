import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

// A trip can have a lot of stopovers, so this class represents those stopovers
class Stopover {
  int? id;
  String cityName;
  DateTime arrivalDate;
  DateTime departureDate;
  double latitude;
  double longitude;
  String? actvDescription; //Not required anymore for testing purposes


  Stopover({
    this.id,
    required this.cityName,
    required this.arrivalDate,
    required this.departureDate,
    required this.latitude,
    required this.longitude,
    this.actvDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'city_name' : cityName,
      'arrival_date' : arrivalDate,
      'departure_date' : departureDate,
      'latitude' : latitude,
      'longitude' : longitude,
    };
  }

  static Stopover fromMap(Map<String, dynamic> map) {
    return Stopover (
      id: map['id'],
      cityName: map['city_name'],
      arrivalDate: DateTime.parse(map['arrival_date']),
      departureDate: DateTime.parse(map['departure_date']),
      latitude: map['latitude'],
      longitude: map['longitude']
    );
  }
}

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
        cityCountry: json['address']['country'] ?? 'not found',
        latitude: double.tryParse(json['lat']) ?? 0.0,
        longitude: double.tryParse(json['lon']) ?? 0.0,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}

