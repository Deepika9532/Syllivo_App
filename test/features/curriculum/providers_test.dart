import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/db/app_database.dart';
import 'package:syllivo/core/providers.dart';
import 'package:syllivo/features/curriculum/curriculum_providers.dart';
import 'package:syllivo/features/curriculum/curriculum_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../curriculum_utils.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  final now = DateTime(2026, 11, 10, 9);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPrefsProvider
          .overrideWithValue(await SharedPreferences.getInstance()),
      curriculumRepositoryProvider
          .overrideWithValue(CurriculumRepository(DiskBundle())),
      clockProvider.overrideWithValue(() => now),
    ]);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<LearnState> state(String lang) {
    final sub = container.listen(learnStateProvider(lang), (_, __) {});
    addTearDown(sub.close);
    return container.read(learnStateProvider(lang).future);
  }

  test('fresh learner starts at A1 with only A1 unlocked', () async {
    final s = await state('de');
    expect(s.currentLevel.code, 'A1');
    expect(s.unlocked, {'de_a1'});
    expect(s.overall, 0);
    expect(s.nextLesson!.id, 'de_a1_vocabulary_1');
  });

  test('passing the A1 exam unlocks A2; German and Korean are independent',
      () async {
    await db.saveExamAttempt(
        lang: 'de',
        levelId: 'de_a1',
        kind: 'exam',
        percent: 90,
        passed: true,
        threshold: 80,
        detailJson: '{}',
        startedAt: now,
        finishedAt: now);
    container.invalidate(examAttemptsProvider('de'));
    final de = await state('de');
    expect(de.unlocked, containsAll(['de_a1', 'de_a2']));
    expect(de.passedExams, {'de_a1'});
    final ko = await state('ko');
    expect(ko.unlocked, {'ko_l1'});
  });

  test('a failed exam does not unlock anything', () async {
    await db.saveExamAttempt(
        lang: 'de',
        levelId: 'de_a1',
        kind: 'exam',
        percent: 60,
        passed: false,
        threshold: 80,
        detailJson: '{}',
        startedAt: now,
        finishedAt: now);
    expect((await state('de')).unlocked, {'de_a1'});
  });

  test('placement start level unlocks lower levels without completing them',
      () async {
    await db.setStartLevel('de', 'de_b2', now, fromPlacement: true);
    final s = await state('de');
    expect(s.unlocked.length, 4);
    expect(s.currentLevel.code, 'B2');
    expect(s.completedLessons, isEmpty);
    expect(s.isCompleted(s.levels.first), isFalse);
  });

  test('resume points to the last unfinished lesson', () async {
    await db.markLessonOpened('ko', 'ko_l1', 'grammar', 'ko_l1_grammar_1', now);
    expect((await state('ko')).nextLesson!.id, 'ko_l1_grammar_1');
  });

  test('pass threshold and romanization settings persist', () async {
    expect(container.read(passThresholdProvider), 80);
    container.read(passThresholdProvider.notifier).set(70);
    expect(container.read(passThresholdProvider), 70);
    expect(container.read(sharedPrefsProvider).getInt('passPercent'), 70);

    expect(container.read(romanizationProvider), isTrue);
    container.read(romanizationProvider.notifier).set(false);
    expect(
        container.read(sharedPrefsProvider).getBool('romanization'), isFalse);
  });

  test(
      'curriculum vocabulary is seeded into review decks without resetting progress',
      () async {
    final repo = CurriculumRepository(DiskBundle());
    final c = await repo.load('de');
    await db.upsertPack(vocabDeckFor(c.levels.first), now);
    final cardId = vocabDeckFor(c.levels.first).cards.first.id;
    final row = await db.getReviewRow(cardId);
    await db.saveReview(cardId, row.toSrs().copyWith(repetitions: 3),
        rating: 4, elapsedMs: 1, now: now);
    await db.upsertPack(
        vocabDeckFor(c.levels.first), now); // re-seed same version
    expect((await db.getReviewRow(cardId)).repetitions, 3);
  });
}
