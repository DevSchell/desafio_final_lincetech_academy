import 'package:flutter/material.dart';
import 'package:desafio_final_lincetech_academy/entities/participant.dart';
import 'package:desafio_final_lincetech_academy/file_repository/participant_repository.dart';

class ParticipantProvider with ChangeNotifier {

  ParticipantProvider({this.idTravel}){
    _init();
  }

  final  int? idTravel;

  final ParticipantRepositorySQLite participantRepo =
      ParticipantRepositorySQLite();

  final List<Participant> _participantList = [];

  List<Participant> get participantList => _participantList;

  void addParticipant(Participant participant) {
     participantRepo.createParticipant(participant);
    _participantList.add(participant);
    notifyListeners();
  }

  void deleteParticipant(Participant participant) {
    participantRepo.deleteParticipant(participant);
    _participantList.remove(participant);
    notifyListeners();
  }

  Future<void> _init() async {
    if (idTravel != null) {
      final participants = await participantRepo.listParticipants(idTravel!);
      _participantList.addAll(participants);
      notifyListeners();
    }
  }
}
