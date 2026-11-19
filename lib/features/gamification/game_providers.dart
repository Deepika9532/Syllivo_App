import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/providers.dart';
import '../curriculum/curriculum_providers.dart';
import 'game.dart';

// ---------------- Learner profile & preferences ----------------

class Profile {
  final String name;
  final int avatar;
  final bool onboarded;
  final int dailyGoalXp;
  final bool heartsEnabled;
  final int bestStreak;

  const Profile({
    required this.name,
    required this.avatar,
    required this.onboarded,
    required this.dailyGoalXp,
    required this.heartsEnabled,
    required this.bestStreak,
  });
}

const maxHearts = 5;
const dailyGoalOptions = [
  (xp: 10, label: 'Light', detail: 'About 5 minutes a day'),
  (xp: 20, label: 'Steady', detail: 'About 10 minutes a day'),
  (xp: 30, label: 'Focused', detail: 'About 15 minutes a day'),
  (xp: 50, label: 'Intense', detail: 'About 25 minutes a day'),
];

class ProfileNotifier extends Notifier<Profile> {
  @override
  Profile build() {
    final p = ref.watch(sharedPrefsProvider);
    return Profile(
      name: p.getString('profileName') ?? '',
      avatar: p.getInt('avatar') ?? 0,
      onboarded: p.getBool('onboarded') ?? false,
      dailyGoalXp: p.getInt('dailyGoalXp') ?? 20,
      heartsEnabled: p.getBool('heartsEnabled') ?? true,
      bestStreak: p.getInt('bestStreak') ?? 0,
    );
  }

  void setName(String v) => _save(
      () => ref.read(sharedPrefsProvider).setString('profileName', v.trim()));
  void setAvatar(int v) =>
      _save(() => ref.read(sharedPrefsProvider).setInt('avatar', v));
  void setDailyGoal(int v) =>
      _save(() => ref.read(sharedPrefsProvider).setInt('dailyGoalXp', v));
  void setHeartsEnabled(bool v) =>
      _save(() => ref.read(sharedPrefsProvider).setBool('heartsEnabled', v));
  void completeOnboarding() =>
      _save(() => ref.read(sharedPrefsProvider).setBool('onboarded', true));
  void restartOnboarding() =>
      _save(() => ref.read(sharedPrefsProvider).setBool('onboarded', false));

  /// Clears learner preferences (used when erasing all on-device data).
  void resetAll() {
    final p = ref.read(sharedPrefsProvider);
    for (final k in [
      'profileName',
      'avatar',
      'onboarded',
      'dailyGoalXp',
      'heartsEnabled',
      'bestStreak'
    ]) {
      p.remove(k);
    }
    ref.invalidateSelf();
  }

  void recordStreak(int streak) {
    if (streak > state.bestStreak) {
      _save(() => ref.read(sharedPrefsProvider).setInt('bestStreak', streak));
    }
  }

  void _save(Future<bool> Function() write) {
    write();
    ref.invalidateSelf();
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, Profile>(ProfileNotifier.new);

// ---------------- XP, streak, hearts ----------------

final totalXpProvider =
    StreamProvider<int>((ref) => ref.watch(databaseProvider).watchTotalXp());

/// Learning XP earned today (rewards excluded), for the daily goal ring.
final todayXpProvider = FutureProvider.autoDispose<int>((ref) async {
  await ref.watch(totalXpProvider.future);
  final now = ref.read(clockProvider)();
  return ref
      .watch(databaseProvider)
      .learningXpBetween(dayStart(now), nextDay(now));
});

final streakProvider = FutureProvider.autoDispose<int>((ref) async {
  await ref.watch(totalXpProvider.future);
  final s =
      await ref.watch(databaseProvider).stats('de', ref.read(clockProvider)());
  ref.read(profileProvider.notifier).recordStreak(s.streak);
  return s.streak;
});

final heartsTickProvider = StateProvider<int>((ref) => 0);

final heartsProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(heartsTickProvider);
  return ref
      .watch(databaseProvider)
      .currentHearts(ref.read(clockProvider)(), max: maxHearts);
});

final weeklyXpProvider =
    FutureProvider.autoDispose<List<({DateTime day, int xp})>>((ref) async {
  await ref.watch(totalXpProvider.future);
  return ref.watch(databaseProvider).xpByDay(ref.read(clockProvider)(), 7);
});

// ---------------- Missions & challenges ----------------

/// Evaluates missions for the current period and claims any completed ones
/// (once — claims are keyed by local date / week, so history is kept).
Future<List<MissionStatus>> _evaluate(Ref ref, List<Mission> missions,
    String key, DateTime from, DateTime to) async {
  final db = ref.read(databaseProvider);
  final now = ref.read(clockProvider)();
  final lang = ref.read(languageProvider);
  final claimed = await db.claimedMissions(key);
  final out = <MissionStatus>[];
  for (final m in missions) {
    final p = await m.measure(db, from, to);
    var isClaimed = claimed.contains(m.id);
    if (!isClaimed && p >= m.target) {
      await db.claimMission(key, m.id, m.xp, lang, now);
      isClaimed = true;
    }
    out.add(MissionStatus(m, p, isClaimed));
  }
  return out;
}

final dailyMissionsProvider =
    FutureProvider.autoDispose<List<MissionStatus>>((ref) async {
  await ref.watch(totalXpProvider.future);
  final goal = ref.watch(profileProvider.select((p) => p.dailyGoalXp));
  final now = ref.read(clockProvider)();
  return _evaluate(
      ref, missionsFor(now, goal), dayKey(now), dayStart(now), nextDay(now));
});

final weeklyChallengesProvider =
    FutureProvider.autoDispose<List<MissionStatus>>((ref) async {
  await ref.watch(totalXpProvider.future);
  final now = ref.read(clockProvider)();
  final ws = weekStart(now);
  return _evaluate(ref, weeklyChallenges, weekKey(now), ws,
      DateTime(ws.year, ws.month, ws.day + 7));
});

// ---------------- Badges ----------------

class BadgeState {
  final BadgeDef def;
  final double progress;
  final DateTime? unlockedAt;
  const BadgeState(this.def, this.progress, this.unlockedAt);
  bool get earned => unlockedAt != null;
}

final badgeContextProvider =
    FutureProvider.autoDispose<BadgeContext>((ref) async {
  final db = ref.watch(databaseProvider);
  final totalXp = await ref.watch(totalXpProvider.future);
  final streak = await ref.watch(streakProvider.future);
  var levels = 0, exams = 0;
  for (final lang in ['de', 'ko']) {
    final s = await ref.watch(learnStateProvider(lang).future);
    levels += s.levels.where(s.isCompleted).length;
    exams += s.passedExams.length;
  }
  return BadgeContext(
    totalXp: totalXp,
    lessons: await db.totalLessonsCompleted(),
    learnedWords: await db.totalLearnedCards(),
    bestStreak: [streak, ref.read(profileProvider).bestStreak]
        .reduce((a, b) => a > b ? a : b),
    missions: await db.totalMissionsCompleted(),
    perfectVoice: await db.totalPerfectPronunciations(),
    levels: levels,
    exams: exams,
  );
});

final badgeUnlocksProvider = StreamProvider.autoDispose<List<BadgeUnlock>>(
    (ref) => ref.watch(databaseProvider).watchBadgeUnlocks());

/// Unlocks newly earned badges (awarding a small XP bonus each) and returns
/// every badge with progress and unlock date.
final badgesProvider =
    FutureProvider.autoDispose<List<BadgeState>>((ref) async {
  final c = await ref.watch(badgeContextProvider.future);
  final unlocks = await ref.watch(badgeUnlocksProvider.future);
  final db = ref.read(databaseProvider);
  final now = ref.read(clockProvider)();
  final known = {for (final u in unlocks) u.badgeId: u.unlockedAt};
  final fresh =
      badges.where((b) => b.earned(c) && !known.containsKey(b.id)).toList();
  if (fresh.isNotEmpty) {
    await db.unlockBadges(fresh.map((b) => b.id), now);
    for (final b in fresh) {
      await db.addXp('', Xp.badge, 'badge:${b.id}', now);
      known[b.id] = now;
    }
  }
  return [for (final b in badges) BadgeState(b, b.progress(c), known[b.id])];
});

// ---------------- Service used by learning screens ----------------

class GameService {
  final Ref ref;
  GameService(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);
  DateTime get _now => ref.read(clockProvider)();

  /// Returns the XP earned.
  Future<int> lessonFinished(
      String lang, String module, double percent, bool passed) async {
    var xp = passed ? Xp.lessonPassed : Xp.lessonAttempt;
    if (percent >= 100) xp += Xp.perfectBonus;
    await _db.addXp(lang, xp, 'lesson:$module', _now);
    return xp;
  }

  Future<int> examFinished(String lang, String levelId, bool passed) async {
    final xp = passed ? Xp.examPassed : Xp.examAttempt;
    await _db.addXp(lang, xp, 'exam:$levelId', _now);
    return xp;
  }

  /// Awards the level bonus only the first time a level is completed.
  Future<int> levelCompleted(String lang, String levelId) async {
    final from = DateTime(2000);
    final to = DateTime(3000);
    if (await _db.countXpEvents('level:$levelId', from, to) > 0) return 0;
    await _db.addXp(lang, Xp.levelComplete, 'level:$levelId', _now);
    return Xp.levelComplete;
  }

  Future<void> reviewRated(String lang) =>
      _db.addXp(lang, Xp.reviewCard, 'review', _now);

  Future<void> placementDone(String lang) =>
      _db.addXp(lang, Xp.placement, 'placement', _now);

  bool get heartsEnabled => ref.read(profileProvider).heartsEnabled;

  Future<int> hearts() => _db.currentHearts(_now, max: maxHearts);

  Future<int> loseHeart() async {
    if (!heartsEnabled) return maxHearts;
    final h = await _db.loseHeart(_now, max: maxHearts);
    ref.read(heartsTickProvider.notifier).state++;
    return h;
  }

  Future<void> refillHearts() async {
    await _db.refillHearts(_now, max: maxHearts);
    ref.read(heartsTickProvider.notifier).state++;
  }
}

final gameServiceProvider = Provider<GameService>((ref) => GameService(ref));
