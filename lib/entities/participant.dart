import 'package:desafio_final_lincetech_academy/utils/formatting_methods.dart';
//This class represents a trip participant
class Participant {
  final int? id;
  final String name;
  final DateTime dateOfBirth;
  final String photoPath;
  final String favoriteTransp;

  Participant({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.photoPath,
    required this.favoriteTransp,
  });

  Map<String, dynamic> toMap(int? tripId) {
    return {
      'name': name,
      'date_of_birth': Utils().dateTimeToStringFormat(dateOfBirth),
      'photo_path': photoPath,
      'trip_id': tripId,
      'favorite_transport': favoriteTransp,
    };
  }

  static Participant fromMap(Map<String, dynamic> map) {
    return Participant(
      name: map['name'],
      dateOfBirth: map['date_of_birth'],
      photoPath: map['photo_path'],
      favoriteTransp: map['favorite_transport']
    );
  }

}
