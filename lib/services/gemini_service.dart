import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService._();
  static final GeminiService instance = GeminiService._();

  // IMPORTANT: Replace with your actual Gemini API Key
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';

  late final GenerativeModel _model;
  ChatSession? _chatSession;

  bool _isInitialized = false;

  void _init() {
    if (_isInitialized) return;
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 500,
        temperature: 0.7,
      ),
      systemInstruction: Content.system('''
You are "Master Khánh" - a friendly and professional English teacher for Vietnamese students.
Rules:
1. Always use BILINGUAL format: English first, then Vietnamese in square brackets [].
   Example: "That's a great question! [Đó là một câu hỏi tuyệt vời!]"
2. Keep responses concise and focused on teaching (max 3-4 sentences).
3. Encourage the user to practice speaking and writing.
4. If the user asks about a specific topic (like shopping, travel), provide relevant vocabulary or phrases.
'''),
    );
    _chatSession = _model.startChat();
    _isInitialized = true;
  }

  Future<String> sendMessage(String message) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE' || _apiKey.isEmpty) {
      return 'Vui lòng cung cấp Gemini API Key trong bộ nhớ dịch vụ. [Please provide Gemini API Key in service storage.]';
    }

    try {
      _init();
      final response = await _chatSession!.sendMessage(Content.text(message));
      final text = response.text;

      if (text == null || text.isEmpty) {
        return 'Xin lỗi, tôi không thể trả lời lúc này. [Sorry, I cannot answer right now.]';
      }

      return text;
    } catch (e) {
      if (e.toString().contains('400')) {
        return 'Lỗi: Yêu cầu không hợp lệ (có thể do nội dung quá dài hoặc không hợp lệ). [Error: Invalid request (possibly due to long content).]';
      }
      return 'AI đang bận hoặc có lỗi kết nối. Vui lòng thử lại sau. [AI is busy or connection error. Please try again later.]';
    }
  }

  void resetChat() {
    _chatSession = _model.startChat();
  }
}
