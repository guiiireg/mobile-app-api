import 'package:translator/translator.dart';

class TranslationService {
  static final translator = GoogleTranslator();
  static final Map<String, String> _cache = {};

  static String _getCacheKey(String text, String targetLang) {
    return '$text|$targetLang';
  }

  static Future<String> translate(String text, String targetLanguage) async {
    if (text.isEmpty) return text;
    if (targetLanguage == 'en') return text;

    final cacheKey = _getCacheKey(text, targetLanguage);
    
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final translation = await translator.translate(text, from: 'en', to: targetLanguage);
      final result = translation.toString();
      
      _cache[cacheKey] = result;
      return result;
    } catch (e) {
      return text;
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}
