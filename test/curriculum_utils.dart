import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/curriculum_repository.dart';
import 'package:syllivo/features/curriculum/models.dart';

import 'helpers.dart';

export 'helpers.dart' show DiskBundle;

Future<Curriculum> loadCurriculum(String lang) =>
    CurriculumRepository(DiskBundle()).load(lang);

/// Answers [q] through the real QuestionView widgets.
Future<void> answerQuestion(WidgetTester tester, Question q,
    {required bool correct}) async {
  switch (q.type) {
    case 'mcq':
    case 'listening':
      final i = correct ? q.answer! : (q.answer! + 1) % q.options.length;
      final option = find.byKey(Key('option-$i'));
      await tester.ensureVisible(option);
      await tester.pump();
      await tester.tap(option);
    case 'image':
      final i = correct ? q.answer! : (q.answer! + 1) % q.options.length;
      final option = find.byKey(Key('image-option-$i'));
      await tester.ensureVisible(option);
      await tester.pump();
      await tester.tap(option);
    case 'translate':
      // Lessons offer word tiles; switch to the keyboard to type exactly.
      if (find.byKey(const Key('use-keyboard')).evaluate().isNotEmpty) {
        await tester.tap(find.byKey(const Key('use-keyboard')));
        await tester.pump();
      }
      await tester.enterText(find.byKey(const Key('answer-field')),
          correct ? q.answers.first : 'xyz');
    case 'fill':
    case 'correction':
      await tester.enterText(find.byKey(const Key('answer-field')),
          correct ? q.answers.first : 'xyz');
    case 'write':
      await tester.enterText(
          find.byKey(const Key('answer-field')), correct ? q.sample! : 'kurz');
    case 'order':
      // Map each tile position to its word, then tap in the wanted order.
      final tiles = <int, String>{};
      for (var p = 0; p < q.words.length; p++) {
        final f = find.descendant(
            of: find.byKey(Key('word-$p')), matching: find.byType(Text));
        tiles[p] = tester.widget<Text>(f).data!;
      }
      final words = correct ? q.words : q.words.reversed.toList();
      final used = <int>{};
      for (final w in words) {
        final p = tiles.entries
            .firstWhere((e) => e.value == w && !used.contains(e.key))
            .key;
        used.add(p);
        final tile = find.byKey(Key('word-$p'));
        await tester.ensureVisible(tile);
        await tester.pump();
        await tester.tap(tile);
        await tester.pump();
      }
    case 'match':
      final n = q.pairs.length;
      for (var i = 0; i < n; i++) {
        final right = correct ? q.pairs[i][1] : q.pairs[(i + 1) % n][1];
        final l = find.text(q.pairs[i][0]).first;
        await tester.ensureVisible(l);
        await tester.pump();
        await tester.tap(l);
        await tester.pump();
        final r = find.text(right).last;
        await tester.ensureVisible(r);
        await tester.pump();
        await tester.tap(r);
        await tester.pump();
      }
    default:
      throw UnsupportedError('answerQuestion: ${q.type}');
  }
  await tester.pump();
  final check = find.byKey(const Key('check-answer'));
  await tester.ensureVisible(check);
  await tester.pump();
  await tester.tap(check);
  await settle(tester);
}

Future<void> tapContinue(WidgetTester tester) async {
  final c = find.byKey(const Key('continue'));
  await tester.ensureVisible(c);
  await tester.pump();
  await tester.tap(c);
  await settle(tester);
}

/// Scrolls the lesson intro to its Start button and taps it.
Future<void> startPractice(WidgetTester tester) async {
  final start = find.byKey(const Key('start-practice'));
  await tester.scrollUntilVisible(start, 300, scrollable: lessonScrollable());
  await tester.pump();
  await tester.tap(start);
  await settle(tester);
}

/// The vertical scroll area of the top-most screen (skips horizontal
/// table scrollers inside lesson content).
Finder lessonScrollable() => find
    .descendant(
        of: find.byType(ListView).last, matching: find.byType(Scrollable))
    .first;
