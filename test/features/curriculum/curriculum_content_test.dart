import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/curriculum_repository.dart';
import 'package:syllivo/features/curriculum/models.dart';

import '../../curriculum_utils.dart';

void main() {
  group('German curriculum', () {
    late Curriculum c;
    setUpAll(() async => c = await loadCurriculum('de'));

    test('has CEFR levels A1–C2 in order', () {
      expect(c.levels.map((l) => l.code), ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']);
    });

    test('every level has all ten modules with real lessons', () {
      for (final l in c.levels) {
        expect(l.modules.map((m) => m.type).toSet(), ModuleType.values.toSet(),
            reason: l.id);
        for (final lesson in l.lessons) {
          expect(lesson.blocks, isNotEmpty, reason: lesson.id);
          expect(lesson.questions.length, greaterThanOrEqualTo(3),
              reason: lesson.id);
        }
      }
    });

    test('grammar progression covers the expected topics', () {
      String grammar(String code) => jsonEncode(c.levels
          .firstWhere((l) => l.code == code)
          .modules
          .firstWhere((m) => m.type == ModuleType.grammar)
          .lessons
          .first
          .blocks
          .map((b) => b.data)
          .toList());
      expect(grammar('A1'), contains('der Tisch'));
      expect(grammar('A2'), contains('Dative'));
      expect(grammar('B1'), contains('Konjunktiv II'));
      expect(grammar('B2'), contains('worden'));
      expect(grammar('C1'), contains('Konjunktiv I'));
      expect(grammar('C2'), contains('Participial'));
    });

    test('alignment notes never claim official certification', () {
      for (final l in c.levels) {
        expect(l.alignment, contains('not an official certification'));
      }
    });
  });

  group('Korean curriculum', () {
    late Curriculum c;
    setUpAll(() async => c = await loadCurriculum('ko'));

    test('has Levels 1–6 in order', () {
      expect(c.levels.map((l) => l.code), ['L1', 'L2', 'L3', 'L4', 'L5', 'L6']);
    });

    test('Level 1 starts with Hangul, batchim and pronunciation', () {
      final l1 = c.levels.first;
      expect(
          l1.topics,
          containsAll(
              ['Hangul vowels', 'Hangul consonants', 'Batchim fundamentals']));
      final pron =
          l1.modules.firstWhere((m) => m.type == ModuleType.pronunciation);
      expect(jsonEncode(pron.lessons.first.blocks.map((b) => b.data).toList()),
          contains('[k]'));
    });

    test('TOPIK notes separate exam prep from speaking proficiency', () {
      for (final l in c.levels) {
        expect(l.alignment, contains('does not test speaking'), reason: l.id);
        expect(l.alignment, contains('Not an official TOPIK result'),
            reason: l.id);
      }
    });

    test('every level has all ten modules', () {
      for (final l in c.levels) {
        expect(l.modules.map((m) => m.type).toSet(), ModuleType.values.toSet());
      }
    });
  });

  group('JSON validation', () {
    test('bundled curriculum files are valid', () async {
      for (final lang in ['de', 'ko']) {
        final c = await loadCurriculum(lang); // throws if invalid
        expect(validateCurriculum(lang, c.levels), isEmpty);
      }
    });

    test('index lists every level file and nothing else', () async {
      final index =
          jsonDecode(File(curriculumIndexPath).readAsStringSync()) as Map;
      for (final entry in index.entries) {
        final listed = (entry.value as List).cast<String>().toSet();
        final onDisk = Directory('assets/curriculum/${entry.key}')
            .listSync()
            .map((f) => f.path.replaceAll('\\', '/'))
            .toSet();
        expect(listed, onDisk);
      }
    });

    test('exams are 10+ auto-graded questions covering several skills',
        () async {
      for (final lang in ['de', 'ko']) {
        for (final l in (await loadCurriculum(lang)).levels) {
          expect(l.exam.length, greaterThanOrEqualTo(10));
          expect(l.exam.every((q) => q.autoGradable), isTrue);
          expect(l.exam.map((q) => q.skill).toSet().length,
              greaterThanOrEqualTo(5),
              reason: '${l.id} exam should test several skills');
        }
      }
    });

    test('no placeholder text anywhere', () {
      for (final f in Directory('assets/curriculum')
          .listSync(recursive: true)
          .whereType<File>()) {
        final text = f.readAsStringSync().toLowerCase();
        for (final bad in [
          'lorem',
          'todo',
          'placeholder',
          'tbd',
          'coming soon'
        ]) {
          expect(text.contains(bad), isFalse,
              reason: '${f.path} contains "$bad"');
        }
      }
    });

    test('validator rejects broken questions', () {
      final bad = Question.fromJson({
        'id': 'x',
        'type': 'mcq',
        'prompt': 'Q',
        'options': ['a', 'a'],
        'answer': 5,
      });
      final errors = validateQuestion(bad);
      expect(errors, contains('x: answer index out of range'));
      expect(errors, contains('x: duplicate options'));
      expect(
          validateQuestion(Question.fromJson(
              {'id': 'w', 'type': 'write', 'prompt': 'Write', 'minWords': 0})),
          isNotEmpty);
    });

    test('validator reports a missing module', () async {
      final c = await loadCurriculum('de');
      final l = c.levels.first;
      final broken = Level(
        id: l.id,
        lang: l.lang,
        code: l.code,
        title: l.title,
        description: l.description,
        order: l.order,
        version: l.version,
        topics: l.topics,
        modules: l.modules.where((m) => m.type != ModuleType.speaking).toList(),
        exam: l.exam,
      );
      expect(validateCurriculum('de', [broken]),
          contains('de_a1: missing speaking module'));
    });
  });

  group('Vocabulary decks for spaced repetition', () {
    test('each level yields a deck with stable, unique card ids', () async {
      for (final lang in ['de', 'ko']) {
        for (final l in (await loadCurriculum(lang)).levels) {
          final deck = vocabDeckFor(l);
          expect(deck.cards, isNotEmpty, reason: l.id);
          expect(deck.cards.map((c) => c.id).toSet().length, deck.cards.length);
          expect(vocabDeckFor(l).cards.map((c) => c.id),
              deck.cards.map((c) => c.id),
              reason: 'ids must be deterministic');
        }
      }
    });
  });
}
