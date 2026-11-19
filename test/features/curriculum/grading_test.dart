import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/grading.dart';
import 'package:syllivo/features/curriculum/models.dart';

import '../../curriculum_utils.dart';

Question q(Map<String, dynamic> j) =>
    Question.fromJson({'id': 'q', 'prompt': 'p', ...j});

void main() {
  group('answer checking', () {
    test('text answers ignore case, punctuation and spelling variants', () {
      expect(textMatches('ich bin müde', ['Ich bin müde.'], 'de'), isTrue);
      expect(textMatches('gross', ['groß'], 'de'), isTrue);
      expect(textMatches('안녕히가세요', ['안녕히 가세요'], 'ko'), isTrue);
      expect(textMatches('', ['x'], 'de'), isFalse);
      expect(textMatches('Ich bist müde', ['Ich bin müde.'], 'de'), isFalse);
    });

    test('choice, order and match grading', () {
      final mc = q({
        'type': 'mcq',
        'options': ['a', 'b'],
        'answer': 1
      });
      expect(gradeChoice(mc, 1).correct, isTrue);
      expect(gradeChoice(mc, 0).expected, 'b');

      final ord = q({
        'type': 'order',
        'words': ['Wie', 'heißt', 'du?']
      });
      expect(gradeOrder(ord, ['Wie', 'heißt', 'du?'], 'de').correct, isTrue);
      expect(gradeOrder(ord, ['heißt', 'Wie', 'du?'], 'de').correct, isFalse);

      final m = q({
        'type': 'match',
        'pairs': [
          ['a', '1'],
          ['b', '2']
        ]
      });
      expect(gradeMatch(m, {0: 0, 1: 1}).correct, isTrue);
      expect(gradeMatch(m, {0: 1, 1: 0}).correct, isFalse);
      expect(gradeMatch(m, {0: 0}).correct, isFalse);
    });

    test('writing check needs length and target words', () {
      final w = q({
        'type': 'write',
        'minWords': 5,
        'keywords': ['ich', 'heiße|bin'],
        'sample': 's'
      });
      expect(
          checkWriting(w, 'Ich heiße Ravi und komme aus Indien.', 'de').passed,
          isTrue);
      final short = checkWriting(w, 'Ich heiße Ravi.', 'de');
      expect(short.passed, isFalse);
      expect(short.wordCount, 3);
      expect(
          checkWriting(w, 'Mein Name ist Ravi aus Indien.', 'de')
              .missingKeywords,
          ['ich', 'heiße']);
    });

    test('speech grading uses the pronunciation scorer threshold', () {
      final s = q({'type': 'speak', 'audio': 'Guten Morgen'});
      expect(gradeSpeech(s, 'guten morgen', 'de').correct, isTrue);
      expect(gradeSpeech(s, 'guten morgen', 'de').score, 100);
      expect(gradeSpeech(s, 'kartoffel', 'de').correct, isFalse);
    });
  });

  group('examination scoring', () {
    final a = q({
      'type': 'mcq',
      'options': ['x', 'y'],
      'answer': 0,
      'skill': 'grammar'
    });
    final b = q({
      'type': 'mcq',
      'options': ['x', 'y'],
      'answer': 0,
      'skill': 'reading'
    });

    test('percent, pass mark and per-skill breakdown', () {
      final s = summarize([
        (a, const AnswerResult(correct: true, expected: 'x')),
        (a, const AnswerResult(correct: false, expected: 'x')),
        (b, const AnswerResult(correct: true, expected: 'x')),
        (b, const AnswerResult(correct: true, expected: 'x')),
        (b, const AnswerResult(correct: true, expected: 'x')),
      ]);
      expect(s.percent, 80);
      expect(s.passed(80), isTrue);
      expect(s.passed(81), isFalse);
      expect(s.bySkill['grammar'], (correct: 1, total: 2));
      expect(s.bySkill['reading'], (correct: 3, total: 3));
    });

    test('skipped answers are excluded, and nothing answered never passes', () {
      final s = summarize([
        (a, const AnswerResult(correct: true, expected: 'x')),
        (a, const AnswerResult.skipped('x')),
      ]);
      expect(s.percent, 100);
      expect(s.skipped, 1);
      expect(summarize([(a, const AnswerResult.skipped('x'))]).passed(50),
          isFalse);
    });
  });

  group('level unlocking and completion', () {
    late List<Level> levels;
    setUpAll(() async => levels = (await loadCurriculum('de')).levels);

    test('only A1 is unlocked at the start', () {
      expect(unlockedLevels(levels, passedExams: {}), {'de_a1'});
    });

    test('passing an exam unlocks exactly the next level', () {
      expect(
          unlockedLevels(levels, passedExams: {'de_a1'}), {'de_a1', 'de_a2'});
      expect(unlockedLevels(levels, passedExams: {'de_a1', 'de_a2'}).length, 3);
    });

    test('a chosen or placed start level unlocks up to it', () {
      expect(unlockedLevels(levels, startLevelId: 'de_b1', passedExams: {}),
          {'de_a1', 'de_a2', 'de_b1'});
      expect(
          unlockedLevels(levels, startLevelId: 'de_b1', passedExams: {'de_b1'})
              .length,
          4);
    });

    test('completion requires every lesson AND the exam', () {
      final a1 = levels.first;
      final all = a1.lessons.map((l) => l.id).toSet();
      expect(levelCompleted(a1, all, {}), isFalse, reason: 'lessons only');
      expect(levelCompleted(a1, {}, {'de_a1'}), isFalse, reason: 'exam only');
      expect(levelCompleted(a1, all, {'de_a1'}), isTrue);
      expect(levelProgress(a1, all, {}), closeTo(10 / 11, 1e-9));
    });
  });

  group('placement', () {
    late List<Level> levels;
    setUpAll(() async => levels = (await loadCurriculum('ko')).levels);

    test('uses three auto-graded questions per level', () {
      for (final l in levels) {
        final qs = placementQuestionsFor(l);
        expect(qs.length, placementPerLevel);
        expect(qs.every((q) => q.autoGradable), isTrue);
      }
    });

    test('recommends the first level with fewer than 2 of 3 correct', () {
      expect(
          recommendLevel(levels, {'ko_l1': (correct: 1, total: 3)}), 'ko_l1');
      expect(
          recommendLevel(levels, {
            'ko_l1': (correct: 3, total: 3),
            'ko_l2': (correct: 2, total: 3),
            'ko_l3': (correct: 0, total: 3),
          }),
          'ko_l3');
      expect(
          recommendLevel(
              levels, {for (final l in levels) l.id: (correct: 3, total: 3)}),
          'ko_l6');
    });
  });
}
