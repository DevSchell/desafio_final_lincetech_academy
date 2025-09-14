import 'participant.dart';
import 'stopover.dart';
/// This is one of the main classes of the application, representing a trip.
///
/// It aggregates all essential information, including basic trip details,
/// participants, and stopovers. The data from a [Trip] object can be used
/// to generate a PDF.
class Trip {
  /// The unique identifier for the trip.
  /// This field is optional because the ID is filled by the database
  /// when a new trip is created.
  int? id;

  /// The title or name of the trip.
  String title;

  /// The start date of the trip.
  DateTime startDate;

  /// The end date of the trip.
  DateTime endDate;

  /// The main method of transportation used for the trip.
  String transportationMethod;

  /// The list of selected experiences of the [Trip]
  List<String>? experiencesList;

  /// The list of participants associated with this trip.
  List<Participant>? participantList; // Table "participant"

  /// The list of stopovers or locations visited during the trip.
  List<Stopover>? stopoverList; //Table "stopover"

  /// Constructs a [Trip] instance.
  ///
  /// The [id] is optional. All other fields are required.
  Trip({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.transportationMethod,
    this.experiencesList,
    this.participantList,
    this.stopoverList,
  });

  /// Converts this [Trip] object into a [Map] for database operations.
  ///
  /// This method is used to prepare the trip's basic data for storage
  /// in a database, mapping class properties to key-value pairs.
  ///
  /// Returns a [Map] containing the trip's information.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'transportation_method': transportationMethod,
      'experiences_list': experiencesList?.join(','),
    };
  }

  /// Creates a new [Trip] instance from a [Map].
  ///
  /// This method is useful for converting a database info (row) back into a
  /// Dart object. It parses the stored data to reconstruct the trip.
  ///
  /// Returns a new [Trip] instance.
  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      title: map['title'],
      transportationMethod: map['transportation_method'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      experiencesList: (map['experiences_list'] as String?)?.split(','),
    );
  }
}
