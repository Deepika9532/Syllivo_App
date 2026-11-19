import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/db/app_database.dart';
import 'package:syllivo/core/providers.dart';
import 'package:syllivo/features/curriculum/curriculum_providers.dart';
import 'package:syllivo/features/curriculum/curriculum_repository.dart';
import 'package:syllivo/features/gamification/game.dart';
import 'package:syllivo/features/gamification/game_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers.dart';

void main() {
  final now = DateTime(2026, 11, 10, 9); // a Tuesday
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('periods', () {
    test('day and week keys follow the local calendar', () {
      expect(dayKey(now), 'D2026-11-10');
      expect(weekKey(now), 'W2026-11-09'); // Monday
      expect(weekKey(DateTime(2026, 11, 15, 23)), 'W2026-11-09'); // Sunday
      expect(weekKey(DateTime(2026, 11, 16)), 'W2026-11-16');
    });

    test('daily missions are stable per day, always include the goal, and vary',
        () {
      final a = missionsFor(now, 20).map((m) => m.id).toList();
      expect(missionsFor(now, 20).map((m) => m.id), a);
      expect(a.first, 'daily_goal');
      expect(a.length, 4);
      expect(a.toSet().length, 4);
      final days = {
        for (var d = 0; d < 7; d++)
          missionsFor(DateTime(2026, 11, 10 + d), 20).map((m) => m.id).join()
      };
      expect(days.length, greaterThan(1));
    });
  });

  group('XP and missions in the database', () {
    test('XP totals and learning XP exclude rewards', () async {
      await db.addXp('de', 10, 'lesson:grammar', now);
      await db.addXp('de', 15, 'mission:grammar_lesson', now);
      await db.addXp('', 25, 'badge:first_lesson', now);
      expect(await db.watchTotalXp().first, 50);
      expect(await db.learningXpBetween(dayStart(now), nextDay(now)), 10);
      expect(
          await db.countXpEvents('lesson:%', dayStart(now), nextDay(now)), 1);
    });

    test('a mission is claimed once per period and history is kept', () async {
      expect(await db.claimMission('D2026-11-10', 'review_15', 15, 'de', now),
          isTrue);
      expect(await db.claimMission('D2026-11-10', 'review_15', 15, 'de', now),
          isFalse);
      expect(
          await db.claimMission('D2026-11-11', 'review_15', 15, 'de',
              now.add(const Duration(days: 1))),
          isTrue);
      expect(await db.watchTotalXp().first, 30);
      expect(await db.totalMissionsCompleted(), 2);
      expect(await db.claimedMissions('D2026-11-10'), {'review_15'});
    });

    test('mission measures read real activity', () async {
      await db.upsertPack(testPack, now);
      final row = await db.getReviewRow('c1');
      await db.saveReview('c1', row.toSrs().copyWith(repetitions: 1),
          rating: 4, elapsedMs: 1, now: now);
      await db.recordAnswer(
          lang: 'de',
          levelId: 'de_a1',
          moduleType: 'listening',
          lessonId: 'L',
          questionId: 'q',
          questionType: 'listening',
          correct: true,
          skipped: false,
          answer: 'x',
          nextIndex: 1,
          now: now);
      final f = dayStart(now), t = nextDay(now);
      expect(await db.reviewsBetween(f, t), 1);
      expect(await db.newCardsBetween(f, t), 1);
      expect(await db.attemptsBetween(['listening'], f, t), 1);
      expect(await db.activeDaysBetween(weekStart(now), DateTime(2026, 11, 16)),
          1);
    });

    test('weekly XP chart has seven days ending today', () async {
      await db.addXp('de', 12, 'lesson:quiz', now);
      await db.addXp('de', 5, 'review', now.subtract(const Duration(days: 2)));
      final week = await db.xpByDay(now, 7);
      expect(week.length, 7);
      expect(week.last.day, dayStart(now));
      expect(week.last.xp, 12);
      expect(week[4].xp, 5);
    });
  });

  group('hearts', () {
    test('lose one per mistake, regenerate one per 30 minutes, refill',
        () async {
      expect(await db.currentHearts(now), 5);
      expect(await db.loseHeart(now), 4);
      expect(await db.loseHeart(now), 3);
      expect(await db.currentHearts(now.add(const Duration(minutes: 29))), 3);
      expect(await db.currentHearts(now.add(const Duration(minutes: 61))), 5);
      for (var i = 0; i < 5; i++) {
        await db.loseHeart(now.add(const Duration(hours: 2)));
      }
      expect(await db.currentHearts(now.add(const Duration(hours: 2))), 0);
      await db.refillHearts(now.add(const Duration(hours: 2)));
      expect(await db.currentHearts(now.add(const Duration(hours: 2))), 5);
    });
  });

  group('providers', () {
    late ProviderContainer c;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'lang': 'de'});
      c = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPrefsProvider
            .overrideWithValue(await SharedPreferences.getInstance()),
        clockProvider.overrideWithValue(() => now),
        curriculumRepositoryProvider
            .overrideWithValue(CurriculumRepository(DiskBundle())),
      ]);
    });
    tearDown(() => c.dispose());

    Future<T> read<T>(
        ProviderListenable<AsyncValue<T>> p, Refreshable<Future<T>> f) {
      final sub = c.listen(p, (_, __) {});
      addTearDown(sub.close);
      return c.read(f);
    }

    test('profile preferences persist', () {
      final n = c.read(profileProvider.notifier);
      expect(c.read(profileProvider).onboarded, isFalse);
      n.setName('Ravi');
      n.setDailyGoal(30);
      n.setHeartsEnabled(false);
      n.completeOnboarding();
      final p = c.read(profileProvider);
      expect((p.name, p.dailyGoalXp, p.heartsEnabled, p.onboarded),
          ('Ravi', 30, false, true));
      expect(c.read(sharedPrefsProvider).getInt('dailyGoalXp'), 30);
    });

    test('completing the daily goal claims its mission automatically',
        () async {
      c.read(profileProvider.notifier).setDailyGoal(10);
      await db.addXp('de', 12, 'lesson:quiz', now);
      final missions =
          await read(dailyMissionsProvider, dailyMissionsProvider.future);
      final goal = missions.firstWhere((m) => m.mission.id == 'daily_goal');
      expect(goal.done, isTrue);
      expect(goal.claimed, isTrue);
      expect(await db.claimedMissions(dayKey(now)), contains('daily_goal'));
      expect(await db.watchTotalXp().first, 12 + 10);
    });

    test('badges unlock once with a date and award XP', () async {
      await db.finishLessonRun(
          lang: 'de',
          levelId: 'de_a1',
          moduleType: 'quiz',
          lessonId: 'de_a1_quiz_1',
          percent: 100,
          passed: true,
          now: now);
      await db.addXp('de', 15, 'lesson:quiz', now);
      final list = await read(badgesProvider, badgesProvider.future);
      final first = list.firstWhere((b) => b.def.id == 'first_lesson');
      expect(first.earned, isTrue);
      expect(first.unlockedAt, now);
      expect(list.firstWhere((b) => b.def.id == 'lessons_10').earned, isFalse);
      final unlocks = await db.watchBadgeUnlocks().first;
      expect(unlocks.map((u) => u.badgeId), contains('first_lesson'));
      expect(await db.countXpEvents('badge:%', DateTime(2000), DateTime(3000)),
          unlocks.length);
    });

    test('game service awards lesson, exam and one-time level XP', () async {
      final g = c.read(gameServiceProvider);
      expect(await g.lessonFinished('de', 'grammar', 100, true),
          Xp.lessonPassed + Xp.perfectBonus);
      expect(
          await g.lessonFinished('de', 'grammar', 50, false), Xp.lessonAttempt);
      expect(await g.examFinished('de', 'de_a1', true), Xp.examPassed);
      expect(await g.levelCompleted('de', 'de_a1'), Xp.levelComplete);
      expect(await g.levelCompleted('de', 'de_a1'), 0, reason: 'only once');
      expect(await db.watchTotalXp().first, 15 + 3 + 50 + 100);
    });

    test('hearts are not spent when disabled', () async {
      c.read(profileProvider.notifier).setHeartsEnabled(false);
      expect(await c.read(gameServiceProvider).loseHeart(), maxHearts);
      expect(await db.currentHearts(now), 5);
    });
  });
}
