import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/curriculum_providers.dart';
import 'package:syllivo/features/curriculum/grading.dart';
import 'package:syllivo/features/curriculum/models.dart';

import '../../curriculum_utils.dart';
import '../../helpers.dart';

void main() {
  late Curriculum de;
  setUpAll(() async => de = await loadCurriculum('de'));

  Future<void> scrollTo(WidgetTester tester, Finder f) async {
    await tester.scrollUntilVisible(f, 300,
        scrollable: find.byType(Scrollable).first);
    await settle(tester);
  }

  testWidgets('course overview shows A1 current and later levels locked',
      (tester) async {
    final app = await pumpLingo(tester);
    expect(find.byKey(const Key('progress-de')), findsOneWidget);

    await goTo(tester, '/learn/de');
    expect(find.byKey(const Key('current-level')), findsOneWidget);
    expect(find.textContaining('A1 · Beginner'), findsWidgets);

    await scrollTo(tester, find.byKey(const Key('level-de_b1')));
    await tester.tap(find
        .descendant(
            of: find.byKey(const Key('level-de_b1')),
            matching: find.byType(ListTile))
        .first);
    await tester.pump();
    expect(find.textContaining('Locked.'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('completing a lesson saves progress; partial runs resume',
      (tester) async {
    final app = await pumpLingo(tester);
    final quiz = de.lesson('de_a1_quiz_1')!;

    // Answer two questions, then leave.
    await goTo(tester, '/learn/de/lesson/${quiz.id}');
    await tapText(
        tester, 'Start practice · ${quiz.questions.length} questions');
    for (var i = 0; i < 2; i++) {
      await answerQuestion(tester, quiz.questions[i], correct: true);
      expect(find.text('Correct!'), findsOneWidget);
      await tapContinue(tester);
    }
    await tester.tap(find.byTooltip('Leave lesson (progress is saved)'));
    await settle(tester);

    // Reopen: resume at question 3.
    await goTo(tester, '/learn/de/lesson/${quiz.id}');
    await scrollTo(tester, find.byKey(const Key('resume-practice')));
    expect(find.textContaining('question 3 of ${quiz.questions.length}'),
        findsOneWidget);
    await tester.tap(find.byKey(const Key('resume-practice')));
    await settle(tester);

    // One wrong answer shows the correct answer and explanation.
    await answerQuestion(tester, quiz.questions[2], correct: false);
    expect(find.text('Not quite'), findsOneWidget);
    expect(find.byKey(const Key('expected-answer')), findsOneWidget);
    expect(find.text(quiz.questions[2].explanation!), findsOneWidget);
    await tapContinue(tester);
    for (var i = 3; i < quiz.questions.length; i++) {
      await answerQuestion(tester, quiz.questions[i], correct: true);
      await tapContinue(tester);
    }

    // 4 of 5 = 80% → passes the default 80% mark.
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Lesson complete!'), findsOneWidget);
    final p = await tester.runAsync(() => app.db.getLessonProgress(quiz.id));
    expect(p!.status, 2);
    expect(p.bestScore, 80);
    await finish(tester, app);
  });

  testWidgets('every exercise type works through the UI', (tester) async {
    final app = await pumpLingo(tester);
    // A2 exercises + A1 exercises/writing/vocabulary cover mcq, fill,
    // translate, correction, order, match, write and picture questions.
    for (final id in [
      'de_a2_exercises_1',
      'de_a1_exercises_1',
      'de_a1_writing_1'
    ]) {
      final lesson = de.lesson(id)!;
      await goTo(tester, '/learn/de/lesson/$id');
      await scrollTo(tester, find.byKey(const Key('start-practice')));
      await tester.tap(find.byKey(const Key('start-practice')));
      await settle(tester);
      for (final q in lesson.questions) {
        await answerQuestion(tester, q, correct: true);
        expect(find.byKey(const Key('feedback')), findsOneWidget);
        await tapContinue(tester);
      }
      expect(find.text('100%'), findsOneWidget, reason: id);
      await tester.ensureVisible(find.text('Back to journey'));
      await tester.pump();
      await tapText(tester, 'Back to journey');
    }
    await finish(tester, app);
  });

  testWidgets('passing the A1 exam unlocks A2', (tester) async {
    final app = await pumpLingo(tester);
    final a1 = de.levels.first;
    await goTo(tester, '/learn/de/exam/${a1.id}');
    await tester.tap(find.byKey(const Key('start-exam')));
    await settle(tester);
    for (var i = 0; i < a1.exam.length; i++) {
      // Two wrong answers: 10/12 = 83% ≥ 80%.
      await answerQuestion(tester, a1.exam[i], correct: i >= 2);
    }
    expect(find.text('Passed!'), findsOneWidget);
    expect(find.text('83%'), findsOneWidget);
    expect(find.textContaining('A2 is now unlocked'), findsOneWidget);

    final state = await tester.runAsync(
        () => containerOf(tester).read(learnStateProvider('de').future));
    expect(state!.unlocked, contains('de_a2'));
    await finish(tester, app);
  });

  testWidgets('failing the exam keeps the next level locked', (tester) async {
    final app = await pumpLingo(tester);
    final a1 = de.levels.first;
    await goTo(tester, '/learn/de/exam/${a1.id}');
    await tester.tap(find.byKey(const Key('start-exam')));
    await settle(tester);
    for (final q in a1.exam) {
      await answerQuestion(tester, q, correct: false);
    }
    expect(find.text('Not passed yet'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    final attempts =
        await tester.runAsync(() => app.db.watchExamAttempts('de').first);
    expect(attempts!.single.passed, isFalse);
    await finish(tester, app);
  });

  testWidgets('speech unavailable shows help and can be skipped',
      (tester) async {
    final app = await pumpLingo(tester, stt: FakeStt(available: false));
    final speaking = de.lesson('de_a1_speaking_1')!;
    await goTo(tester, '/learn/de/lesson/${speaking.id}');
    await scrollTo(tester, find.byKey(const Key('start-practice')));
    await tester.tap(find.byKey(const Key('start-practice')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('mic')));
    await settle(tester);
    expect(find.byKey(const Key('speech-error')), findsOneWidget);
    expect(find.textContaining('microphone permission'), findsOneWidget);

    final skip = find.text('Skip — can’t speak right now');
    await tester.ensureVisible(skip);
    await tester.pump();
    await tester.tap(skip);
    await settle(tester);
    expect(find.text('Skipped — not counted in your score'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('speaking with recognition gives a score and syllable feedback',
      (tester) async {
    final target = de.lesson('de_a1_speaking_1')!.questions.first.audio!;
    final app = await pumpLingo(tester, stt: FakeStt(heard: target));
    await goTo(tester, '/learn/de/lesson/de_a1_speaking_1');
    await scrollTo(tester, find.byKey(const Key('start-practice')));
    await tester.tap(find.byKey(const Key('start-practice')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('mic')));
    await settle(tester);
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('100/100'), findsOneWidget);
    expect(find.byKey(const Key('pronunciation-diff')), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('placement test recommends and unlocks a starting level',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/placement');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    // Ace A1 and A2, miss everything at B1.
    for (final level in de.levels.take(3)) {
      for (final q in placementQuestionsFor(level)) {
        await answerQuestion(tester, q, correct: level.code != 'B1');
        await tapContinue(tester); // feedback is shown after each answer
      }
    }
    expect(find.byKey(const Key('placement-result')), findsOneWidget);
    expect(find.text('B1'), findsWidgets);
    await tester.tap(find.byKey(const Key('accept-placement')));
    await settle(tester);
    expect(find.byKey(const Key('welcome-course-title')), findsOneWidget);

    final state = await tester.runAsync(
        () => containerOf(tester).read(learnStateProvider('de').future));
    expect(state!.unlocked, {'de_a1', 'de_a2', 'de_b1'});
    expect(state.completedLessons, isEmpty,
        reason: 'placement never marks lessons done');
    await finish(tester, app);
  });

  testWidgets('dashboard and settings render per-language progress',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/ko/dashboard');
    expect(find.byKey(const Key('overall-completion')), findsOneWidget);
    expect(find.text('Overall completion 0%'), findsOneWidget);
    for (final m in ModuleType.values) {
      expect(find.text(m.label, skipOffstage: false), findsWidgets,
          reason: m.label);
    }
    await tester.scrollUntilVisible(find.text('Quiz performance'), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('No examinations taken yet.'), findsOneWidget);
    await goTo(tester, '/settings');
    expect(find.text('Pass mark for lessons and exams: 80%'), findsOneWidget);
    expect(find.text('Show Korean romanization'), findsOneWidget);
    await finish(tester, app);
  });
}
