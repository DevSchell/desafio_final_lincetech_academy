import 'package:desafio_final_lincetech_academy/entities/enum_transportation_method.dart';

//This class represents a trip participant
class Participant {
  final int? participatID;
  final String name;
  final String dateOfBirth; //TODO: Change to DATETIME afterwards
  final String photoPath;
  final String favoriteTransp;

  Participant({
    this.participatID,
    required this.name,
    required this.dateOfBirth,
    required this.photoPath,
    required this.favoriteTransp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age_of_birth': dateOfBirth,
      'photoPath': photoPath,
      'favoriteTransp': favoriteTransp,
    };
  }
}
