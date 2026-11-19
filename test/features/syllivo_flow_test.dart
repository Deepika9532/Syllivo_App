import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../curriculum_utils.dart';
import '../helpers.dart';

void main() {
  late Curriculum de, ko;
  setUpAll(() async {
    de = await loadCurriculum('de');
    ko = await loadCurriculum('ko');
  });

  testWidgets('splash → onboarding → personalised Korean dashboard',
      (tester) async {
    final app = await pumpLingo(tester, onboarded: false, authChoice: null);
    expect(find.byKey(const Key('login-title')), findsOneWidget);
    await tester.tap(find.byKey(const Key('continue-guest')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('name-field')), 'Ravi');
    await tapText(tester, 'Get started');
    await tester.tap(find.byKey(const Key('lang-option-ko')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('onboard-next')));
    await settle(tester);
    await tester.scrollUntilVisible(
        find.byKey(const Key('level-option-ko_l2')), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.byKey(const Key('level-option-ko_l2')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('onboard-next')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('goal-30')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('onboard-next')));
    await settle(tester);
    expect(find.text('Start at L2 · Beginner'), findsOneWidget);
    await tester.tap(find.byKey(const Key('start-beginner')));
    await settle(tester);

    // The welcome-to-course screen shows the first Korean L2 course.
    expect(
        tester.widget<Text>(find.byKey(const Key('welcome-course-meta'))).data,
        startsWith('Korean · L2 Beginner'));
    expect(find.byKey(const Key('welcome-continue')), findsOneWidget);
    await tapText(tester, 'Go to Home');

    // Home reflects the choices.
    expect(find.text('Ravi!'), findsOneWidget);
    expect(find.byKey(const Key('course-ko')), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('home-level'))).data,
        startsWith('Korean · L2 Beginner'));
    expect(find.text('0/30'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarded'), isTrue);
    expect(prefs.getString('lang'), 'ko');
    final lp =
        await tester.runAsync(() => app.db.watchLanguageProgress('ko').first);
    expect(lp!.startLevelId, 'ko_l2');
    await finish(tester, app);
  });

  testWidgets('every bottom tab opens a working screen', (tester) async {
    final app = await pumpLingo(tester);
    await tapTab(tester, 'Learn');
    expect(find.text('Learning journey'), findsOneWidget);
    expect(find.byKey(const Key('node-de_a1_vocabulary_1')), findsOneWidget);
    await tapTab(tester, 'Practice');
    expect(find.text('Practice · German'), findsOneWidget);
    expect(find.byKey(const Key('daily-challenges')), findsOneWidget);
    await tapTab(tester, 'Progress');
    expect(find.text('Your progress'), findsOneWidget);
    expect(find.byKey(const Key('stat-xp')), findsOneWidget);
    await tapTab(tester, 'Profile');
    expect(find.byKey(const Key('profile-name')), findsOneWidget);
    await tapTab(tester, 'Home');
    expect(find.byKey(const Key('continue-learning-home')), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('journey node opens a lesson; locked levels explain why',
      (tester) async {
    final app = await pumpLingo(tester);
    await tapTab(tester, 'Learn');
    await tester.tap(find.byKey(const Key('node-de_a1_vocabulary_1')));
    await settle(tester);
    expect(find.text('A1 · Vocabulary'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);

    await tester.scrollUntilVisible(
        find.byKey(const Key('node-de_a2_vocabulary_1')), 400,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.byKey(const Key('node-de_a2_vocabulary_1')));
    await tester.pump();
    expect(find.textContaining('Locked.'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('lesson awards XP, costs hearts on mistakes and updates Home',
      (tester) async {
    final app = await pumpLingo(tester);
    final quiz = de.lesson('de_a1_quiz_1')!;
    await goTo(tester, '/learn/de/lesson/${quiz.id}');
    await startPractice(tester);
    expect(find.text('1 / 5'), findsOneWidget);

    await answerQuestion(tester, quiz.questions[0], correct: false);
    expect(find.text('Not quite'), findsOneWidget);
    expect(find.bySemanticsLabel('4 hearts left'), findsOneWidget,
        reason: 'one heart lost');
    await tapContinue(tester);
    for (var i = 1; i < quiz.questions.length; i++) {
      await answerQuestion(tester, quiz.questions[i], correct: true);
      await tapContinue(tester);
    }
    expect(find.text('Lesson complete!'), findsOneWidget);
    expect(find.text('+10'), findsOneWidget);

    expect(await tester.runAsync(() => app.db.currentHearts(testNow)), 4);
    final xp = await tester.runAsync(() => app.db.watchTotalXp().first);
    expect(xp, greaterThanOrEqualTo(10));
    await finish(tester, app);
  });

  testWidgets('with no hearts left, the lesson offers a refill instead',
      (tester) async {
    final app = await pumpLingo(tester, prepare: (db) async {
      for (var i = 0; i < 5; i++) {
        await db.loseHeart(testNow);
      }
    });
    await goTo(tester, '/learn/de/lesson/de_a1_quiz_1');
    await startPractice(tester);
    expect(find.byKey(const Key('out-of-hearts')), findsOneWidget);
    expect(find.text('Practise to refill'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('translation with word tiles and picture vocabulary',
      (tester) async {
    final app = await pumpLingo(tester);
    // A1 exercises: question 2 is "I am tired." → Ich bin müde.
    final lesson = de.lesson('de_a1_exercises_1')!;
    final tq = lesson.questions.firstWhere((q) => q.type == 'translate');
    await goTo(tester, '/learn/de/lesson/${lesson.id}');
    await startPractice(tester);
    for (final q in lesson.questions) {
      if (q.id != tq.id) {
        await answerQuestion(tester, q, correct: true);
        await tapContinue(tester);
        continue;
      }
      // Build the answer from tiles.
      for (final word in q.answers.first.split(' ')) {
        final tile = find.byWidgetPredicate((w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('tile-') &&
            find
                .descendant(of: find.byWidget(w), matching: find.text(word))
                .evaluate()
                .isNotEmpty);
        await tester.tap(tile.first);
        await tester.pump();
      }
      await tester.tap(find.byKey(const Key('check-answer')));
      await settle(tester);
      expect(find.text('Correct!'), findsOneWidget);
      await tapContinue(tester);
      break;
    }

    // Korean picture question.
    final vocab = ko.lesson('ko_l1_vocabulary_1')!;
    final pic = vocab.questions.firstWhere((q) => q.type == 'image');
    await goTo(tester, '/learn/ko/lesson/${vocab.id}');
    await startPractice(tester);
    for (final q in vocab.questions) {
      await answerQuestion(tester, q, correct: true);
      if (q.id == pic.id) {
        expect(find.text('Correct!'), findsOneWidget);
        expect(app.tts.spoken, contains(pic.options[pic.answer!]),
            reason: 'tapping a picture speaks the word');
      }
      await tapContinue(tester);
    }
    expect(find.text('Lesson complete!'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('app restart resumes the unfinished lesson from Home',
      (tester) async {
    var app = await pumpLingo(tester);
    final grammar = de.lesson('de_a1_grammar_1')!;
    await goTo(tester, '/learn/de/lesson/${grammar.id}');
    await startPractice(tester);
    await answerQuestion(tester, grammar.questions[0], correct: true);
    await tapContinue(tester);
    final db = app.db;
    await finish(tester, app, closeDb: false);

    // "Restart": a fresh widget tree and providers on the same database.
    app = await pumpLingo(tester, db: db, prefs: const {});
    expect(find.textContaining(grammar.title), findsWidgets,
        reason: 'Home shows it as up next');
    await tester.tap(find.byKey(const Key('continue-learning-home')));
    await settle(tester);
    await tester.scrollUntilVisible(
        find.byKey(const Key('resume-practice')), 300,
        scrollable: lessonScrollable());
    expect(find.textContaining('question 2 of ${grammar.questions.length}'),
        findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('passing an exam awards XP and shows on Progress',
      (tester) async {
    final app = await pumpLingo(tester);
    final a1 = de.levels.first;
    await goTo(tester, '/learn/de/exam/${a1.id}');
    await tester.tap(find.byKey(const Key('start-exam')));
    await settle(tester);
    for (final q in a1.exam) {
      await answerQuestion(tester, q, correct: true);
    }
    expect(find.text('Passed!'), findsOneWidget);
    expect(find.text('+50 XP'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);
    await tapTab(tester, 'Progress');
    await tester.scrollUntilVisible(find.text('German A1 examination'), 300,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('100%'), findsWidgets);
    await finish(tester, app);
  });
}
