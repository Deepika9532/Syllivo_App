import 'dart:math';

import '../utils/text_normalizer.dart';

class PronunciationResult {
  final int score; // 0..100
  final String feedback;
  const PronunciationResult(this.score, this.feedback);
}

class PronunciationScorer {
  static PronunciationResult score({
    required String expected,
    required String heard,
    required String lang,
  }) {
    final a = normalizeForCompare(expected, lang).runes.toList();
    final b = normalizeForCompare(heard, lang).runes.toList();
    if (b.isEmpty) {
      return const PronunciationResult(0, 'Nothing heard — try again.');
    }

    final dist = levenshtein(a, b);
    final longest = max(a.length, b.length);
    final s =
        longest == 0 ? 100 : ((1 - dist / longest) * 100).round().clamp(0, 100);
    return PronunciationResult(s, feedbackFor(s));
  }

  static String feedbackFor(int s) {
    if (s >= 90) return 'Excellent!';
    if (s >= 70) return 'Good — almost there.';
    if (s >= 50) return 'Close. Listen again and repeat.';
    return 'Try again, a little slower.';
  }

  static int levenshtein(List<int> a, List<int> b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    var prev = List<int>.generate(b.length + 1, (i) => i);
    var cur = List<int>.filled(b.length + 1, 0);
    for (var i = 1; i <= a.length; i++) {
      cur[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        cur[j] = min(min(cur[j - 1] + 1, prev[j] + 1), prev[j - 1] + cost);
      }
      final tmp = prev;
      prev = cur;
      cur = tmp;
    }
    return prev[b.length];
  }
}
