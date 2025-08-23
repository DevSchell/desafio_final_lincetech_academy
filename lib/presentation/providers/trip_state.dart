import 'package:flutter/material.dart';

import '../../entities/trip.dart';
import '../../file_repository/trip_repository.dart';

class TripProvider with ChangeNotifier {

  final TripRepositorySQLite tripRepo = TripRepositorySQLite();

  final List<Trip> _tripsList = [];

  List<Trip> get TripList  => _tripsList;

  void createTrip(Trip trip)  {
    tripRepo.createTrip(trip);
    _tripsList.add(trip);
    notifyListeners();
  }

  void deleteTrip(Trip trip) {
    tripRepo.deleteTrip(trip);
    _tripsList.remove(trip);
    notifyListeners();
  }

}