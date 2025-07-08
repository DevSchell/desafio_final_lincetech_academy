import 'package:flutter/material.dart';
import 'package:desafio_final_lincetech_academy/entities/participant.dart';

class ParticipantProvider with ChangeNotifier{
  final List<Participant> _participantList = [];

  List<Participant> get participantList => _participantList;

  void addParticipant(Participant participant) {
    _participantList.add(participant);
    notifyListeners();
  }

  void deleteParticipant(Participant participant) {
    _participantList.remove(participant);
    notifyListeners();
  }
}