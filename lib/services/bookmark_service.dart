import 'package:flutter/foundation.dart';
import 'package:english/services/database_service.dart';

class BookmarkService extends ChangeNotifier {
  BookmarkService._();
  static final BookmarkService instance = BookmarkService._();

  final Set<String> _bookmarkedWords = {};

  Set<String> get bookmarkedWords => _bookmarkedWords;

  Future<void> init() async {
    final list = await DatabaseService.instance.getBookmarks();
    _bookmarkedWords.clear();
    _bookmarkedWords.addAll(list);
    notifyListeners();
  }

  bool isBookmarked(String word) => _bookmarkedWords.contains(word);

  Future<void> toggleBookmark(String word) async {
    if (_bookmarkedWords.contains(word)) {
      _bookmarkedWords.remove(word);
      await DatabaseService.instance.removeBookmark(word);
    } else {
      _bookmarkedWords.add(word);
      await DatabaseService.instance.addBookmark(word);
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    _bookmarkedWords.clear();
    // Logic to clear bookmarks table if needed
    notifyListeners();
  }
}
