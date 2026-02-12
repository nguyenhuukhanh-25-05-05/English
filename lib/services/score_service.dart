import 'package:flutter/material.dart';
import 'package:english/services/database_service.dart';

/// Manages daily score/XP tracking with SQLite persistence and Rank system
class ScoreService extends ChangeNotifier {
  ScoreService._();
  static final ScoreService instance = ScoreService._();

  int _dailyXP = 0;
  int _totalXP = 0;
  int _level = 1;
  int _streak = 0;
  int _testsCompleted = 0;
  int _bestToeicScore = 0; // 0-990
  String _name = 'Nguyễn Hữu Khánh';
  String _email = '';
  String _bio = '';
  String _avatarPath = '';
  int _totalTimeSeconds = 0;
  int _wordsLearned = 0;
  String _lastActiveDate = '';
  String _lastCheckInSeenDate = '';

  int get dailyXP => _dailyXP;
  int get totalXP => _totalXP;
  int get level => _level;
  int get streak => _streak;
  int get testsCompleted => _testsCompleted;
  int get bestToeicScore => _bestToeicScore;
  String get name => _name;
  String get email => _email;
  String get bio => _bio;
  String get avatarPath => _avatarPath;
  int get totalTimeSeconds => _totalTimeSeconds;
  int get wordsLearned => _wordsLearned;

  // Rank Logic: Promotes every 10 levels
  String get rankName {
    if (_level < 10) return 'Người bắt đầu';
    if (_level < 20) return 'Học viên tiềm năng';
    if (_level < 30) return 'Người học chuyên nghiệp';
    if (_level < 40) return 'Chuyên gia ngôn ngữ';
    if (_level < 50) return 'Bậc thầy TOEIC';
    return 'Kỳ tài Anh ngữ';
  }

  // Progress within the current level (1000 XP per level)
  double get levelProgress => (_totalXP % 1000) / 1000;
  int get xpInCurrentLevel => _totalXP % 1000;

  bool get shouldShowAttendance {
    final today = _getTodayString();
    return _lastCheckInSeenDate != today;
  }

  static const int dailyGoal = 500;

  static const int quickTestPoints = 100;
  static const int topicPoints = 20;
  static const int miniTestPoints = 200;
  static const int fullTestPoints = 400;

  // Loading data from database
  Future<void> init() async {
    final stats = await DatabaseService.instance.getStatistics();
    _dailyXP = stats['dailyXP'] ?? 0;
    _totalXP = stats['totalXP'] ?? 0;
    _level = stats['level'] ?? 1;
    _streak = stats['streak'] ?? 0;
    _testsCompleted = stats['testsCompleted'] ?? 0;
    _bestToeicScore = stats['bestToeicScore'] ?? 0;
    _name = stats['name'] ?? 'Nguyễn Hữu Khánh';
    _email = stats['email'] ?? '';
    _bio = stats['bio'] ?? '';
    _avatarPath = stats['avatarPath'] ?? '';
    _totalTimeSeconds = stats['totalTimeSeconds'] ?? 0;
    _wordsLearned = stats['wordsLearned'] ?? 0;
    _lastActiveDate = stats['lastActiveDate'] ?? '';
    _lastCheckInSeenDate = stats['lastCheckInSeenDate'] ?? '';

    _checkDate(); // Check for streak/reset on load
    notifyListeners();
  }

  String _getTodayString() {
    // Vietnam Time is GMT+7
    return DateTime.now()
        .toUtc()
        .add(const Duration(hours: 7))
        .toIso8601String()
        .substring(0, 10);
  }

  Future<void> markCheckInSeen() async {
    _lastCheckInSeenDate = _getTodayString();
    await _saveToDB();
    notifyListeners();
  }

  void _resetDailyXP() {
    _dailyXP = 0;
  }

  void _checkDate() {
    final today = _getTodayString();
    bool changed = false;

    if (_lastActiveDate != today) {
      _resetDailyXP();
      if (_lastActiveDate.isNotEmpty) {
        final lastDate = DateTime.tryParse(_lastActiveDate);
        final now = DateTime.now().toUtc().add(const Duration(hours: 7));
        if (lastDate != null) {
          final diff = DateTime(now.year, now.month, now.day)
              .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
              .inDays;
          if (diff == 1) {
            _streak++;
          } else if (diff > 1) {
            _streak = 1;
          }
        }
      } else {
        _streak = 1;
      }
      _dailyXP = 0;
      _lastActiveDate = today;
      changed = true;
    }

    if (changed) {
      _saveToDB();
    }
  }

  Future<void> addPoints(
    int points, {
    int? scorePercent,
    bool isFullTest = false,
  }) async {
    _checkDate();
    _dailyXP += points;
    _totalXP += points;
    _testsCompleted++;

    // Calculate level based on total XP (1000 XP/level)
    final newLevel = (_totalXP / 1000).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      // Handle level up rewards or rank name change notifications if needed
    }

    if (isFullTest && scorePercent != null) {
      // Mapping percentage to TOEIC scale (max 990)
      final toeicScore = (scorePercent * 9.9).round();
      if (toeicScore > _bestToeicScore) {
        _bestToeicScore = toeicScore;
      }
    }

    await _saveToDB();
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? avatarPath,
  }) async {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (bio != null) _bio = bio;
    if (avatarPath != null) _avatarPath = avatarPath;
    await _saveToDB();
    notifyListeners();
  }

  Future<void> addPracticeStats({int? seconds, int? words}) async {
    if (seconds != null) _totalTimeSeconds += seconds;
    if (words != null) _wordsLearned += words;
    await _saveToDB();
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _name = newName;
    await _saveToDB();
    notifyListeners();
  }

  Future<void> _saveToDB() async {
    await DatabaseService.instance.updateStatistics({
      'dailyXP': _dailyXP,
      'totalXP': _totalXP,
      'level': _level,
      'streak': _streak,
      'testsCompleted': _testsCompleted,
      'bestToeicScore': _bestToeicScore,
      'name': _name,
      'email': _email,
      'bio': _bio,
      'avatarPath': _avatarPath,
      'totalTimeSeconds': _totalTimeSeconds,
      'wordsLearned': _wordsLearned,
      'lastActiveDate': _lastActiveDate,
      'lastCheckInSeenDate': _lastCheckInSeenDate,
    });
  }

  Future<void> resetStats() async {
    await DatabaseService.instance.clearAllData();
    _dailyXP = 0;
    _totalXP = 0;
    _level = 1;
    _streak = 0;
    _testsCompleted = 0;
    _bestToeicScore = 0;
    _name = 'Nguyễn Hữu Khánh';
    _email = '';
    _bio = '';
    _avatarPath = '';
    _totalTimeSeconds = 0;
    _wordsLearned = 0;
    _lastActiveDate = '';
    _lastCheckInSeenDate = '';
    notifyListeners();
  }

  double get dailyProgress => (_dailyXP / dailyGoal).clamp(0.0, 1.0);

  String get motivationText {
    if (_dailyXP >= dailyGoal) {
      return 'Tuyệt vời! Bạn đã đạt mục tiêu hôm nay! 🎉';
    }
    if (_dailyXP >= dailyGoal * 0.7) {
      return 'Gần đạt mục tiêu rồi, cố lên! 💪';
    }
    if (_dailyXP >= dailyGoal * 0.3) {
      return 'Tiến bộ tốt, tiếp tục nhé! 🔥';
    }
    if (_dailyXP > 0) {
      return 'Khởi đầu tốt, hãy tiếp tục! ⭐';
    }
    return 'Bắt đầu ngày mới nào! 🚀';
  }
}
