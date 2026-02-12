import 'dart:math';
import 'package:english/data/vocabulary_data.dart';
import 'package:english/data/vocab_models.dart';
import 'package:english/data/toeic_patterns.dart';

enum QuestionType { enToVi, viToEn, fillBlank, listenChoose, multipleChoice }

enum ToeicPart { part1, part2, part3, part4, part5, part6, part7 }

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options;
  final QuestionType type;
  final ToeicPart part;
  // For parts with passages/conversations
  final String? passage;
  final String? transcript;
  final String? imageUrl;
  final String? audioUrl;

  // Existing metadata for backward compatibility (vocabulary)
  final String? word;
  final String? phonetic;
  final String? meaning;
  final String? example;
  final String? explanation;

  const QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.type,
    required this.part,
    this.passage,
    this.transcript,
    this.imageUrl,
    this.audioUrl,
    this.word,
    this.phonetic,
    this.meaning,
    this.example,
    this.explanation,
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
    // ignore: unused_local_variable
    final random = Random(testNumber);
    final allWords = <VocabWord>[];
    for (final topic in allTopics) {
      allWords.addAll(topic.words);
    }

    final questions = <QuizQuestion>[];

    // --- Part 1: Photographs (6 Questions) ---
    // Simulated with text for now
    for (int i = 0; i < 6; i++) {
      questions.add(
        QuizQuestion(
          part: ToeicPart.part1,
          type: QuestionType.multipleChoice,
          question:
              "Look at the picture. Which statement best describes what you see?",
          correctAnswer: "A woman is typing on a computer.",
          options: [
            "A woman is typing on a computer.",
            "A child is playing in the park.",
            "The office is completely empty.",
            "People are eating at a restaurant.",
          ],
          imageUrl: "placeholder_image_part1_$i",
          explanation: "Miêu tả hành động trong ảnh công sở.",
        ),
      );
    }

    // --- Part 2: Question-Response (25 Questions) ---
    for (int i = 0; i < 25; i++) {
      questions.add(
        QuizQuestion(
          part: ToeicPart.part2,
          type: QuestionType.multipleChoice,
          question: "When is the project deadline?",
          correctAnswer: "Next Friday by 5 PM.",
          options: [
            "Next Friday by 5 PM.",
            "In the conferenceroom.",
            "Yes, I like the project.",
            "It was a great movie.",
          ],
          transcript: "When is the project deadline?",
          explanation: "Câu hỏi 'When' yêu cầu mốc thời gian.",
        ),
      );
    }

    // --- Part 3 & 4: Conversations & Talks (69 Questions) ---
    // Using samples from ToeicPatterns
    questions.addAll(ToeicPatterns.getPart3Sample()); // 2 questions
    // Fill remaining with generic business talks
    for (int i = 0; i < 67; i++) {
      questions.add(
        QuizQuestion(
          part: ToeicPart.part4,
          type: QuestionType.multipleChoice,
          transcript:
              "Welcome to the annual tech conference. Our first speaker is Dr. Smith...",
          question: "Who is the intended audience for this talk?",
          correctAnswer: "Conference participants",
          options: [
            "Conference participants",
            "Hotel staff",
            "Construction workers",
            "Medical doctors",
          ],
        ),
      );
    }

    // --- Part 5: Incomplete Sentences (30 Questions) ---
    questions.addAll(ToeicPatterns.getPart5Sample()); // 2 questions
    final readingPool = List<VocabWord>.from(allWords)..shuffle(_random);
    for (int i = 0; i < 28; i++) {
      questions.add(
        _buildQuestion(readingPool[i], allWords, QuestionType.fillBlank),
      );
    }

    // --- Part 6: Text Completion (16 Questions) ---
    for (int i = 0; i < 16; i++) {
      questions.add(
        QuizQuestion(
          part: ToeicPart.part6,
          type: QuestionType.multipleChoice,
          passage:
              "Memo: To all staff. We are _______ to announce the promotion of John Doe.",
          question: "Which word best fits the blank?",
          correctAnswer: "pleased",
          options: ["pleased", "pleasing", "pleasure", "pleasant"],
          explanation: "Sử dụng tính từ 'pleased' để diễn tả cảm xúc vui mừng.",
        ),
      );
    }

    // --- Part 7: Reading Comprehension (54 Questions) ---
    questions.addAll(ToeicPatterns.getPart7Sample()); // 2 questions
    for (int i = 0; i < 52; i++) {
      questions.add(
        QuizQuestion(
          part: ToeicPart.part7,
          type: QuestionType.multipleChoice,
          passage: "Article: Local bank expands to new regions...",
          question: "What is the article about?",
          correctAnswer: "Business expansion",
          options: [
            "Business expansion",
            "A new recipe",
            "Weather forecast",
            "Sports results",
          ],
        ),
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
        final q = _enToViQuestion(word, pool);
        return QuizQuestion(
          part: ToeicPart.part2,
          type: QuestionType.listenChoose,
          question: "Nghe câu sau và chọn nghĩa đúng:",
          correctAnswer: q.correctAnswer,
          options: q.options,
          audioUrl: word.word,
          word: word.word,
          phonetic: word.phonetic,
          meaning: word.meaning,
          example: word.example,
        );
      case QuestionType.multipleChoice:
        return _enToViQuestion(word, pool); // Fallback
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
      part: ToeicPart.part5,
      type: QuestionType.enToVi,
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
      part: ToeicPart.part5,
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
      part: ToeicPart.part5,
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
