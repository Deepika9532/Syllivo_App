/// Character/syllable-level comparison of what the learner said against the
/// expected text, so the UI can highlight exactly which part was wrong.
library;

enum MarkStatus { correct, wrong, missing, neutral }

class CharMark {
  final String text;
  final MarkStatus status;
  const CharMark(this.text, this.status);

  @override
  String toString() => '$text:${status.name}';
}

final _letter = RegExp(r'[\p{L}\p{N}]', unicode: true);

/// Comparison key for one character: case-folded, with German spelling
/// variants unified. Korean compares whole syllables (e.g. 합 vs 함).
String _key(String ch, String lang) {
  final c = ch.toLowerCase();
  if (lang == 'de') {
    return switch (c) {
      'ß' => 'ss',
      'ä' => 'ae',
      'ö' => 'oe',
      'ü' => 'ue',
      _ => c,
    };
  }
  return c;
}

/// Returns one mark per character of [expected]. Letters are aligned with
/// [heard] using edit distance; spaces and punctuation are [MarkStatus.neutral].
List<CharMark> diffPronunciation(String expected, String heard, String lang) {
  final chars = expected.split('');
  final expIdx = <int>[];
  for (var i = 0; i < chars.length; i++) {
    if (_letter.hasMatch(chars[i])) expIdx.add(i);
  }
  final a = [for (final i in expIdx) _key(chars[i], lang)];
  final b = [
    for (final ch in heard.split(''))
      if (_letter.hasMatch(ch)) _key(ch, lang)
  ];

  // Edit-distance table.
  final n = a.length, m = b.length;
  final dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
  for (var i = 0; i <= n; i++) {
    dp[i][0] = i;
  }
  for (var j = 0; j <= m; j++) {
    dp[0][j] = j;
  }
  for (var i = 1; i <= n; i++) {
    for (var j = 1; j <= m; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost]
          .reduce((x, y) => x < y ? x : y);
    }
  }

  // Backtrace to label each expected letter.
  final status = List<MarkStatus>.filled(n, MarkStatus.missing);
  var i = n, j = m;
  while (i > 0) {
    if (j > 0 &&
        dp[i][j] == dp[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1)) {
      status[i - 1] =
          a[i - 1] == b[j - 1] ? MarkStatus.correct : MarkStatus.wrong;
      i--;
      j--;
    } else if (dp[i][j] == dp[i - 1][j] + 1) {
      status[i - 1] = MarkStatus.missing;
      i--;
    } else {
      j--; // extra sound in what was heard
    }
  }

  final byIndex = {for (var k = 0; k < n; k++) expIdx[k]: status[k]};
  return [
    for (var k = 0; k < chars.length; k++)
      CharMark(chars[k], byIndex[k] ?? MarkStatus.neutral),
  ];
}
