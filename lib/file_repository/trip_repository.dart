import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../entities/participant.dart';
import '../entities/review.dart';
import '../entities/stopover.dart';
import '../entities/trip.dart';

/// This interface defines the contract for any class that handles the
/// persistence of [Trip], including relationships with
/// participants and stopovers.
abstract interface class TripRepository {
  /// Creates a new trip record in the database.
  Future<void> createTrip(Trip trip);

  /// Retrieves a list of all trips from the database.
  Future<List<Trip>> listTrips();

  /// Updates an existing trip record.
  Future<void> updateTrip(Trip trip);

  /// Deletes a trip record from the database.
  Future<void> deleteTrip(Trip trip);

  /// Links a participant to a trip.
  Future<void> addParticipantToTrip(int tripId, int participantId);

  /// Removes the link between a participant and a trip.
  Future<void> removeParticipantFromTrip(int tripId, int participantId);

  /// Retrieves a list of all participants associated with a specific trip.
  Future<List<Participant>?> listParticipantsFromTrip(int tripId);

  /// Links a stopover to a trip.
  Future<void> addStopoverToTrip(int tripId, int stopoverId);

  /// Removes the link between a stopover and a trip.
  Future<void> removeStopoverFromTrip(int tripId, int stopoverId);

  /// Retrieves a list of all stopovers associated with a specific trip.
  Future<List<Stopover>?> listStopoversFromTrip(int? tripId);

  // New methods
  Future<int> createReview(Review review);

  Future<List<Review>> listReviewFromStopover(int stopoverId);

  Future<void> deleteReview(int reviewId);
}

/// A concrete implementation of the [TripRepository] interface
/// using SQLite as the data persistence layer.
class TripRepositorySQLite implements TripRepository {
  Database? _db;

  /// Initializes and returns a database instance.
  /// If the database connection is already open, it returns the existing instance.
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
          transportation_method TEXT,
          experiences_list TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS trip_participant(
          id              INTEGER PRIMARY KEY NOT NULL,
          trip_id         INTEGER NOT NULL,
          participant_id  INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (participant_id) REFERENCES participants(id),
          UNIQUE (trip_id, participant_id)
        )
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
        )
        ''');

        // -----------------------------------------------------

        await db.execute('''
        CREATE TABLE IF NOT EXISTS stopovers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          city_name TEXT,
          latitude REAL,
          longitude REAL,
          arrival_date TEXT,
          departure_date TEXT,
          actv_description TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS reviews(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          stopover_id INTEGER NOT NULL,
          participant_id INTEGER,
          message TEXT,
          photo_path TEXT,
          FOREIGN KEY (stopover_id) REFERENCES stopovers(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS trip_stopover(
          trip_id INTEGER NOT NULL,
          stopover_id INTEGER NOT NULL,
          FOREIGN KEY (trip_id) REFERENCES trips(id),
          FOREIGN KEY (stopover_id) REFERENCES stopovers(id),
          PRIMARY KEY (trip_id, stopover_id)
        )
      ''');
      },
    );
    return _db!;
  }

  @override
  Future<void> createTrip(Trip trip) async {
    final db = await initDb();

    final id = await db.insert('trips', trip.toMap());
    trip.id = id;

    for (final participant in trip.participantList ?? <Participant>[]) {
      final id = await db.insert('participants', participant.toMap(trip.id));

      await db.insert('trip_participant', {
        'trip_id': trip.id,
        'participant_id': id,
      });
    }

    for (final stopover in trip.stopoverList ?? <Stopover>[]) {
      final stopoverId = await db.insert('stopovers', stopover.toMap());


      await db.insert('trip_stopover', {
        'trip_id': trip.id,
        'stopover_id': stopoverId,
      });
    }
  }

  @override
  Future<List<Trip>> listTrips() async {
    final db = await initDb();
    final List<Map<String, dynamic>> tripMaps = await db.query('trips');
    final trips = <Trip>[];

    for (final tripMap in tripMaps) {
      final trip = Trip.fromMap(tripMap);
      final participants = await listParticipantsFromTrip(trip.id!);
      final stopovers = await listStopoversFromTrip(trip.id);
      trip.stopoverList = stopovers;
      trip.participantList = participants;
      trips.add(trip);
    }

    return trips;
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

    /// Gather all participants from specific trip
    final participantIds = await db.query(
      'trip_participant',
      columns: ['participant_id'],
      where: 'trip_id = ?',
      whereArgs: [trip.id],
    );

    /// Gather all stopover from specific trip
    final stopoverIds = await db.query(
      'trip_stopover',
      columns: ['stopover_id'],
      where: 'trip_id = ?',
      whereArgs: [trip.id],
    );

    await db.delete(
      'trip_participant',
      where: 'trip_id = ?',
      whereArgs: [trip.id],
    );

    await db.delete(
      'trip_stopover',
      where: 'trip_id = ?',
      whereArgs: [trip.id],
    );

    await db.delete('trips', where: 'id = ?', whereArgs: [trip.id]);

    // Checks and deletes participants who are not linked to any trip
    for (final participant in participantIds) {
      final participantId = participant['participant_id'];
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM trip_participant WHERE participant_id = ?',
          [participantId],
        ),
      );

      if (count == 0) {
        await db.delete(
          'participants',
          where: 'id = ?',
          whereArgs: [participantId],
        );
      }
    }

    // Checks and deletes stopovers which are not linked to any trips
    for (final stopover in stopoverIds) {
      final stopoverId = stopover['stopover_id'];
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM trip_stopover WHERE stopover_id = ?',
          [stopoverId],
        ),
      );

      if (count == 0) {
        await db.delete('stopovers', where: 'id = ?', whereArgs: [stopoverId]);
      }
    }
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
  Future<void> removeParticipantFromTrip(
    int? tripId,
    int? participantId,
  ) async {
    final db = await initDb();
    await db.delete(
      'trip_participant',
      where: 'trip_id = ? AND participant_id = ?',
      whereArgs: [tripId, participantId],
    );
  }

  @override
  Future<List<Stopover>?> listStopoversFromTrip(int? tripId) async {
    final db = await initDb();
    final result = await db.rawQuery(
      '''
    SELECT S.id, S.city_name, S.latitude, S.longitude, S.arrival_date, S.departure_date, S.actv_description FROM stopovers AS S
    JOIN trip_stopover AS TS ON S.id = TS.stopover_id
    WHERE TS.trip_id = ?
  ''',
      [tripId],
    );

    final stopovers = <Stopover>[];

    for (final item in result) {
      final stopover = Stopover(
        id: item['id'] as int,
        cityName: item['city_name'] as String,
        latitude: item['latitude'] as double,
        longitude: item['longitude'] as double,
        arrivalDate: DateTime.parse(item['arrival_date'] as String),
        departureDate: DateTime.parse(item['departure_date'] as String),
        actvDescription: item['actv_description'] as String?,
      );
      stopovers.add(stopover);
    }

    return stopovers;
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

  @override
  Future<void> addStopoverToTrip(int tripId, int stopoverId) async {
    final db = await initDb();
    await db.insert('trip_stopover', {
      'trip_id': tripId,
      'stopover_id': stopoverId,
    });
  }

  @override
  Future<void> removeStopoverFromTrip(int tripId, int stopoverId) async {
    final db = await initDb();
    await db.delete(
      'trip_stopover',
      where: 'trip_id = ? AND stopover_id = ?',
      whereArgs: [tripId, stopoverId],
    );
  }

  @override
  Future<int> createReview(Review review) async {
    final db = await initDb();
    return await db.insert('reviews', review.toMap());
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    final db = await initDb();
    await db.delete('reviews', where: 'id = ?', whereArgs: [reviewId]);
  }

  @override
  Future<List<Review>> listReviewFromStopover(int stopoverId) async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      where: 'stopover_id = ?',
      whereArgs: [stopoverId],
    );

    return List.generate(maps.length, (i) {
      return Review.fromMap(maps[i]);
    });
  }

  Future<Participant?> getParticipantById(int? participantId) async {
    final db = await initDb();
    final result = await db.query(
      'participants',
      where: 'id = ?',
      whereArgs: [participantId],
    );
    if (result.isNotEmpty) {
      return Participant.fromMap(result.first);
    }
    return null;
  }
}
