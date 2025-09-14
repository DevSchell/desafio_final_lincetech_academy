import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/review.dart';

/// Defines the interface for the review repository.
///
/// This interface establishes the contract that any review repository class
/// must follow.
abstract interface class ReviewRepository {
  /// Creates a new review in the repository.
  ///
  /// Returns the ID of the inserted record.
  Future<int> createReview(Review review);

  /// Lists all reviews associated with a specific stopover.
  ///
  /// The [stopoverId] is the identifier of the stopover.
  /// Returns a list of [Review] objects.
  Future<List<Review>> listReviewFromStopover(int stopoverId);

  /// Deletes a review based on its ID.
  ///
  /// The [reviewId] is the identifier of the review to be deleted.
  Future<void> deleteReview(int reviewId);
}

/// An implementation of [ReviewRepository] using the SQLite database.
///
/// This class manages the persistence operations for reviews in an SQLite
/// database, encapsulating the data access logic.
class ReviewRepositorySQLite implements ReviewRepository {
  Database? _db;

  /// Initializes and returns the SQLite database instance.
  ///
  /// If the database instance already exists, it is reused; otherwise, a new
  /// connection is opened to the [wanderplan.db] file. This method ensures
  /// that a single database instance is available for all operations.
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
