import 'package:flutter/material.dart';
import 'package:english/data/quiz_data.dart';
import 'package:english/screens/quiz/quiz_screen.dart';
import 'package:english/screens/quiz/topic_select_screen.dart';
import 'package:english/services/score_service.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'BÀI THI',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const _ExamHeader(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _ExamCategory(
                    title: 'Đề thi mô phỏng 01',
                    description: '200 câu hỏi - Full 7 Parts',
                    icon: Icons.assignment_rounded,
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      final questions = QuizGenerator.generateSimulatedTest(1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            title: 'TOEIC Mock Test 01',
                            questions: questions,
                            timeLimitMinutes: 120,
                            pointsAwarded: ScoreService.fullTestPoints,
                            isFullTest: true,
                          ),
                        ),
                      );
                    },
                  ),
                  _ExamCategory(
                    title: 'Đề thi mô phỏng 02',
                    description: '200 câu hỏi - Full 7 Parts',
                    icon: Icons.assignment_rounded,
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      final questions = QuizGenerator.generateSimulatedTest(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            title: 'TOEIC Mock Test 02',
                            questions: questions,
                            timeLimitMinutes: 120,
                            pointsAwarded: ScoreService.fullTestPoints,
                            isFullTest: true,
                          ),
                        ),
                      );
                    },
                  ),
                  _ExamCategory(
                    title: 'Đề thi ngẫu nhiên',
                    description: '200 câu - Ngẫu nhiên từ kho',
                    icon: Icons.shuffle_rounded,
                    color: const Color(0xFF6366F1),
                    onTap: () {
                      final questions = QuizGenerator.generateSimulatedTest(
                        DateTime.now().millisecondsSinceEpoch,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            title: 'Đề thi ngẫu nhiên',
                            questions: questions,
                            timeLimitMinutes: 120,
                            pointsAwarded: ScoreService.fullTestPoints,
                            isFullTest: true,
                          ),
                        ),
                      );
                    },
                  ),
                  _ExamCategory(
                    title: 'Mini Test',
                    description: '50 câu hỏi - 30 phút',
                    icon: Icons.timer_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () {
                      // Generate a shorter version by taking 50 from simulated
                      final questions = QuizGenerator.generateSimulatedTest(
                        DateTime.now().millisecondsSinceEpoch,
                      ).take(50).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            title: 'Mini Test',
                            questions: questions,
                            timeLimitMinutes: 30,
                            pointsAwarded: ScoreService.miniTestPoints,
                          ),
                        ),
                      );
                    },
                  ),
                  _ExamCategory(
                    title: 'Luyện từng chủ đề',
                    description: '20 Chủ đề',
                    icon: Icons.grid_view_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TopicSelectScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ExamHeader extends StatelessWidget {
  const _ExamHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bài kiểm tra',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Luyện tập kỹ năng làm bài\nđể bứt phá điểm số tối ưu.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCategory extends StatelessWidget {
  const _ExamCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF111827).withValues(alpha: 0.03),
              offset: const Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}
