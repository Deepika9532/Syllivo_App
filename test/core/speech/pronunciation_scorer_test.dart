import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/speech/pronunciation_scorer.dart';
import 'package:syllivo/core/utils/text_normalizer.dart';

void main() {
  int score(String e, String h, String lang) =>
      PronunciationScorer.score(expected: e, heard: h, lang: lang).score;

  test('identical text scores 100', () {
    expect(score('Guten Morgen', 'guten morgen', 'de'), 100);
  });

  test('German umlaut and ß variants are equivalent', () {
    expect(score('Tschüss!', 'tschuess', 'de'), 100);
    expect(score('Wie heißt du?', 'wie heisst du', 'de'), 100);
  });

  test('Korean spacing is ignored', () {
    expect(score('안녕히 가세요', '안녕히가세요', 'ko'), 100);
  });

  test('one-jamo Korean error still scores high', () {
    // 합 -> 함 differs only in the final consonant.
    expect(score('감사합니다', '감사함니다', 'ko'), greaterThanOrEqualTo(85));
  });

  test('empty recognition scores 0', () {
    expect(score('Hallo', '', 'de'), 0);
  });

  test('unrelated words score low', () {
    expect(score('Danke', 'Kartoffel', 'de'), lessThan(50));
  });

  test('Hangul decomposes into conjoining jamo', () {
    expect(decomposeHangul('한').runes.length, 3);
    expect(decomposeHangul('가').runes.length, 2);
  });
}
