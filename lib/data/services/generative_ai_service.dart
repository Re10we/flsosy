import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeAIService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GenerativeAIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not defined in the environment.');
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'You are "sosyn", a highly intelligent, minimalist, cyberpunk-styled AI assistant integrated into a premium crypto tracking app called Sosy. '
        'Your primary domain is cryptocurrency, blockchain technology, and financial markets. '
        'You must reject any prompt that is not related to cryptocurrency or the app itself, but do so while staying in character. '
        'Keep your responses relatively concise, insightful, and formatted beautifully without markdown unless necessary (like bolding). '
        'Use terms related to on-chain data, liquidity, volatility, and market trends when appropriate.',
      ),
    );

    _chatSession = _model.startChat();
  }

  Future<String> sendMessage(String text) async {
    final response = await _chatSession.sendMessage(Content.text(text));
    return response.text ?? 'Error generating response';
  }
}
