import 'package:desafio_final_lincetech_academy/entities/stopover.dart';
import 'package:flutter/material.dart';
import 'package:desafio_final_lincetech_academy/file_repository/stopover_repository.dart';

class StopoverProvider with ChangeNotifier {

  StopoverProvider({this.idTravel}){
    _init();
  }

  final int? idTravel;

  final StopoverRepositorySQLite stopoverRepo = StopoverRepositorySQLite();

  final List<Stopover> _stopoverList = [];

  List<Stopover> get stopoverList => _stopoverList;

  void addStopover(Stopover stopover) {
    stopoverRepo.createStopover(stopover);
    _stopoverList.add(stopover);
    notifyListeners();
  }

  void deleteStopover(Stopover stopover) {
    stopoverRepo.deleteStopover(stopover);
    _stopoverList.remove(stopover);
    notifyListeners();
  }

  Future<void> _init() async {
    if(idTravel != null) {
      final stopovers = await stopoverRepo.listStopovers(idTravel!);
      _stopoverList.addAll(stopovers);
      notifyListeners();
    }
  }

}