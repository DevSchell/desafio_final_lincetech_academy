import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';

class Trip {
  int tripId;
  String tripTitle;
  List<Participant> participantList;
  List<String> experienceList; //Talvez esse cara mude até o fim do projeto
  DateTime startDate;
  DateTime endDate;
  List<Stopover> stopoverList;
  Enum transportationMethod;

  Trip({
    required this.tripId,
    required this.tripTitle,
    required this.participantList,
    required this.experienceList,
    required this.startDate,
    required this.endDate,
    required this.stopoverList,
    required this.transportationMethod,
});
}