//TODO: Esse warning não sai daqui... Pq?
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/participant.dart';

/// An interface of a file_repository using SQLite.
abstract interface class ParticipantRepository {

  /// Creates a new participant entry in the 'trip_participant' table.
  /// This method uses the participant's data to insert a new record.
  Future<void> createParticipant(Participant participant);

  /// Retrieves a list of participants for a given trip ID.
  /// It performs a JOIN query on tables 'participants' and 'trip_participant'
  /// to fetch all participants linked to the specified trip.
  Future<List<Participant>> listParticipants(int idTravel);

  /// Updates an existing participant's information in the 'participants' table.
  /// The update is performed using the participant's unique ID.
  Future<void> updateParticipant(Participant participant);

  /// Deletes a participant from the 'participants' table using their unique ID.
  Future<void> deleteParticipant(Participant participant);

  /// Links an existing participant to a trip by inserting a record into the
  /// 'trip_participant' junction table.
  Future<void> addParticipantToTrip(int tripId, int participantId);

  /// Removes the link between a participant and a trip by deleting the
  /// record from the 'trip_participant' junction table.
  Future<void> removeParticipantFromTrip(int tripId, int participantId);
}

/// A concrete implementation of the [ParticipantRepository] interface
/// using SQLite as the data persistence layer.
class ParticipantRepositorySQLite implements ParticipantRepository {
  Database? _db;

  /// Initializes and returns a database instance.
  /// If the database connection is already open, it returns the open instance.
  Future<Database> initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wanderplan.db');

    _db = await openDatabase(path);
    return _db!;
  }

  /// Creates a new participant entry in the 'trip_participant' table.
  /// This method uses the participant's data to insert a new record.
  @override
  Future<void> createParticipant(Participant participant) async {
    final db = await initDb();
    await db.insert('trip_participant', participant.toMap(null));
  }

  /// Retrieves a list of participants for a given trip ID.
  /// It performs a JOIN query on tables 'participants' and 'trip_participant'
  /// to fetch all participants linked to the specified trip.
  @override
  Future<List<Participant>> listParticipants(int idTravel) async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT P.*FROM participants AS P
      JOIN trip_participant AS TP ON P.id = TP.participant_id
      WHERE TP.trip_id = ?
    ''',
      [idTravel],
    );
    return List.generate(maps.length, (i) {
      return Participant.fromMap(maps[i]);
    });
  }

  /// Updates an existing participant's information in the 'participants' table.
  /// The update is performed using the participant's unique ID.
  @override
  Future<void> updateParticipant(Participant participant) async {
    final db = await initDb();

    if (participant.id == null) {
      return;
    }

    await db.update(
      'participants',
      participant.toMap(null),
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }

  /// Deletes a participant from the 'participants' table using their unique ID.
  @override
  Future<void> deleteParticipant(Participant participant) async {
    final db = await initDb();

    if (participant.id == null) {
      return;
    }

    await db.delete(
      'participants',
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }

  /// Links an existing participant to a trip by inserting a record into the
  /// 'trip_participant' junction table.
  @override
  Future<void> addParticipantToTrip(int tripId, int participantId) async {
    final db = await initDb();
    await db.insert('trip_participant', {
      'trip_id': tripId,
      'participant_id': participantId,
    });
  }

  /// Removes the link between a participant and a trip by deleting the
  /// record from the 'trip_participant' junction table.
  @override
  Future<void> removeParticipantFromTrip(int tripId, int participantId) async {
    final db = await initDb();
    await db.delete(
      'trip_participant',
      where: 'trip_id = ? AND participant_id = ?',
      whereArgs: [tripId, participantId],
    );
  }
}
