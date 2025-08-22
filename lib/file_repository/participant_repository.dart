import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:desafio_final_lincetech_academy/entities/participant.dart';

abstract interface class ParticipantRepository {
  Future<void> createParticipant(Participant participant);

  Future<List<Participant>> listParticpants(Participant participant);

  Future<void> updateParticipant(Participant participant);

  Future<void> deleteParticipant(Participant participant);
}

class ParticipantRepositorySQLite implements ParticipantRepository {
  Database? _db;

  Future<Database> _initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'participants.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE participants(
          id INTEGER NOT NULL,
          name TEXT,
          date_of_birth DATETIME,
          photo_path TEXT,
          favorite_transport TEXT,
          PRIMARY KEY (id)
        );
        ''');
      },
    );
    return _db!;
  }

  @override
  Future<void> createParticipant(Participant participant) async {
    final db = await _initDb();
    await db.insert('participants', participant.toMap());
  }

  @override
  Future<List<Participant>> listParticpants(Participant participant) async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('participants');
    return List.generate(maps.length, (i) {
      return Participant.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    final db = await _initDb();

    if (participant.id == null) {
      return;
    }

    await db.update(
      'participants',
      participant.toMap(),
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }

  @override
  Future<void> deleteParticipant(Participant participant) async {
    final db = await _initDb();

    if (participant.id == null) {
      return;
    }

    await db.delete(
      'participants',
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }
}
