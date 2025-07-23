import 'package:desafio_final_lincetech_academy/entities/stopover.dart';
import 'package:flutter/material.dart';

class StopoverProvider with ChangeNotifier {
  final List<Stopover> _stopoverList = [];

  List<Stopover> get stopoverList => _stopoverList;

  void addStopover(Stopover stopover) {
    _stopoverList.add(stopover);
    notifyListeners();
  }

  void deleteStopover(Stopover stopover) {
    _stopoverList.remove(stopover);
    notifyListeners();
  }
}