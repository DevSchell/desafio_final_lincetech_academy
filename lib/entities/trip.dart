import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';

import 'enum_experiences_list.dart';

/*
 This is one of the main classes from the application, because the "Trip class
 contains every type of info. participants, stopovers"
 It'll be from here where we'll take the data to create the PDF in the future
 */

class Trip {
  int? tripId;
  String tripTitle;
  String experienceList;
  DateTime startDate;
  DateTime endDate;
  String transportationMethod;

  List<Participant> participantList; // Table "participant"
  List<Stopover> stopoverList; //Table "stopover"

  Trip({
    this.tripId,
    required this.tripTitle,
    required this.participantList,
    required this.experienceList,
    required this.startDate,
    required this.endDate,
    required this.stopoverList,
    required this.transportationMethod,
  });
}
