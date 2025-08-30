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
  Future<void> createStopover(Stopover stopover) async {
    final db = await initDb();
    await db.insert('stopovers', stopover.toMap());
  }

  @override
  Future<List<Stopover>> listStopovers(int idTravel) async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('stopovers');

    return List.generate(maps.length, (i) {
      return Stopover.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateStopover(Stopover stopover) async {
    final db = await initDb();

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
    final db = await initDb();

    if (stopover.id == null) {
      return;
    }

    await db.delete('table', where: 'id = ?', whereArgs: [stopover.id]);
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
  Future<List<Map<String, dynamic>>> listStopoversFromTrip(int tripId) async {
    final db = await initDb();
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
