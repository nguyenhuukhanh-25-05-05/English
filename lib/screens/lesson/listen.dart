import 'package:flutter/material.dart';
import 'package:english/data/dialogue_data.dart';
import 'package:english/services/tts_service.dart';

class ListeningScreen extends StatelessWidget {
  const ListeningScreen({super.key});

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
          'LUYỆN NGHE SONG NGỮ',
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
        itemCount: allDialogues.length,
        itemBuilder: (context, index) {
          final d = allDialogues[index];
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
                    builder: (_) => _DialoguePlayerScreen(dialogue: d),
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
                          color: d.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(d.icon, color: d.color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              d.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${d.lines.length} câu',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 28,
                        color: Color(0xFF3B82F6),
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

class _DialoguePlayerScreen extends StatefulWidget {
  const _DialoguePlayerScreen({required this.dialogue});
  final Dialogue dialogue;

  @override
  State<_DialoguePlayerScreen> createState() => _DialoguePlayerScreenState();
}

class _DialoguePlayerScreenState extends State<_DialoguePlayerScreen> {
  int _currentLine = -1;
  bool _isPlaying = false;
  bool _showVietnamese = true;
  double _speed = 0.45;

  @override
  void dispose() {
    _isPlaying = false;
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _playAll() async {
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      await TtsService.instance.stop();
      return;
    }

    setState(() {
      _isPlaying = true;
    });

    final startFrom = _currentLine < 0 ? 0 : _currentLine;

    for (int i = startFrom; i < widget.dialogue.lines.length; i++) {
      if (!_isPlaying || !mounted) break;

      setState(() {
        _currentLine = i;
      });
      final line = widget.dialogue.lines[i];

      // Speak English
      await TtsService.instance.speakWithSpeed(line.english, _speed);
      await _waitForTtsComplete();
      if (!_isPlaying || !mounted) break;

      // Short pause
      await Future.delayed(const Duration(milliseconds: 400));
      if (!_isPlaying || !mounted) break;

      // Speak Vietnamese
      await TtsService.instance.speakVietnamese(line.vietnamese, _speed);
      await _waitForTtsComplete();
      if (!_isPlaying || !mounted) break;

      // Pause between lines
      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _waitForTtsComplete() async {
    // Wait for TTS to finish speaking
    await Future.delayed(const Duration(milliseconds: 500));
    while (_isPlaying && mounted) {
      final isSpeaking = await TtsService.instance.isSpeaking();
      if (!isSpeaking) break;
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void _speakLine(DialogueLine line) async {
    await TtsService.instance.speakWithSpeed(line.english, _speed);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dialogue;
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
        title: Text(
          d.title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showVietnamese
                  ? Icons.translate_rounded
                  : Icons.translate_rounded,
              color: _showVietnamese ? d.color : const Color(0xFF9CA3AF),
            ),
            onPressed: () => setState(() {
              _showVietnamese = !_showVietnamese;
            }),
            tooltip: _showVietnamese ? 'Ẩn tiếng Việt' : 'Hiện tiếng Việt',
          ),
        ],
      ),
      body: Column(
        children: [
          // Speed control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tốc độ:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                _SpeedChip(
                  label: 'Chậm',
                  value: 0.3,
                  current: _speed,
                  onTap: () => setState(() {
                    _speed = 0.3;
                  }),
                ),
                const SizedBox(width: 8),
                _SpeedChip(
                  label: 'Vừa',
                  value: 0.45,
                  current: _speed,
                  onTap: () => setState(() {
                    _speed = 0.45;
                  }),
                ),
                const SizedBox(width: 8),
                _SpeedChip(
                  label: 'Nhanh',
                  value: 0.6,
                  current: _speed,
                  onTap: () => setState(() {
                    _speed = 0.6;
                  }),
                ),
              ],
            ),
          ),
          // Dialogue lines
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
              itemCount: d.lines.length,
              itemBuilder: (context, index) {
                final line = d.lines[index];
                final isActive = index == _currentLine;
                final isA = line.speaker == 'A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isA
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isA) _Avatar(speaker: 'A', color: d.color),
                      if (isA) const SizedBox(width: 12),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => _speakLine(line),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? d.color.withValues(alpha: 0.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isA ? 4 : 20),
                                bottomRight: Radius.circular(isA ? 20 : 4),
                              ),
                              border: Border.all(
                                color: isActive
                                    ? d.color.withValues(alpha: 0.3)
                                    : const Color(0xFFE5E7EB),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        line.english,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: isActive
                                              ? d.color
                                              : const Color(0xFF111827),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.volume_up_rounded,
                                      size: 16,
                                      color: d.color.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                                if (_showVietnamese) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    line.vietnamese,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF9CA3AF),
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isA) const SizedBox(width: 12),
                      if (!isA)
                        _Avatar(speaker: 'B', color: const Color(0xFF10B981)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Play/Pause FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _playAll,
        backgroundColor: _isPlaying ? const Color(0xFFEF4444) : d.color,
        icon: Icon(
          _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
        ),
        label: Text(
          _isPlaying
              ? 'Dừng'
              : (_currentLine >= 0 ? 'Tiếp tục' : 'Phát tất cả'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.speaker, required this.color});
  final String speaker;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          speaker,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });
  final String label;
  final double value;
  final double current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = (value - current).abs() < 0.01;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
