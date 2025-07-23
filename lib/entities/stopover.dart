import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

class Stopover {
  String cityName;
  Coordinate coordinates;
  DateTime arrivalDate;
  DateTime departureDate;
  List<String> actvDescription;
  List<Review>? reviewList;

  Stopover({
    required this.cityName,
    required this.coordinates,
    required this.arrivalDate,
    required this.departureDate,
    required this.actvDescription,
    required this.reviewList,
});
}