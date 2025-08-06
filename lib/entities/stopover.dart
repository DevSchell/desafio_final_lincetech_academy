import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

// A trip can have a lot of stopovers, so this class represents those stopovers
class Stopover {
  String cityName;
  Coordinate coordinates;
  DateTime arrivalDate;
  DateTime departureDate;
  List<String>? actvDescription; //Not required anymore for testing purposes
  List<Review>? reviewList; // Isn't required anymore because I need to create the Stopover and then afterwards the user will add reviews to it

  Stopover({
    required this.cityName,
    required this.coordinates,
    required this.arrivalDate,
    required this.departureDate,
  });
}
