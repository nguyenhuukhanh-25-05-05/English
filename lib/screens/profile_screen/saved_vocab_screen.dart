import 'package:flutter/material.dart';
import 'package:english/services/bookmark_service.dart';
import 'package:english/data/vocabulary_data.dart';
import 'package:english/data/vocab_models.dart';
import 'package:english/services/tts_service.dart';

class SavedVocabScreen extends StatelessWidget {
  const SavedVocabScreen({super.key});

  List<VocabWord> _getSavedWords() {
    final bookmarked = BookmarkService.instance.bookmarkedWords;
    final allWords = <VocabWord>[];
    for (var topic in allTopics) {
      allWords.addAll(topic.words);
    }
    return allWords.where((w) => bookmarked.contains(w.word)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TỪ VỰNG ĐÃ LƯU',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: BookmarkService.instance,
        builder: (context, _) {
          final savedWords = _getSavedWords();
          if (savedWords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có từ vựng nào được lưu',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: savedWords.length,
            itemBuilder: (context, index) {
              final word = savedWords[index];
              return _SavedWordCard(word: word);
            },
          );
        },
      ),
    );
  }
}

class _SavedWordCard extends StatelessWidget {
  const _SavedWordCard({required this.word});
  final VocabWord word;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF3B82F6);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, color: color),
                  onPressed: () => TtsService.instance.speak(word.word),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () =>
                      BookmarkService.instance.toggleBookmark(word.word),
                ),
              ],
            ),
            Text(
              word.phonetic,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              word.meaning,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
