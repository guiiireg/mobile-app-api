import 'dart:collection';
import 'package:translator/translator.dart';

class TranslationService {
  static final translator = GoogleTranslator();
  static final Map<String, String> _cache = {};
  static final Queue<String> _keyQueue = Queue<String>();
  static const int _maxCacheSize = 500;

  static String _getCacheKey(String text, String targetLang) {
    return '${targetLang}|$text';
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
      final result = translation.text;

      if (_cache.length >= _maxCacheSize) {
        final oldest = _keyQueue.removeFirst();
        _cache.remove(oldest);
      }
      _cache[cacheKey] = result;
      _keyQueue.addLast(cacheKey);
      return result;
    } catch (e) {
      return text;
    }
  }

  static void clearCache() {
    _cache.clear();
    _keyQueue.clear();
  }
}
