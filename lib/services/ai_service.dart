import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  static const String _apiKey = 'YOUR_XAI_API_KEY_HERE';
  static const String _baseUrl = 'https://api.x.ai/v1/chat/completions';
  static const String _model = 'grok-beta';

  final List<Map<String, String>> _history = [];

  // Quản lý token: Giới hạn lịch sử hội thoại
  static const int _maxHistory = 8; // Giảm bớt số lượng tin nhắn
  static const int _maxCharLimit = 2000; // Giới hạn tổng số ký tự gửi đi
  static const int _maxInputLength =
      500; // Giới hạn tin nhắn người dùng nhập vào

  // Giới hạn token output
  static const int _maxOutputTokens =
      500; // Giảm output để tiết kiệm và tránh lỗi

  static const String _systemPrompt = '''
You are "Master Khánh" - a friendly English teacher for Vietnamese students.
Rules:
1. Always use BILINGUAL format: English first, then Vietnamese in square brackets [].
   Example: "Great job! [Làm tốt lắm!]"
2. Keep responses brief (max 3 sentences).
3. If user input is too long, kindly ask them to keep it short.
''';

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) return 'Thiếu API Key.';

    // Tiền xử lý: Cắt bớt nếu tin nhắn quá dài
    String processedMessage = message;
    if (message.length > _maxInputLength) {
      processedMessage =
          "${message.substring(0, _maxInputLength)}... (cắt bớt)";
    }

    // Thêm tin nhắn người dùng vào lịch sử
    _history.add({'role': 'user', 'content': processedMessage});

    // Tối ưu lịch sử: Giới hạn số câu và tổng ký tự
    _trimHistory();

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': _model,
              'messages': [
                {'role': 'system', 'content': _systemPrompt},
                ..._history,
              ],
              'max_tokens': _maxOutputTokens,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;

        // Thêm câu trả lời của AI vào lịch sử
        _history.add({'role': 'assistant', 'content': content});
        _trimHistory();

        return content;
      } else {
        return _handleErrorCode(response.statusCode);
      }
    } catch (e) {
      return 'Lỗi kết nối hoặc AI đang bận. Vui lòng thử lại.';
    }
  }

  void _trimHistory() {
    // 1. Giới hạn số lượng tin nhắn
    while (_history.length > _maxHistory) {
      _history.removeAt(0);
    }

    // 2. Giới hạn tổng số ký tự (để tránh tràn token)
    int totalChars = _history.fold(
      0,
      (sum, msg) => sum + (msg['content']?.length ?? 0),
    );
    while (totalChars > _maxCharLimit && _history.length > 1) {
      totalChars -= _history.first['content']?.length ?? 0;
      _history.removeAt(0);
    }
  }

  String _handleErrorCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'Lỗi: API Key không hợp lệ.';
      case 429:
        return 'Lỗi: Tài khoản hết hạn hoặc quá tải.';
      case 400:
        return 'Lỗi: Yêu cầu không hợp lệ (Token quá dài).';
      case 500:
      case 503:
        return 'Lỗi: Máy chủ xAI đang bận.';
      default:
        return 'Lỗi hệ thống (Mã: $statusCode).';
    }
  }

  void resetChat() {
    _history.clear();
  }
}
