import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'trip_planner.db'); // DB's name

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
        CREATE TABLE  stopoverTable(
          stopoverID INTEGER PRIMARY KEY AUTOINCREMENT,
          cityName TEXT NOT NULL,
          arrivalDate TEXT NOT NULL,
          departureDate TEXT NOT NULL,
          longitude REAL NOT NUL
          latitude REAL NOT NULL,
          actvDescription TEXT,
        )
    ''');

    await db.execute('''
    CREATE TABLE tripTable(
      tripID INTEGER PRIMARY KEY AUTOINCREMENT,
      experienceList TEXT,
      startDate TEXT NOT NULL,
      endDate TEXT NOT NULL,
      tripTitle TEXT NOT NULL,
      transportationMethod TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE participantTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      age INTEGER NOT NULL,
      photoPath TEXT,
      favoriteTransport TEXT NOT NULL
    )
  ''');

    await db.execute('''
      CREATE TABLE trip_participant_table(
        trip_id INTEGER,
        participant_id INTEGER,
        FOREIGN KEY (trip_id) REFERENCES tripTable(tripID),
        FOREIGN KEY (participant_id) REFERENCES participantTable(id),
        PRIMARY KEY (trip_id, participant_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reviewTable(
        reviewID INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        photoPath TEXT,
        participant_id INTEGER,
        stopover_id INTEGER,
        FOREIGN KEY (participant_id) REFERENCES participantTable(id),
        FOREIGN KEY (stopover_id) REFERENCES stopoverTable(stopoverID)
      )
    ''');

  }
}
