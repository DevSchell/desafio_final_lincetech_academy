import 'package:sqflite/sqflite.dart';
import '../entities/stopover.dart';
import 'package:path/path.dart';

abstract interface class StopoverRepository {
  Future<void> createStopover(Stopover stopover);

  Future<List<Stopover>> listStopovers(int idTravel);

  Future<void> updateStopover(Stopover stopover);

  Future<void> deleteStopover(Stopover stopover);

  // New methods
  Future<void> addStopoverToTrip(int tripId, int stopoverId);

  Future<void> removeStopoverFromTrip(int tripId, int stopoverId);

  Future<List<Map<String, dynamic>>> listStopoversFromTrip(int tripId);
}

class StopoverRepositorySQLite implements StopoverRepository {
  Database? _db;

  Future<Database> _initDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stopovers.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
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
        db.execute('''
        CREATE TABLE IF NOT EXISTS review(
          id INTEGER NOT NULL,
          stopover_id INTEGER NOT NULL,
          message TEXT,
          photo_path TEXT,
          FOREIGN KEY (stopover_id) REFERENCES stopovers(id),
          PRIMARY KEY(id)
        );
      ''');
        return db.execute('''
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
  Future<void> createStopover(Stopover stopover) async {
    final db = await _initDb();
    await db.insert('stopovers', stopover.toMap());
  }

  @override
  Future<List<Stopover>> listStopovers(int idTravel) async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('stopovers');

    return List.generate(maps.length, (i) {
      return Stopover.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateStopover(Stopover stopover) async {
    final db = await _initDb();

    if (stopover.id == null) {
      return;
    }

    await db.update(
      'stopovers',
      stopover.toMap(),
      where: 'id = ?',
      whereArgs: [stopover.id],
    );
  }

  @override
  Future<void> deleteStopover(Stopover stopover) async {
    final db = await _initDb();

    if (stopover.id == null) {
      return;
    }

    await db.delete('table', where: 'id = ?', whereArgs: [stopover.id]);
  }

  @override
  Future<void> addStopoverToTrip(int tripId, int stopoverId) async {
    final db = await _initDb();
    await db.insert('trip_stopover', {
      'trip_id': tripId,
      'stopover_id': stopoverId,
    });
  }

  @override
  Future<void> removeStopoverFromTrip(int tripId, int stopoverId) async {
    final db = await _initDb();
    await db.delete(
      'trip_stopover',
      where: 'trip_id = ? AND stopover_id = ?',
      whereArgs: [tripId, stopoverId],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> listStopoversFromTrip(int tripId) async {
    final db = await _initDb();
    return await db.rawQuery(
      '''
      SELECT S.* FROM stopovers AS S
      JOIN trip_stopover AS TS ON S.id = TS.stopover_id
      WHERE TS.trip_id = ?
    ''',
      [tripId],
    );
  }
}
