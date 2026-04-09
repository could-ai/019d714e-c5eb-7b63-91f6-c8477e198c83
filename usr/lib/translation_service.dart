import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl = 'https://api.mymemory.translated.net/get';

  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    if (text.trim().isEmpty) return '';

    try {
      final uri = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(text)}&langpair=$sourceLang|$targetLang');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['responseStatus'] == 200) {
          return data['responseData']['translatedText'] ?? 'Translation failed';
        } else {
          return 'Error: ${data['responseDetails']}';
        }
      } else {
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
