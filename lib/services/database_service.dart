import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'english_learning.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // This migration adds the 'level' column if it was missing in older versions.
      // However, in the provided _createDB, 'level' is already present.
      // This specific migration might be redundant if _createDB is always used for initial creation.
      // But if an older version of the app existed without 'level' in _createDB, this would add it.
      // For the given _createDB, 'level' is already there, so this specific ALTER TABLE might not be strictly necessary
      // for *this* exact schema, but it's a good example of how to handle schema changes.
      // Let's assume the user wants to add it as a migration step for a hypothetical older schema.
      await db.execute(
        'ALTER TABLE statistics ADD COLUMN level INTEGER DEFAULT 1',
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Create statistics table
    await db.execute('''
      CREATE TABLE statistics (
        id INTEGER PRIMARY KEY DEFAULT 1,
        dailyXP INTEGER DEFAULT 0,
        totalXP INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        streak INTEGER DEFAULT 0,
        testsCompleted INTEGER DEFAULT 0,
        bestToeicScore INTEGER DEFAULT 0,
        name TEXT DEFAULT 'Nguyễn Hữu Khánh',
        email TEXT DEFAULT '',
        bio TEXT DEFAULT '',
        avatarPath TEXT DEFAULT '',
        totalTimeSeconds INTEGER DEFAULT 0,
        wordsLearned INTEGER DEFAULT 0,
        lastActiveDate TEXT DEFAULT '',
        lastCheckInSeenDate TEXT DEFAULT ''
      )
    ''');

    // Create exam_sessions table for persistence
    await db.execute('''
      CREATE TABLE exam_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        current_index INTEGER,
        correct_count INTEGER,
        seconds_left INTEGER,
        answers_json TEXT,
        is_completed INTEGER DEFAULT 0,
        timestamp TEXT
      )
    ''');

    // Insert initial row for statistics
    await db.insert('statistics', {
      'dailyXP': 0,
      'totalXP': 0,
      'level': 1,
      'streak': 0,
      'testsCompleted': 0,
      'bestToeicScore': 0,
      'name': 'Nguyễn Hữu Khánh',
      'email': '',
      'bio': '',
      'avatarPath': '',
      'totalTimeSeconds': 0,
      'wordsLearned': 0,
      'lastActiveDate': '',
      'lastCheckInSeenDate': '',
    });
  }

  // Exam Session Persistence Methods
  Future<void> saveExamSession(Map<String, dynamic> session) async {
    final db = await database;
    // Check if session for this title already exists and is not completed
    final existing = await db.query(
      'exam_sessions',
      where: 'title = ? AND is_completed = 0',
      whereArgs: [session['title']],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'exam_sessions',
        session,
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('exam_sessions', session);
    }
  }

  Future<Map<String, dynamic>?> getActiveExamSession(String title) async {
    final db = await database;
    final results = await db.query(
      'exam_sessions',
      where: 'title = ? AND is_completed = 0',
      whereArgs: [title],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> completeExamSession(String title) async {
    final db = await database;
    await db.update(
      'exam_sessions',
      {'is_completed': 1},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    final results = await db.query(
      'statistics',
      where: 'id = ?',
      whereArgs: [1],
    );
    return results.first;
  }

  Future<void> updateStatistics(Map<String, dynamic> data) async {
    final db = await database;
    await db.update('statistics', data, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('statistics');
    await db.delete('exam_sessions');
    // Re-insert initial statistics
    await db.insert('statistics', {
      'dailyXP': 0,
      'totalXP': 0,
      'level': 1,
      'streak': 0,
      'testsCompleted': 0,
      'bestToeicScore': 0,
      'name': 'Nguyễn Hữu Khánh',
      'email': '',
      'bio': '',
      'avatarPath': '',
      'totalTimeSeconds': 0,
      'wordsLearned': 0,
      'lastActiveDate': '',
      'lastCheckInSeenDate': '',
    });
  }

  // Bookmark Methods
  Future<void> addBookmark(String word) async {
    final db = await database;
    await db.insert('bookmarks', {
      'word': word,
      'timestamp': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeBookmark(String word) async {
    final db = await database;
    await db.delete('bookmarks', where: 'word = ?', whereArgs: [word]);
  }

  Future<List<String>> getBookmarks() async {
    final db = await database;
    final results = await db.query('bookmarks', columns: ['word']);
    return results.map((e) => e['word'] as String).toList();
  }
}
