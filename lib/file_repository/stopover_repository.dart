import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../entities/stopover.dart';

/// This abstract interface defines the contract for all data operations
/// related to stopovers. It specifies the methods for creating, retrieving,
/// updating, and deleting stopovers, as well as managing their relationships
/// with trips.
abstract interface class StopoverRepository {

  /// Creates a new stopover record in the database.
  Future<void> createStopover(Stopover stopover);

  /// Retrieves a list of all stopovers associated with a specific trip.
  Future<List<Stopover>> listStopovers(int idTravel);

  /// Updates an existing stopover record.
  Future<void> updateStopover(Stopover stopover);

  /// Deletes a stopover record from the database.
  Future<void> deleteStopover(Stopover stopover);

  /// Links an existing stopover to a trip.
  Future<void> addStopoverToTrip(int tripId, int stopoverId);

  /// Removes the link between a stopover and a trip.
  Future<void> removeStopoverFromTrip(int tripId, int stopoverId);

  /// Retrieves a list of stopovers for a specific trip, returning the data
  /// as a list of maps.
  Future<List<Map<String, dynamic>>> listStopoversFromTrip(int tripId);
}

/// A concrete implementation of the [StopoverRepository] interface
/// using SQLite as the data persistence layer.
class StopoverRepositorySQLite implements StopoverRepository {
  Database? _db;

  /// Initializes and returns a database instance.
  /// If the database connection is already open, it returns the instance.
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

    await db.delete('stopovers', where: 'id = ?', whereArgs: [stopover.id]);
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
