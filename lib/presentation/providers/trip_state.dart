import 'package:flutter/material.dart';

import '../../entities/trip.dart';

class TripProvider with ChangeNotifier {
  final List<Trip> _tripsList = [];

  List<Trip> get TripList  => _tripsList;

  void createTrip(Trip trip)  {
    _tripsList.add(trip);
    notifyListeners();
  }

  void deleteTrip(Trip trip) {
    _tripsList.remove(trip);
    notifyListeners();
  }

}