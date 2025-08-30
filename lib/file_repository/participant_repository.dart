import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:desafio_final_lincetech_academy/entities/participant.dart';

abstract interface class ParticipantRepository {
  Future<void> createParticipant(Participant participant);

  Future<List<Participant>> listParticipants(int idTravel);

  Future<void> updateParticipant(Participant participant);

  Future<void> deleteParticipant(Participant participant);

  //New methods
  Future<void> addParticipantToTrip(int tripId, int participantId);

  Future<void> removeParticipantFromTrip(int tripId, int participantId);
}

class ParticipantRepositorySQLite implements ParticipantRepository {
  Database? _db;

  Future<Database> initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wanderplan.db');

    _db = await openDatabase(path);
    return _db!;
  }

  @override
  Future<void> createParticipant(Participant participant) async {
    final db = await initDb();
    await db.insert('trip_participant', participant.toMap(null));
  }

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

  @override
  Future<void> addParticipantToTrip(int tripId, int participantId) async {
    final db = await initDb();
    await db.insert('trip_participant', {
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
}
