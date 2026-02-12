import 'package:flutter/material.dart';
import 'package:english/screens/lesson/vocabulary.dart';
import 'package:english/screens/lesson/grammar.dart';
import 'package:english/screens/lesson/listen.dart';
import 'package:english/screens/lesson/reading.dart';
import 'package:english/screens/lesson/chat_screen.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

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
          'BÀI HỌC',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const _LessonHeader(),
              const SizedBox(height: 32),
              _LessonGroup(
                title: 'NỀN TẢNG',
                items: [
                  _LessonTile(
                    title: 'Từ Vựng',
                    subtitle: '1000+ từ thông dụng nhất',
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFF3B82F6),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VocabularyScreen(),
                      ),
                    ),
                  ),
                  _LessonTile(
                    title: 'Ngữ Pháp',
                    subtitle: 'Cấu trúc câu quan trọng',
                    icon: Icons.architecture_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GrammarScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LessonGroup(
                title: 'KỸ NĂNG',
                items: [
                  _LessonTile(
                    title: 'Luyện Nghe',
                    subtitle: 'Kỹ năng nghe hiểu Toeic',
                    icon: Icons.headphones_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListeningScreen(),
                      ),
                    ),
                  ),
                  _LessonTile(
                    title: 'Luyện Đọc',
                    subtitle: 'Chiến thuật đọc nhanh',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF6366F1),
                    isLast: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadingScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LessonGroup(
                title: 'GIAO TIẾP AI',
                items: [
                  _LessonTile(
                    title: 'Trò chuyện với Master Khánh',
                    subtitle: 'Luyện giao tiếp với Master Khánh',
                    icon: Icons.chat_bubble_rounded,
                    color: const Color.fromARGB(255, 255, 138, 249),
                    isLast: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Học tập',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Chương trình được thiết kế riêng\ndành cho mục tiêu của bạn.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LessonGroup extends StatelessWidget {
  const _LessonGroup({required this.title, required this.items});
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF9CA3AF),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF111827).withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 24, color: color),
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
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827).withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}
