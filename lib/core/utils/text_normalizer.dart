/// Normalizes text so pronunciation comparisons ignore case, punctuation,
/// spacing and spelling variants, and compare Korean at the jamo level.
String normalizeForCompare(String input, String lang) {
  var s = input.toLowerCase().trim();
  s = s.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '');

  if (lang == 'de') {
    s = s
        .replaceAll('ß', 'ss')
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue');
    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  if (lang == 'ko') {
    // Korean spacing is often inconsistent in STT output, so drop spaces.
    s = s.replaceAll(RegExp(r'\s+'), '');
    return decomposeHangul(s);
  }

  return s.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Splits precomposed Hangul syllables (가-힣) into conjoining jamo, so
/// "합" vs "함" differ by one unit instead of a whole syllable.
String decomposeHangul(String s) {
  const base = 0xAC00, last = 0xD7A3;
  final out = StringBuffer();
  for (final r in s.runes) {
    if (r < base || r > last) {
      out.writeCharCode(r);
      continue;
    }
    final idx = r - base;
    final l = idx ~/ 588;
    final v = (idx % 588) ~/ 28;
    final t = idx % 28;
    out.writeCharCode(0x1100 + l);
    out.writeCharCode(0x1161 + v);
    if (t > 0) out.writeCharCode(0x11A7 + t);
  }
  return out.toString();
}
