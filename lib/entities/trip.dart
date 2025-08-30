import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';

import '../utils/formatting_methods.dart';
import 'enum_experiences_list.dart';

/*
 This is one of the main classes from the application, because the "Trip class
 contains every type of info. participants, stopovers"
 It'll be from here where we'll take the data to create the PDF in the future
 */

class Trip {
  int? id;
  String title;
  DateTime startDate;
  DateTime endDate;
  String transportationMethod;

  List<Participant>? participantList; // Table "participant"
  List<Stopover>? stopoverList; //Table "stopover"

  Trip({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.transportationMethod,
    this.participantList,
    this.stopoverList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'transportation_method': transportationMethod,

      // 'participant_list' : participantList,
      // 'stopover_list' : stopoverList
    };
  }

  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      title: map['title'],
      transportationMethod: map['transportation_method'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),

      // participantList: map['participant_list'],
      // stopoverList: map['stopover_list'],
    );
  }
}
