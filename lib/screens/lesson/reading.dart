import 'package:flutter/material.dart';
import 'package:english/data/reading_data.dart';
import 'package:english/services/tts_service.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
          'LUYỆN ĐỌC SONG NGỮ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        itemCount: allReadingPassages.length,
        itemBuilder: (context, index) {
          final p = allReadingPassages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _ReadingDetailScreen(passage: p),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(p.icon, color: p.color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.category,
                              style: TextStyle(
                                fontSize: 13,
                                color: p.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReadingDetailScreen extends StatefulWidget {
  const _ReadingDetailScreen({required this.passage});
  final ReadingPassage passage;

  @override
  State<_ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<_ReadingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showVietnamese = true;
  int _playingIndex = -1;
  Map<int, int?> _selectedAnswers = {};
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  void _speakParagraph(int index) async {
    setState(() {
      _playingIndex = index;
    });
    await TtsService.instance.speak(widget.passage.paragraphs[index].english);
    if (mounted) {
      setState(() {
        _playingIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.passage;
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
        title: Text(
          p.title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: p.color,
          unselectedLabelColor: const Color(0xFF9CA3AF),
          indicatorColor: p.color,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'NỘI DUNG'),
            Tab(text: 'TỪ VỰNG'),
            Tab(text: 'TRẮC NGHIỆM'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildContentTab(p), _buildVocabTab(p), _buildQuizTab(p)],
      ),
    );
  }

  Widget _buildContentTab(ReadingPassage p) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () =>
                    setState(() => _showVietnamese = !_showVietnamese),
                icon: Icon(
                  Icons.translate_rounded,
                  size: 18,
                  color: _showVietnamese ? p.color : const Color(0xFF9CA3AF),
                ),
                label: Text(
                  _showVietnamese ? 'Ẩn dịch' : 'Hiện dịch',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _showVietnamese ? p.color : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            itemCount: p.paragraphs.length,
            itemBuilder: (context, index) {
              final para = p.paragraphs[index];
              final isPlaying = _playingIndex == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () => _speakParagraph(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? p.color.withValues(alpha: 0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isPlaying
                            ? p.color.withValues(alpha: 0.3)
                            : const Color(0xFFE5E7EB),
                        width: isPlaying ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          para.english,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isPlaying
                                ? p.color
                                : const Color(0xFF111827),
                            height: 1.8,
                          ),
                        ),
                        if (_showVietnamese) ...[
                          const SizedBox(height: 16),
                          Text(
                            para.vietnamese,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontStyle: FontStyle.italic,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVocabTab(ReadingPassage p) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: p.vocabulary.length,
      itemBuilder: (context, index) {
        final vocab = p.vocabulary[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                  Text(
                    vocab.word,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: p.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${vocab.type})',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.volume_up_rounded,
                      color: p.color,
                      size: 20,
                    ),
                    onPressed: () => TtsService.instance.speak(vocab.word),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                vocab.meaning,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vocab.example,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizTab(ReadingPassage p) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      children: [
        for (int i = 0; i < p.questions.length; i++) ...[
          _buildQuestionCard(p.questions[i], i, p.color),
          const SizedBox(height: 24),
        ],
        if (!_showResults)
          ElevatedButton(
            onPressed: () => setState(() => _showResults = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: p.color,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'KIỂM TRA ĐÁP ÁN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        else
          OutlinedButton(
            onPressed: () => setState(() {
              _showResults = false;
              _selectedAnswers.clear();
            }),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: p.color),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'LÀM LẠI',
              style: TextStyle(color: p.color, fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(ReadingQuestion q, int index, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu ${index + 1}: ${q.question}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < q.options.length; i++) ...[
          _buildOptionTile(q, index, i, color),
          const SizedBox(height: 8),
        ],
        if (_showResults) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Giải thích: ${q.explanation}',
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionTile(
    ReadingQuestion q,
    int qIndex,
    int oIndex,
    Color color,
  ) {
    final isSelected = _selectedAnswers[qIndex] == oIndex;
    final isCorrect = q.correctAnswerIndex == oIndex;

    Color tileColor = Colors.white;
    Color borderColor = const Color(0xFFE5E7EB);
    Color textColor = const Color(0xFF111827);

    if (_showResults) {
      if (isCorrect) {
        tileColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFF10B981);
        textColor = const Color(0xFF065F46);
      } else if (isSelected) {
        tileColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFF991B1B);
      }
    } else if (isSelected) {
      tileColor = color.withValues(alpha: 0.1);
      borderColor = color;
      textColor = color;
    }

    return InkWell(
      onTap: _showResults
          ? null
          : () => setState(() => _selectedAnswers[qIndex] = oIndex),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected || (_showResults && isCorrect) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              String.fromCharCode(65 + oIndex) + '.',
              style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                q.options[oIndex],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
            if (_showResults && isCorrect)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 20,
              ),
            if (_showResults && isSelected && !isCorrect)
              const Icon(
                Icons.cancel_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
