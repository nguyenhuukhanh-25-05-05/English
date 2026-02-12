import 'package:flutter/material.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

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
          'NGỮ PHÁP TOEIC',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              _GrammarSection(
                title: 'Các thì trong tiếng Anh',
                items: [
                  _GrammarTopic(
                    topic: 'Hiện tại đơn (Present Simple)',
                    description:
                        'Diễn tả một chân lý, một sự thật hiển nhiên hoặc hành động lặp đi lặp lại.',
                    example: 'I usually go to school at 7 AM.',
                    color: Color(0xFF3B82F6),
                  ),
                  _GrammarTopic(
                    topic: 'Hiện tại tiếp diễn',
                    description:
                        'Diễn tả hành động đang xảy ra tại thời điểm nói.',
                    example: 'She is learning English now.',
                    color: Color(0xFF10B981),
                  ),
                ],
              ),
              SizedBox(height: 32),
              _GrammarSection(
                title: 'Từ loại & Cấu trúc',
                items: [
                  _GrammarTopic(
                    topic: 'Danh từ (Nouns)',
                    description:
                        'Từ dùng để chỉ người, vật, việc, địa điểm, khái niệm.',
                    example: 'The table is made of wood.',
                    color: Color(0xFFF59E0B),
                  ),
                  _GrammarTopic(
                    topic: 'Tính từ (Adjectives)',
                    description: 'Từ dùng để miêu tả tính chất của danh từ.',
                    example: 'He is a smart student.',
                    color: Color(0xFF6366F1),
                    isLast: true,
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrammarSection extends StatelessWidget {
  const _GrammarSection({required this.title, required this.items});
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
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

class _GrammarTopic extends StatelessWidget {
  const _GrammarTopic({
    required this.topic,
    required this.description,
    required this.example,
    required this.color,
    this.isLast = false,
  });

  final String topic;
  final String description;
  final String example;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    topic,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      example,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
