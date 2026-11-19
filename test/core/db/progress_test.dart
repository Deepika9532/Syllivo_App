import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/db/app_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 10, 9);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> answer(int index, bool correct, {bool skipped = false}) =>
      db.recordAnswer(
        lang: 'de',
        levelId: 'de_a1',
        moduleType: 'grammar',
        lessonId: 'de_a1_grammar_1',
        questionId: 'q$index',
        questionType: 'mcq',
        correct: correct,
        skipped: skipped,
        answer: 'x',
        nextIndex: index + 1,
        now: now,
      );

  test('answers are saved and the run can be resumed', () async {
    await answer(0, true);
    await answer(1, false);
    await answer(2, false, skipped: true);
    final p = (await db.getLessonProgress('de_a1_grammar_1'))!;
    expect(p.status, 1);
    expect(p.runIndex, 3);
    expect(p.runCorrect, 1);
    expect(p.runAnswered, 2);
    expect(p.runSkipped, 1);
    final lang = await db.watchLanguageProgress('de').first;
    expect(lang!.lastLessonId, 'de_a1_grammar_1');
  });

  test('finishing keeps the best score and completion is permanent', () async {
    var p = await db.finishLessonRun(
        lang: 'de',
        levelId: 'de_a1',
        moduleType: 'grammar',
        lessonId: 'L',
        percent: 90,
        passed: true,
        now: now);
    expect(p.status, 2);
    expect(p.bestScore, 90);
    expect(p.completedAt, now);

    p = await db.finishLessonRun(
        lang: 'de',
        levelId: 'de_a1',
        moduleType: 'grammar',
        lessonId: 'L',
        percent: 40,
        passed: false,
        now: now);
    expect(p.status, 2,
        reason: 'a later weak retry never un-completes a lesson');
    expect(p.bestScore, 90);
    expect(p.attempts, 2);
    expect(p.runIndex, 0);
  });

  test('exam attempts, start level and study time persist', () async {
    await db.saveExamAttempt(
        lang: 'ko',
        levelId: 'ko_l1',
        kind: 'exam',
        percent: 83.3,
        passed: true,
        threshold: 80,
        detailJson: '{}',
        startedAt: now,
        finishedAt: now);
    final exams = await db.watchExamAttempts('ko').first;
    expect(exams.single.passed, isTrue);
    expect(await db.watchExamAttempts('de').first, isEmpty,
        reason: 'languages are independent');

    await db.setStartLevel('ko', 'ko_l3', now, fromPlacement: true);
    final lp = await db.watchLanguageProgress('ko').first;
    expect(lp!.startLevelId, 'ko_l3');
    expect(lp.placementLevelId, 'ko_l3');

    await db.addStudyTime('ko', 60000, now);
    await db.addStudyTime('ko', 30000, now.add(const Duration(hours: 2)));
    expect(await db.studyMsOn('ko', now), 90000);
    expect(await db.totalStudyMs('ko'), 90000);
    expect(await db.studyMsOn('de', now), 0);
  });

  test('curriculum activity counts toward streak and heatmap', () async {
    await answer(0, true);
    final stats = await db.stats('de', now);
    expect(stats.streak, 1);
    expect(stats.activity.values.fold<int>(0, (a, b) => a + b), 1);
  });

  test('speaking scores are averaged per language', () async {
    await db.recordAnswer(
        lang: 'de',
        levelId: 'de_a1',
        moduleType: 'speaking',
        lessonId: 'S',
        questionId: 'a',
        questionType: 'speak',
        correct: true,
        skipped: false,
        answer: 'x',
        score: 80,
        nextIndex: 1,
        now: now);
    await db.recordAnswer(
        lang: 'de',
        levelId: 'de_a1',
        moduleType: 'speaking',
        lessonId: 'S',
        questionId: 'b',
        questionType: 'speak',
        correct: true,
        skipped: false,
        answer: 'x',
        score: 100,
        nextIndex: 2,
        now: now);
    expect(await db.avgSpeechScore('de'), 90);
    expect(await db.avgSpeechScore('ko'), isNull);
  });
}
