import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/trip.dart';

abstract interface class TripRepository {
  Future<void> createTrip(Trip trip);

  Future<List<Trip>> listTrips();

  Future<void> updateTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);

  //New methods
  Future<void> addParticipantToTrip(int tripId, int participantId);

  Future<void> removeParticipantFromTrip(int tripId, int participantId);

  Future<List<Map<String, dynamic>>> listParticipantsFromTrip(int tripId);
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
        db.execute('''
        CREATE TABLE IF NOT EXISTS trips(
          id INTEGER PRIMARY KEY NOT NULL,
          title TEXT,
          start_date TEXT,
          end_date TEXT,
          transportation_method TEXT
        );
      ''');
        db.execute('''
        CREATE TABLE IF NOT EXISTS trip_participant(
          trip_id INTEGER NOT NULL,
          participant_id INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (participant_id) REFERENCES participants(id),
          PRIMARY KEY (trip_id, participant_id)
        );
      ''');
        db.execute('''
        CREATE TABLE IF NOT EXISTS trip_experience(
          trip_id INTEGER NOT NULL,
          experience_id INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (experience_id) REFERENCES experiences(id),
          PRIMARY KEY (trip_id, experience_id)
        );
      ''');
        return db.execute('''
        CREATE TABLE IF NOT EXISTS experience(
          id INTEGER PRIMARY KEY NOT NULL,
          experience TEXT
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

  @override
  Future<void> addParticipantToTrip(int tripId, int participantId) async {
    final db = await _initDb();
    await db.insert('trips_participant', {
      'trip_id': tripId,
      'participant_id': participantId,
    });
  }

  @override
  Future<void> removeParticipantFromTrip(int tripId, int participantId) async {
    final db = await _initDb();
    await db.delete(
      'trip_participant',
      where: 'trip_id = ? AND participant_id = ?',
      whereArgs: [tripId, participantId],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> listParticipantsFromTrip(int tripId) async {
    final db = await _initDb();
    return await db.rawQuery('''
      SELECT P.* FROM participants AS P
      JOIN trip_participant AS TP ON P.id = TP.participant_id
      WHERE TP.trip_id = ?
    ''', [tripId]);
  }
}
