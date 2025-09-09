import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

abstract interface class ReviewRepository {
  Future<int> createReview(Review review);

  Future<List<Review>> listReviewFromStopover(int stopoverId);

  Future<void> deleteReview(int reviewId);
}

class ReviewRepositorySQLite implements ReviewRepository {
  Database? _db;

  Future<Database> initDb() async {
    if (_db != null) {
      return _db!;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wanderplan.db');
    _db = await openDatabase(path, version: 1);
    return _db!;
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
}
