import 'dart:math';
import 'package:english/data/vocabulary_data.dart';
import 'package:english/data/vocab_models.dart';

enum QuestionType { enToVi, viToEn, fillBlank, listenChoose }

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options;
  final QuestionType type;
  final String? speakText;
  final String word;
  final String phonetic;
  final String meaning;
  final String example;

  const QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.type,
    this.speakText,
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
  });
}

class QuizGenerator {
  static final _random = Random();

  /// Generate quiz from specific topics
  static List<QuizQuestion> generateFromTopics(
    List<int> topicIndices,
    int count,
  ) {
    final words = <VocabWord>[];
    for (final i in topicIndices) {
      if (i < allTopics.length) {
        words.addAll(allTopics[i].words);
      }
    }
    return _generateQuestions(words, count);
  }

  /// Generate a structured simulated TOEIC test (200 questions)
  static List<QuizQuestion> generateSimulatedTest(int testNumber) {
    final random = Random(testNumber); // Seed for consistency per test set
    final allWords = <VocabWord>[];
    for (final topic in allTopics) {
      allWords.addAll(topic.words);
    }

    final questions = <QuizQuestion>[];

    // Part 1-4: Listening (Simulated with 100 questions)
    // In a real app we'd use dialogues, here we simulate with word listening & sentences
    final listeningPool = List<VocabWord>.from(allWords)..shuffle(random);
    for (int i = 0; i < 100; i++) {
      questions.add(
        _buildQuestion(listeningPool[i], allWords, QuestionType.listenChoose),
      );
    }

    // Part 5-6: Reading - Grammar & Vocab (Simulated with 50 questions)
    final readingPool = List<VocabWord>.from(allWords)..shuffle(random);
    for (int i = 0; i < 50; i++) {
      questions.add(
        _buildQuestion(
          readingPool[i],
          allWords,
          i % 2 == 0 ? QuestionType.fillBlank : QuestionType.enToVi,
        ),
      );
    }

    // Part 7: Reading Comprehension (Simulated with 50 questions)
    // Note: In real life Part 7 uses passages, here we take another set of vocab/sentences
    final comprehensionPool = List<VocabWord>.from(allWords)..shuffle(random);
    for (int i = 0; i < 50; i++) {
      questions.add(
        _buildQuestion(comprehensionPool[i], allWords, QuestionType.viToEn),
      );
    }

    return questions;
  }

  static List<QuizQuestion> _generateQuestions(
    List<VocabWord> pool,
    int count,
  ) {
    final shuffled = List<VocabWord>.from(pool)..shuffle(_random);
    final selected = shuffled.take(count.clamp(0, shuffled.length)).toList();
    final questions = <QuizQuestion>[];

    for (final word in selected) {
      final type = QuestionType
          .values[_random.nextInt(3)]; // 0-2, skip listenChoose for now
      questions.add(_buildQuestion(word, pool, type));
    }

    return questions;
  }

  static QuizQuestion _buildQuestion(
    VocabWord word,
    List<VocabWord> pool,
    QuestionType type,
  ) {
    switch (type) {
      case QuestionType.enToVi:
        return _enToViQuestion(word, pool);
      case QuestionType.viToEn:
        return _viToEnQuestion(word, pool);
      case QuestionType.fillBlank:
        return _fillBlankQuestion(word, pool);
      case QuestionType.listenChoose:
        return _enToViQuestion(word, pool); // fallback
    }
  }

  /// EN → VI: "What does 'Hello' mean?"
  static QuizQuestion _enToViQuestion(VocabWord word, List<VocabWord> pool) {
    final wrongAnswers = _getWrongOptions(word, pool, (w) => w.meaning);
    final options = [word.meaning, ...wrongAnswers]..shuffle(_random);
    return QuizQuestion(
      question: '"${word.word}" có nghĩa là gì?',
      correctAnswer: word.meaning,
      options: options,
      type: QuestionType.enToVi,
      speakText: word.word,
      word: word.word,
      phonetic: word.phonetic,
      meaning: word.meaning,
      example: word.example,
    );
  }

  /// VI → EN: "Xin chào" means?
  static QuizQuestion _viToEnQuestion(VocabWord word, List<VocabWord> pool) {
    final wrongAnswers = _getWrongOptions(word, pool, (w) => w.word);
    final options = [word.word, ...wrongAnswers]..shuffle(_random);
    return QuizQuestion(
      question: '"${word.meaning}" trong tiếng Anh là gì?',
      correctAnswer: word.word,
      options: options,
      type: QuestionType.viToEn,
      word: word.word,
      phonetic: word.phonetic,
      meaning: word.meaning,
      example: word.example,
    );
  }

  /// Fill in the blank from example sentence
  static QuizQuestion _fillBlankQuestion(VocabWord word, List<VocabWord> pool) {
    final blankSentence = word.example.replaceAll(
      RegExp(RegExp.escape(word.word), caseSensitive: false),
      '______',
    );
    // If can't create blank, fallback to enToVi
    if (blankSentence == word.example) {
      return _enToViQuestion(word, pool);
    }
    final wrongAnswers = _getWrongOptions(word, pool, (w) => w.word);
    final options = [word.word, ...wrongAnswers]..shuffle(_random);
    return QuizQuestion(
      question: 'Điền vào chỗ trống:\n$blankSentence',
      correctAnswer: word.word,
      options: options,
      type: QuestionType.fillBlank,
      word: word.word,
      phonetic: word.phonetic,
      meaning: word.meaning,
      example: word.example,
    );
  }

  static List<String> _getWrongOptions(
    VocabWord correct,
    List<VocabWord> pool,
    String Function(VocabWord) getter,
  ) {
    final others = pool.where((w) => getter(w) != getter(correct)).toList()
      ..shuffle(_random);
    return others.take(3).map(getter).toList();
  }
}
