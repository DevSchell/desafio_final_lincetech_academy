import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

// A trip can have a lot of stopovers, so this class represents those stopovers
class Stopover {
  int? stopoverID;
  String cityName;
  DateTime arrivalDate;
  DateTime departureDate;
  double latitude;
  double longitude;
  List<String>? actvDescription; //Not required anymore for testing purposes
  List<Review>? reviewList; // Isn't required anymore because I need to create the Stopover and then afterwards the user will add reviews to it

  Stopover({
    required this.cityName,
    required this.arrivalDate,
    required this.departureDate,
    required this.latitude,
    required this.longitude,
    this.stopoverID,
    this.actvDescription,
    this.reviewList
  });

  Map<String, dynamic> toMap() {
    return {
      'stopoverID' : stopoverID,
      'cityName' : cityName,
      'arrivalDate' : arrivalDate,
      'departureDate' : departureDate,
      'latitude' : latitude,
      'longitude' : longitude,
      // Por enquanto eu vou fazer testes apenas com essas campos
    };
  }

  static Stopover fromMap(Map<String, dynamic> map) {
    return Stopover (
      stopoverID: map['stopoverID'],
      cityName: map['cityName'],
      arrivalDate: DateTime.parse(map['arrivalDate']),
      departureDate: DateTime.parse(map['departureDate']),
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

