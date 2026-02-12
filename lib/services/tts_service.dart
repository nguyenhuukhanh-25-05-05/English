import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false;

  DateTime _lastSpeakTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _cooldown = Duration(milliseconds: 300);

  Future<void> _init() async {
    if (_initialized) return;

    // Platform specific configurations
    if (!kIsWeb) {
      if (Platform.isIOS) {
        await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ]);
      }

      if (Platform.isAndroid) {
        try {
          final engines = await _tts.getEngines;
          if (engines.contains('com.google.android.tts')) {
            await _tts.setEngine('com.google.android.tts');
          }
        } catch (e) {
          // Ignored
        }
        await _tts.awaitSpeakCompletion(true);
      }
    }

    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setErrorHandler((_) => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _initialized = true;
  }

  bool get _canSpeak {
    final now = DateTime.now();
    if (now.difference(_lastSpeakTime) < _cooldown) return false;
    return true;
  }

  Future<void> speak(String text) async {
    if (text.isEmpty || !_canSpeak) return;
    _lastSpeakTime = DateTime.now();
    await _init();
    await _tts.stop();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);

    if (!kIsWeb) {
      final isAvailable = await _tts.isLanguageAvailable('en-US');
      if (isAvailable != null && !isAvailable) return;
    }

    await _tts.speak(text);
  }

  Future<void> speakWithSpeed(String text, double speed) async {
    if (text.isEmpty || !_canSpeak) return;
    _lastSpeakTime = DateTime.now();
    await _init();
    await _tts.stop();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(speed);
    await _tts.speak(text);
  }

  Future<void> speakVietnamese(String text, double speed) async {
    if (text.isEmpty || !_canSpeak) return;
    _lastSpeakTime = DateTime.now();
    await _init();
    await _tts.stop();

    if (!kIsWeb) {
      final isAvailable = await _tts.isLanguageAvailable('vi-VN');
      if (isAvailable != null && !isAvailable) return;
    }

    await _tts.setLanguage('vi-VN');
    await _tts.setSpeechRate(speed + 0.05);
    await _tts.speak(text);
  }

  Future<bool> isSpeaking() async => _isSpeaking;

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }
}
