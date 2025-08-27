import 'package:flutter/material.dart';

import '../../entities/trip.dart';
import '../../file_repository/trip_repository.dart';

class TripProvider with ChangeNotifier {
  final TripRepositorySQLite tripRepo = TripRepositorySQLite();

  List<Trip> _tripsList = [];

  List<Trip> get tripList => _tripsList;

  Future<void> initializeProvider() async {
    await loadTrips();
  }

  void createTrip(Trip trip) async {
    await tripRepo.createTrip(trip);
    await loadTrips();
  }

  void deleteTrip(Trip trip) async {
    await tripRepo.deleteTrip(trip);
    await loadTrips();
  }

  Future<void> loadTrips() async {
    _tripsList = await tripRepo.listTrips();
    notifyListeners();
  }
}
