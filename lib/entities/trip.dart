import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';

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

//TODO: Won't use them anymore, 'cause of the DB
//  List<Participant> participantList; // Table "participant"
//  List<Stopover> stopoverList; //Table "stopover"

  Trip({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.transportationMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title' : title,
      'startDate' : startDate,
      'endDate' : endDate,
      'transportationMethod' : transportationMethod
    };
  }

  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      transportationMethod: map['transportationMethod']
    );
  }

}
