import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/trip.dart';

abstract interface class TripRepository {
  Future<void> createTrip(Trip trip);

  Future<List<Trip>> listTrips();

  Future<void> updateTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);
}

class TripRepositorySQLite implements TripRepository {
  Database? _db;

  Future<Database> _initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'trips.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
           CREATE TABLE IF NOT EXISTS trips(
            id INTEGER PRIMARY KEY NOT NULL,
            title TEXT,
            start_date TEXT,
            end_date TEXT,
            transportation_method TEXT
           );
          ''');
      },
    );
    return _db!;
  }

  @override
  Future<void> createTrip(Trip trip) async {
    final db = await _initDb();
    await db.insert('trips', trip.toMap());
  }

  @override
  Future<List<Trip>> listTrips() async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('trips');
    // Like a "for" but better for this situation
    return List.generate(maps.length, (i) {
      return Trip.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    final db = await _initDb();

    if (trip.id == null) {
      return;
    }

    await db.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  @override
  Future<void> deleteTrip(Trip trip) async {
    final db = await _initDb();

    if (trip.id == null) {
      return;
    }

    await db.delete('trips', where: 'id = ?', whereArgs: [trip.id]);
  }
}
