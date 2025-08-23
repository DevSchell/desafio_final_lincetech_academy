import 'package:desafio_final_lincetech_academy/utils/formatting_methods.dart';

import '../utils/formatting_methods.dart';

//This class represents a trip participant
class Participant {
  final int? id;
  final String name;
  final DateTime dateOfBirth; //TODO: Change to DATETIME afterwards
  final String photoPath;
  final String favoriteTransp;

  Participant({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.photoPath,
    required this.favoriteTransp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date_of_birth': Utils().dateFormat(dateOfBirth),
      'photoPath': photoPath,
      'favoriteTransp': favoriteTransp,
    };
  }

  static Participant fromMap(Map<String, dynamic> map) {
    return Participant(
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      photoPath: map['photoPath'],
      favoriteTransp: map['favoriteTransp']
    );
  }

}
