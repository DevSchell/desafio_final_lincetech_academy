import 'package:sqflite/sqflite.dart';
import '../entities/stopover.dart';
import 'package:path/path.dart';

abstract interface class StopoverRepository {
  Future<void> createStopover(Stopover stopover);

  Future<List<Stopover>> listStopovers();

  Future<void> updateStopover(Stopover stopover);

  Future<void> deleteStopover(Stopover stopover);
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
        return db.execute('''
          CREATE TABLE stopovers(
            id INTEGER NOT NULL,
            city_name TEXT,
            latitude REAL,
            longitude REAL,
            arrival_date DATETIME,
            departure_date DATETIME,
            actv_description TEXT,
            PRIMARY KEY(id)
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
  Future<List<Stopover>> listStopovers() async {
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
}
