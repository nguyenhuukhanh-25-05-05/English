import 'package:flutter/material.dart';
import 'package:english/data/quiz_data.dart';
import 'package:english/data/vocabulary_data.dart';
import 'package:english/screens/quiz/quiz_screen.dart';
import 'package:english/services/score_service.dart';

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({super.key});

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final Set<int> _selectedTopics = {};

  static const int _maxTopics = 10;
  static const int _questionsPerTopic = 20;

  void _toggleTopic(int index) {
    setState(() {
      if (_selectedTopics.contains(index)) {
        _selectedTopics.remove(index);
      } else {
        if (_selectedTopics.length >= _maxTopics) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tối đa 10 chủ đề!'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        _selectedTopics.add(index);
      }
    });
  }

  int get _totalQuestions => _selectedTopics.length * _questionsPerTopic;
  int get _totalMinutes => _selectedTopics.length * 10;

  int get _totalPoints => _selectedTopics.length * ScoreService.topicPoints;

  void _startQuiz() {
    if (_selectedTopics.isEmpty) return;
    final questions = QuizGenerator.generateFromTopics(
      _selectedTopics.toList(),
      _totalQuestions,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          title: 'Luyện theo chủ đề',
          questions: questions,
          timeLimitMinutes: _totalMinutes,
          pointsAwarded: _totalPoints,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CHỌN CHỦ ĐỀ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        itemCount: allTopics.length,
        itemBuilder: (context, index) {
          final topic = allTopics[index];
          final isSelected = _selectedTopics.contains(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => _toggleTopic(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? topic.color.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? topic.color : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: topic.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(topic.icon, color: topic.color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        topic.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? topic.color
                              : const Color(0xFF111827).withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? topic.color
                            : const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _selectedTopics.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _startQuiz,
              backgroundColor: const Color(0xFF111827),
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              label: Text(
                'Bắt đầu · $_totalQuestions câu · $_totalMinutes phút',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
