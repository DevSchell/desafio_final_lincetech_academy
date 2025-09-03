import 'package:desafio_final_lincetech_academy/utils/formatting_methods.dart';

/// This class represents a participant in a trip.
/// It stores information such as the participant's name,
/// date of birth, a path to their photo, and their favorite
/// mode of transportation.
class Participant {
  /// The unique identifier for the participant.
  /// This is optional, as it may be null when creating a new participant
  /// before it is saved to the database.
  final int? id;

  /// The full name of the participant
  final String name;

  /// The date of birth of the participant
  final DateTime dateOfBirth;

  /// The file path to the participant's profile photo
  final String photoPath;

  /// The participant's favorite method of transportation
  final String favoriteTransp;

  /// Constructs a [Participant] instance.
  ///
  /// The [id] is optional and filled by the database.
  /// All other fields are required to create a new participant.
  Participant({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.photoPath,
    required this.favoriteTransp,
  });

  /// Converts this [Participant] object into a [Map] for database operations.
  ///
  /// The [tripId] parameter is used to link the participant with a trip,
  ///
  /// Returns a [Map] containing the participant's data.
  Map<String, dynamic> toMap(int? tripId) {
    return {
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'photo_path': photoPath,
      'trip_id': tripId,
      'favorite_transport': favoriteTransp,
    };
  }

  /// Creates a [Participant] object from a [Map] retrieved from the database.
  ///
  /// This factory method is useful for converting database info into objects.
  ///
  /// Returns a new [Participant] instance.
  static Participant fromMap(Map<String, dynamic> map) {
    return Participant(
      name: map['name'],
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      photoPath: map['photo_path'],
      favoriteTransp: map['favorite_transport'],
    );
  }
}
