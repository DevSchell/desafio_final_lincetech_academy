import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/trip.dart';

abstract interface class TripRepository {
  Future<void> createTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);

  Future<void> editTrip(Trip trip);

  Future<List<Trip>> listTrips();
}

class TripRepositorySQLite implements TripRepository {
  Database? _db;

  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'trips.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        //TODO: First, you ask the doubt you have, then...
        // TODO: You implement code here
        return db.execute('''
           CREATE TABLE trips(
            id INTEGER PRIMARY KEY,
           )
          ''');
      },
    );
  }

  @override
  Future<void> createTrip(Trip trip) {
    // TODO: implement createTrip
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTrip(Trip trip) {
    // TODO: implement deleteTrip
    throw UnimplementedError();
  }

  @override
  Future<void> editTrip(Trip trip) {
    // TODO: implement editTrip
    throw UnimplementedError();
  }

  @override
  Future<List<Trip>> listTrips() {
    // TODO: implement listTrips
    throw UnimplementedError();
  }
}
