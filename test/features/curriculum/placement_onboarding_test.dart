import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syllivo/features/curriculum/curriculum_providers.dart';
import 'package:syllivo/features/curriculum/grading.dart';
import 'package:syllivo/features/curriculum/models.dart';
import 'package:syllivo/features/curriculum/screens/placement_screen.dart';

import '../../curriculum_utils.dart';
import '../../helpers.dart';

void main() {
  late Curriculum de, ko;
  setUpAll(() async {
    de = await loadCurriculum('de');
    ko = await loadCurriculum('ko');
  });

  Future<void> answer(WidgetTester tester, Question q, bool correct) async {
    await answerQuestion(tester, q, correct: correct);
    await tapContinue(tester);
  }

  test('placement progress survives encode/decode and rejects garbage', () {
    final p = PlacementProgress(
      levelIndex: 1,
      qIndex: 2,
      results: {'de_a1': (correct: 3, total: 3)},
      startedAt: DateTime(2026, 11, 1, 9),
    );
    final back = PlacementProgress.decode(p.encode())!;
    expect(back.levelIndex, 1);
    expect(back.qIndex, 2);
    expect(back.results['de_a1'], (correct: 3, total: 3));
    expect(back.startedAt, DateTime(2026, 11, 1, 9));
    expect(PlacementProgress.decode('{nope'), isNull);
    expect(PlacementProgress.decode(null), isNull);
  });

  test('German and Korean placement use only their own questions', () {
    final deIds = {
      for (final l in de.levels) ...placementQuestionsFor(l).map((q) => q.id)
    };
    final koIds = {
      for (final l in ko.levels) ...placementQuestionsFor(l).map((q) => q.id)
    };
    expect(deIds.intersection(koIds), isEmpty);
    expect(deIds, isNotEmpty);
    expect(koIds, isNotEmpty);
  });

  test('scoring: perfect run recommends the top level, a miss stops early', () {
    final all = {
      for (final l in de.levels) l.id: (correct: 3, total: 3),
    };
    expect(recommendLevel(de.levels, all), de.levels.last.id);
    expect(
        recommendLevel(de.levels, {
          'de_a1': (correct: 3, total: 3),
          'de_a2': (correct: 1, total: 3),
        }),
        'de_a2');
    expect(recommendLevel(de.levels, {}), de.levels.first.id);
  });

  testWidgets('submit stays disabled until an answer is given', (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/placement');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    final check =
        tester.widget<FilledButton>(find.byKey(const Key('check-answer')));
    expect(check.onPressed, isNull);
    expect(find.byKey(const Key('placement-progress')), findsOneWidget);
    expect(find.text('Question 1 of 3'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('closing mid-test resumes at the same question', (tester) async {
    var app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/placement');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    final a1 = placementQuestionsFor(de.levels.first);
    await answer(tester, a1[0], true);
    await answer(tester, a1[1], false);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(PlacementProgress.key('de')), isNotNull);
    await finish(tester, app);

    // "Restart the app" with the same preferences.
    app = await pumpLingo(tester, prefs: {
      for (final k in prefs.getKeys()) k: prefs.get(k)!,
    });
    await goTo(tester, '/learn/de/placement');
    expect(find.byKey(const Key('resume-placement')), findsOneWidget);
    await tester.tap(find.byKey(const Key('resume-placement')));
    await settle(tester);
    expect(find.text('Question 3 of 3'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('result is saved, offered again, and "start from A1" works',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/placement');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    // Pass A1, fail A2 → recommended A2.
    for (final level in de.levels.take(2)) {
      for (final q in placementQuestionsFor(level)) {
        await answer(tester, q, level.code == 'A1');
      }
    }
    expect(tester.widget<Text>(find.byKey(const Key('placement-result'))).data,
        'A2');
    expect(find.text('Elementary'), findsOneWidget);
    expect(find.text('3 of 6 correct'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(PlacementProgress.key('de')), isNull,
        reason: 'finished test clears the in-progress state');

    await tester.tap(find.byKey(const Key('start-from-first')));
    await settle(tester);
    expect(find.byKey(const Key('welcome-course-title')), findsOneWidget);
    expect(
        tester.widget<Text>(find.byKey(const Key('welcome-course-meta'))).data,
        startsWith('German · A1 Beginner'));
    final state = await tester.runAsync(
        () => containerOf(tester).read(learnStateProvider('de').future));
    expect(state!.unlocked, {'de_a1'}, reason: 'A1 only, nothing extra');

    // Back to the placement intro: the saved result is offered.
    await goTo(tester, '/learn/de/placement');
    expect(find.byKey(const Key('last-placement')), findsOneWidget);
    expect(find.textContaining('Last result: A2'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('Korean placement is independent of German progress',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/ko/placement');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    for (final level in ko.levels.take(2)) {
      for (final q in placementQuestionsFor(level)) {
        await answer(tester, q, level.code == 'L1');
      }
    }
    expect(tester.widget<Text>(find.byKey(const Key('placement-result'))).data,
        'L2');
    await tester.tap(find.byKey(const Key('accept-placement')));
    await settle(tester);
    final c = containerOf(tester);
    final koState =
        await tester.runAsync(() => c.read(learnStateProvider('ko').future));
    final deState =
        await tester.runAsync(() => c.read(learnStateProvider('de').future));
    expect(koState!.unlocked, {'ko_l1', 'ko_l2'});
    expect(deState!.unlocked, {'de_a1'});
    await finish(tester, app);
  });

  testWidgets('welcome screen Continue opens the next lesson', (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/welcome');
    final first = de.levels.first.lessons.first;
    expect(
        tester.widget<Text>(find.byKey(const Key('welcome-course-title'))).data,
        first.title);
    await tester.tap(find.byKey(const Key('welcome-continue')));
    await settle(tester);
    expect(find.text(first.title), findsWidgets);
    expect(find.byKey(const Key('welcome-continue')), findsNothing);
    await finish(tester, app);
  });

  testWidgets('home language card selects the language and opens Learn',
      (tester) async {
    final app = await pumpLingo(tester);
    await tester.scrollUntilVisible(find.byKey(const Key('switch-ko')), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const Key('switch-ko')));
    await settle(tester);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('lang'), 'ko');
    expect(find.byKey(const Key('welcome')), findsNothing,
        reason: 'left Home for the learning path');
    await finish(tester, app);
  });
}
