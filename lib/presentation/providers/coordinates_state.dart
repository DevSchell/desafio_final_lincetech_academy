import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CoordinatesProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  String? errorMessage;

  //TODO: Does it work?
  CoordinatesProvider() {
    getPosition();
  }

  getPosition() async {
    try{
      Position position = await _currentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  //Method to get the current position of the device
  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool isActive = await Geolocator.isLocationServiceEnabled();

    if(!isActive) {
      return Future.error("Please enable localization services in your phone");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {

      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error("You need to enable your location services in your phone");
      }
    }

    if(permission == LocationPermission.deniedForever) {
      return Future.error("You must enable your device location services on your phone");
    }

    return await Geolocator.getCurrentPosition();

  }

}