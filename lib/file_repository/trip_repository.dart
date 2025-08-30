import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../entities/participant.dart';
import '../entities/stopover.dart';
import '../entities/trip.dart';

abstract interface class TripRepository {
  Future<void> createTrip(Trip trip);

  Future<List<Trip>> listTrips();

  Future<void> updateTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);

  //New methods
  Future<void> addParticipantToTrip(int tripId, int participantId);

  Future<void> removeParticipantFromTrip(int tripId, int participantId);

  Future<List<Participant>?> listParticipantsFromTrip(int tripId);
}

class TripRepositorySQLite implements TripRepository {
  Database? _db;

  Future<Database> initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wanderplan.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS trips(
          id INTEGER PRIMARY KEY NOT NULL,
          title TEXT,
          start_date TEXT,
          end_date TEXT,
          transportation_method TEXT
        );
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS trip_participant(
          id              INTEGER PRIMARY KEY NOT NULL,
          trip_id         INTEGER NOT NULL,
          participant_id  INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (participant_id) REFERENCES participants(id),
          UNIQUE (trip_id, participant_id)
        );
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS participants(
          id                  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          name                TEXT,
          date_of_birth       TEXT,
          photo_path          TEXT,
          favorite_transport  TEXT,
          trip_id             INTEGER,
          UNIQUE(id)
        );
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS experiences(
          id          INTEGER PRIMARY KEY NOT NULL,
          experience  TEXT
        );
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS trip_experience(
          id              INTEGER PRIMARY KEY NOT NULL,
          trip_id         INTEGER NOT NULL,
          experience_id   INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (experience_id) REFERENCES experiences(id),
          UNIQUE (trip_id, experience_id)
        );
      ''');

        // -----------------------------------------------------

        await db.execute('''
        CREATE TABLE stopovers(
          id INTEGER NOT NULL,
          city_name TEXT,
          latitude REAL,
          longitude REAL,
          arrival_date TEXT,
          departure_date TEXT,
          actv_description TEXT,
          PRIMARY KEY(id)
        );
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS review(
          id INTEGER NOT NULL,
          stopover_id INTEGER NOT NULL,
          message TEXT,
          photo_path TEXT,
          FOREIGN KEY (stopover_id) REFERENCES stopovers(id),
          PRIMARY KEY(id)
        );
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS trip_stopover(
          trip_id INTEGER NOT NULL,
          stopover_id INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (stopover_id) REFERENCES stopovers(id),
          PRIMARY KEY (trip_id, stopover_id)
        );
      ''');
      },
    );
    return _db!;
  }

  @override
  Future<void> createTrip(Trip trip) async {
    final db = await initDb();

    final id = await db.insert('trips', trip.toMap());
    // Coloquei isso
    trip.id = id;

    print('Ç52');
    print(trip.participantList?.isEmpty ?? true);

    for (final participant in trip.participantList ?? <Participant>[]) {
      final id = await db.insert('participants', participant.toMap(trip.id));
      print('ÇÇÇÇÇÇ');
      print(participant.name);

      await db.insert('trip_participant', {
        'trip_id': trip.id,
        'participant_id': id,
      });
    }

    for (final stopover in trip.stopoverList ?? <Stopover>[]) {
      final id = await db.insert('stopovers', stopover.toMap());

      await db.insert('trip_stopover', {'trip_id': trip.id, 'stopover_id': id});
    }
  }

  @override
  Future<List<Trip>> listTrips() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('trips');
    // Like a "for" but better for this situation
    return List.generate(maps.length, (i) {
      return Trip.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    final db = await initDb();

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
    final db = await initDb();

    if (trip.id == null) {
      return;
    }

    await db.delete('trips', where: 'id = ?', whereArgs: [trip.id]);
  }

  @override
  Future<void> addParticipantToTrip(int tripId, int participantId) async {
    final db = await initDb();
    await db.insert('trips_participant', {
      'trip_id': tripId,
      'participant_id': participantId,
    });
  }

  @override
  Future<void> removeParticipantFromTrip(int tripId, int participantId) async {
    final db = await initDb();
    await db.delete(
      'trip_participant',
      where: 'trip_id = ? AND participant_id = ?',
      whereArgs: [tripId, participantId],
    );
  }

  @override
  Future<List<Participant>?> listParticipantsFromTrip(int tripId) async {
    final db = await initDb();

    final result = await db.rawQuery(
      '''
      SELECT DISTINCT p.id          AS id,
             p.name                 AS name,
             p.date_of_birth        AS date_of_birth,
             p.photo_path           AS photo_path,
             p.favorite_transport   AS favorite_transport
      FROM participants p
        INNER JOIN trip_participant tp ON p.id = tp.participant_id
      WHERE tp.trip_id = ?
    ''',
      [tripId],
    );

    final participants = <Participant>[];

    for (final item in result) {
      final id = item['id'] as int;
      final name = item['name'] as String;
      final dateOfBirth = item['date_of_birth'] as String;
      final photoPath = item['photo_path'] as String;
      final favoriteTransp = item['favorite_transport'] as String;

      final participant = Participant(
        id: id,
        name: name,
        dateOfBirth: DateTime.parse(dateOfBirth),
        photoPath: photoPath,
        favoriteTransp: favoriteTransp,
      );

      participants.add(participant);
    }

    return participants;
  }
}
