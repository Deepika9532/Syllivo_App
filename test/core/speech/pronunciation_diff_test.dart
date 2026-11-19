import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/speech/pronunciation_diff.dart';

void main() {
  List<MarkStatus> statuses(String e, String h, String lang) =>
      diffPronunciation(e, h, lang).map((m) => m.status).toList();

  const ok = MarkStatus.correct, bad = MarkStatus.wrong;
  const miss = MarkStatus.missing, neutral = MarkStatus.neutral;

  test('perfect match marks everything correct', () {
    expect(statuses('Danke', 'danke', 'de'), List.filled(5, ok));
  });

  test('Korean flags the one wrong syllable', () {
    // 감사합니다 heard as 감사함니다: only 합 is wrong.
    expect(statuses('감사합니다', '감사함니다', 'ko'), [ok, ok, bad, ok, ok]);
  });

  test('missing syllable is reported as missing', () {
    expect(statuses('안녕하세요', '안녕세요', 'ko'), [ok, ok, miss, ok, ok]);
  });

  test('spaces and punctuation are neutral', () {
    final s = statuses('Hallo!', 'hallo', 'de');
    expect(s.last, neutral);
    expect(statuses('안녕히 가세요', '안녕히가세요', 'ko')[3], neutral);
  });

  test('German umlauts match', () {
    // Same umlaut spelling on both sides matches letter for letter.
    expect(statuses('Tschüss', 'Tschüss', 'de'), List.filled(7, ok));
  });

  test('nothing heard marks all letters missing', () {
    expect(statuses('Ja', '', 'de'), [miss, miss]);
  });

  test('marks preserve the original text', () {
    final marks = diffPronunciation('Guten Morgen', 'guten morgen', 'de');
    expect(marks.map((m) => m.text).join(), 'Guten Morgen');
  });
}
