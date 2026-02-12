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
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE statistics ADD COLUMN level INTEGER DEFAULT 1',
      );
    }
    if (oldVersion < 3) {
      // Add missing columns to statistics
      try {
        await db.execute(
          'ALTER TABLE statistics ADD COLUMN email TEXT DEFAULT ""',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE statistics ADD COLUMN bio TEXT DEFAULT ""',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE statistics ADD COLUMN avatarPath TEXT DEFAULT ""',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE statistics ADD COLUMN totalTimeSeconds INTEGER DEFAULT 0',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE statistics ADD COLUMN wordsLearned INTEGER DEFAULT 0',
        );
      } catch (_) {}

      // Create bookmarks table if missing
      await db.execute('''
        CREATE TABLE IF NOT EXISTS bookmarks (
          word TEXT PRIMARY KEY,
          timestamp TEXT
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Create statistics table
    await db.execute('''
      CREATE TABLE statistics (
        id INTEGER PRIMARY KEY,
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

    // Create exam_sessions table
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

    // Create bookmarks table
    await db.execute('''
      CREATE TABLE bookmarks (
        word TEXT PRIMARY KEY,
        timestamp TEXT
      )
    ''');

    // Insert initial row for statistics
    await db.insert('statistics', {
      'id': 1,
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

  Future<List<Map<String, dynamic>>> getCompletedExams() async {
    final db = await database;
    return await db.query(
      'exam_sessions',
      where: 'is_completed = 1',
      orderBy: 'timestamp DESC',
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
      'id': 1,
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
