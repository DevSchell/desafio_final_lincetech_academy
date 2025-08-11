import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';

/*
 This is one of the main classes from the application, because the "Trip class
 contains every type of info, for example participant list, stopover list, travel dates and etc."
 It'll be from here where we'll take the data to create the PDF in the future
 */

class Trip {
  //int tripId;
  String tripTitle;
  List<Participant> participantList;
  List<String> experienceList; //Talvez esse cara mude até o fim do projeto
  DateTime startDate;
  DateTime endDate;
  List<Stopover> stopoverList;
  Enum transportationMethod;

  Trip({
    //required this.tripId,
    required this.tripTitle,
    required this.participantList,
    required this.experienceList,
    required this.startDate,
    required this.endDate,
    required this.stopoverList,
    required this.transportationMethod,
});
}