import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Thrown when speech recognition cannot run; [message] is shown to users.
class SpeechUnavailableException implements Exception {
  final String message;
  const SpeechUnavailableException(this.message);
  @override
  String toString() => message;
}

const speechUnavailableHelp =
    'Speech recognition isn’t available on this device right now. Check that '
    'Syllivo has microphone permission and that a speech-recognition service '
    'with the German or Korean language pack is installed (Android: Settings → '
    'Google → Voice → Offline speech recognition). You can skip speaking '
    'questions; they won’t count against your score.';

/// Speech recognition wrapper. On-device recognition is used when the OS
/// has the language pack installed; otherwise it falls back to the OS
/// recognizer, which may need a connection.
class SttService {
  final SpeechToText _stt = SpeechToText();
  final ValueNotifier<bool> listening = ValueNotifier(false);
  bool _ready = false;
  String? lastError;

  Future<bool> init() async {
    if (_ready) return true;
    try {
      _ready = await _stt.initialize(
        onStatus: (status) => listening.value = status == 'listening',
        onError: (e) {
          lastError = e.errorMsg;
          listening.value = false;
        },
      );
    } catch (e) {
      lastError = e.toString();
      _ready = false;
    }
    return _ready;
  }

  Future<bool> isAvailable() => init();

  /// True when the recognizer reports a locale for [locale] (e.g. de_DE).
  Future<bool> supportsLocale(String locale) async {
    if (!await init()) return false;
    final locales = await _stt.locales();
    final want = locale.toLowerCase().replaceAll('-', '_');
    return locales
        .any((l) => l.localeId.toLowerCase().replaceAll('-', '_') == want);
  }

  Future<void> listen({
    required String locale,
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!await init()) {
      throw const SpeechUnavailableException(speechUnavailableHelp);
    }
    await _stt.listen(
      onResult: (r) => onResult(r.recognizedWords, r.finalResult),
      listenOptions: SpeechListenOptions(
        localeId: locale,
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      ),
    );
  }

  Future<void> stop() async {
    await _stt.stop();
    listening.value = false;
  }
}
