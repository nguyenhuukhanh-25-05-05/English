import 'dart:async';
import 'package:flutter/material.dart';
import 'package:english/data/quiz_data.dart';
import 'package:english/services/tts_service.dart';
import 'package:english/services/score_service.dart';
import 'package:english/services/database_service.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  final int timeLimitMinutes;
  final int pointsAwarded;
  final bool isFullTest;

  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.timeLimitMinutes,
    required this.pointsAwarded,
    this.isFullTest = false,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int? _selectedOption;
  bool _answered = false;
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.timeLimitMinutes * 60;
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    final activeSession = await DatabaseService.instance.getActiveExamSession(
      widget.title,
    );
    if (activeSession != null && mounted) {
      _showResumeDialog(activeSession);
    } else {
      _startTimer();
    }
  }

  void _showResumeDialog(Map<String, dynamic> session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tiếp tục bài thi?'),
        content: Text(
          'Bạn có một bài thi "${widget.title}" đang làm dở. Bạn có muốn tiếp tục không?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startTimer();
            },
            child: const Text('Làm mới'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resumeSession(session);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tiếp tục',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _resumeSession(Map<String, dynamic> session) {
    setState(() {
      _currentIndex = session['current_index'] as int;
      _correctCount = session['correct_count'] as int;
      _secondsLeft = session['seconds_left'] as int;
      // Note: In real app we'd load answers_json but here progress is enough
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft % 10 == 0) _saveProgress(); // Auto-save every 10 seconds
      if (_secondsLeft <= 0) {
        timer.cancel();
        _showResult();
      }
    });
  }

  Future<void> _saveProgress() async {
    await DatabaseService.instance.saveExamSession({
      'title': widget.title,
      'current_index': _currentIndex,
      'correct_count': _correctCount,
      'seconds_left': _secondsLeft,
      'answers_json': '', // Reserved for future
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    TtsService.instance.stop();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_answered) return;
    final q = widget.questions[_currentIndex];
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (q.options[index] == q.correctAnswer) {
        _correctCount++;
      }
    });
    _saveProgress();
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
      _saveProgress();
    } else {
      _showResult();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption =
            null; // We don't save specific answers per session yet
        _answered = false;
      });
    }
  }

  void _showResult() async {
    _timer?.cancel();
    await DatabaseService.instance.completeExamSession(widget.title);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ResultScreen(
          correct: _correctCount,
          total: widget.questions.length,
          title: widget.title,
          pointsAwarded: widget.pointsAwarded,
          isFullTest: widget.isFullTest,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Color(0xFF111827),
            size: 22,
          ),
          onPressed: () => _showExitDialog(),
        ),
        title: Text(
          'Câu ${_currentIndex + 1}/${widget.questions.length}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _secondsLeft < 60
                  ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _secondsLeft < 60
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_secondsLeft),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _secondsLeft < 60
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(q).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getTypeLabel(q),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getTypeColor(q),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Passage or Transcript for Part 3, 4, 6, 7
                  if (q.passage != null || q.transcript != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        q.passage ?? q.transcript!,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Question text
                  Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.4,
                    ),
                  ),
                  // TTS button for listening (Part 1, 2, 3, 4)
                  if (q.audioUrl != null ||
                      q.transcript != null ||
                      q.word != null) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        final text = q.transcript ?? q.word ?? q.question;
                        TtsService.instance.speak(text);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volume_up_rounded,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Nghe âm thanh',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Options
                  ...List.generate(q.options.length, (i) {
                    final isSelected = _selectedOption == i;
                    final isCorrect = q.options[i] == q.correctAnswer;
                    Color bgColor = Colors.white;
                    Color borderColor = const Color(0xFFE5E7EB);
                    Color textColor = const Color(0xFF111827);
                    IconData? trailingIcon;

                    if (_answered) {
                      if (isCorrect) {
                        bgColor = const Color(
                          0xFF10B981,
                        ).withValues(alpha: 0.08);
                        borderColor = const Color(0xFF10B981);
                        textColor = const Color(0xFF10B981);
                        trailingIcon = Icons.check_circle_rounded;
                      } else if (isSelected && !isCorrect) {
                        bgColor = const Color(
                          0xFFEF4444,
                        ).withValues(alpha: 0.08);
                        borderColor = const Color(0xFFEF4444);
                        textColor = const Color(0xFFEF4444);
                        trailingIcon = Icons.cancel_rounded;
                      }
                    } else if (isSelected) {
                      borderColor = const Color(0xFF3B82F6);
                      bgColor = const Color(0xFF3B82F6).withValues(alpha: 0.05);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _selectOption(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: borderColor,
                              width: isSelected || (_answered && isCorrect)
                                  ? 2
                                  : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _answered && isCorrect
                                      ? const Color(0xFF10B981)
                                      : _answered && isSelected && !isCorrect
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFF3F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + i), // A, B, C, D
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          _answered &&
                                              (isCorrect ||
                                                  (isSelected && !isCorrect))
                                          ? Colors.white
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  q.options[i],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null)
                                Icon(
                                  trailingIcon,
                                  color: isCorrect
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  // Explanation panel after answering
                  if (_answered) ...[
                    const SizedBox(height: 8),
                    _buildExplanation(q),
                  ],
                ],
              ),
            ),
          ),
          // Bottom button
          if (_answered)
            Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0) ...[
                    SizedBox(
                      height: 52,
                      width: 52,
                      child: ElevatedButton(
                        onPressed: _previousQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          foregroundColor: const Color(0xFF111827),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111827),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentIndex < widget.questions.length - 1
                              ? 'Câu tiếp theo'
                              : 'Xem kết quả',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExplanation(QuizQuestion q) {
    final isCorrect =
        _selectedOption != null &&
        q.options[_selectedOption!] == q.correctAnswer;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : const Color(0xFFEF4444).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Chính xác! 🎉' : 'Sai rồi! 😅',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isCorrect
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Word + Phonetic + TTS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.word ?? "Câu hỏi thông tin",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            q.phonetic ?? "Part ${q.part.index + 1}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (q.word != null) TtsService.instance.speak(q.word!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: Color(0xFF3B82F6),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔹 ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Lời giải: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF374151),
                              ),
                            ),
                            if (q.explanation != null || q.meaning != null)
                              TextSpan(
                                text: q.explanation ?? q.meaning!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (q.example != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📝 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Ví dụ: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              TextSpan(
                                text: q.example!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                if (!isCorrect) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅ ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Đáp án đúng: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              TextSpan(
                                text: q.correctAnswer,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Thoát bài kiểm tra?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Tiến trình sẽ không được lưu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ở lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              'Thoát',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(QuizQuestion q) {
    if (q.part != ToeicPart.part5) {
      return const Color(0xFF6366F1); // Default to Listening/Reading
    }

    switch (q.type) {
      case QuestionType.enToVi:
        return const Color(0xFF3B82F6);
      case QuestionType.viToEn:
        return const Color(0xFF10B981);
      case QuestionType.fillBlank:
        return const Color(0xFFF59E0B);
      case QuestionType.listenChoose:
        return const Color(0xFF6366F1);
      case QuestionType.multipleChoice:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getTypeLabel(QuizQuestion q) {
    if (q.part != ToeicPart.part5) return 'TOEIC PART ${q.part.index + 1}';

    switch (q.type) {
      case QuestionType.enToVi:
        return 'DỊCH ANH → VIỆT';
      case QuestionType.viToEn:
        return 'DỊCH VIỆT → ANH';
      case QuestionType.fillBlank:
        return 'ĐIỀN TỪ';
      case QuestionType.listenChoose:
        return 'NGHE CHỌN';
      case QuestionType.multipleChoice:
        return 'TRẮC NGHIỆM';
    }
  }
}

class _ResultScreen extends StatefulWidget {
  const _ResultScreen({
    required this.correct,
    required this.total,
    required this.title,
    required this.pointsAwarded,
    required this.isFullTest,
  });

  final int correct;
  final int total;
  final String title;
  final int pointsAwarded;
  final bool isFullTest;

  @override
  State<_ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<_ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Award points on completion
    final percentage = (widget.correct / widget.total * 100).round();
    // Award full points if passed (>= 60%), otherwise award proportional points (min 10)
    int finalPoints = widget.pointsAwarded;
    if (percentage < 60) {
      finalPoints = (widget.pointsAwarded * (percentage / 100)).round().clamp(
        10,
        widget.pointsAwarded,
      );
    }

    // Add points to service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScoreService.instance.addPoints(
        finalPoints,
        scorePercent: percentage,
        isFullTest: widget.isFullTest,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.correct / widget.total * 100).round();
    final isPassed = percentage >= 60;
    final finalPoints = percentage < 60
        ? (widget.pointsAwarded * (percentage / 100)).round().clamp(
            10,
            widget.pointsAwarded,
          )
        : widget.pointsAwarded;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Point tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+$finalPoints XP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Score circle
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPassed
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : const Color(0xFFEF4444).withValues(alpha: 0.1),
                    border: Border.all(
                      color: isPassed
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: isPassed
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                      Text(
                        '${widget.correct}/${widget.total}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Icon(
                  isPassed
                      ? Icons.emoji_events_rounded
                      : Icons.sentiment_dissatisfied_rounded,
                  size: 48,
                  color: isPassed
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 16),
                Text(
                  isPassed ? 'Xuất sắc! 🎉' : 'Cần cố gắng hơn! 💪',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPassed
                      ? 'Bạn đã hoàn thành tốt bài kiểm tra "${widget.title}".'
                      : 'Hãy ôn tập thêm và thử lại nhé!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatBox(
                      label: 'Đúng',
                      value: '${widget.correct}',
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 16),
                    _StatBox(
                      label: 'Sai',
                      value: '${widget.total - widget.correct}',
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
