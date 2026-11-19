import 'package:flutter_tts/flutter_tts.dart';

import '../lang.dart';

/// Text-to-speech using the device's offline voices.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  String? _currentLocale;

  Future<void> speak(String text, String lang, {double rate = 0.45}) async {
    final locale = languages[lang]!.ttsLocale;
    if (_currentLocale != locale) {
      await _tts.setLanguage(locale);
      _currentLocale = locale;
    }
    await _tts.setSpeechRate(rate);
    await _tts.stop();
    await _tts.speak(text);
  }

  /// False when the voice for [lang] isn't installed on the device.
  Future<bool> isAvailable(String lang) async {
    final res = await _tts.isLanguageAvailable(languages[lang]!.ttsLocale);
    return res == true || res == 1;
  }

  Future<void> stop() => _tts.stop();
}
