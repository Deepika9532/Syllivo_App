import 'dart:math';

import 'package:drift/drift.dart';

import '../content/lesson_pack.dart';
import '../srs/sm2.dart';

part 'app_database.g.dart';

const newCardsPerSession = 10;

@DataClassName('Lesson')
class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get langCode => text()(); // 'de' | 'ko'
  TextColumn get level => text()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FlashCard')
class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text().references(Lessons, #id)();
  IntColumn get position => integer()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get romanization => text().nullable()();
  TextColumn get audioText => text()();
  TextColumn get example => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReviewRow')
class ReviewStates extends Table {
  TextColumn get cardId => text().references(Cards, #id)();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime()();
  // Added in schema v2 for FSRS.
  RealColumn get stability => real().withDefault(const Constant(0))();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {cardId};
}

@DataClassName('ReviewLog')
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text().references(Cards, #id)();
  IntColumn get rating => integer()();
  DateTimeColumn get reviewedAt => dateTime()();
  IntColumn get elapsedMs => integer()();
}

@DataClassName('PronunciationAttempt')
class PronunciationAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text().references(Cards, #id)();
  TextColumn get recognized => text()();
  IntColumn get score => integer()();
  DateTimeColumn get at => dateTime()();
}

@DataClassName('ProgressRow')
class UserProgress extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  IntColumn get dailyGoal => integer().withDefault(const Constant(20))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------- Curriculum progress (schema v3) ----------

/// Per-lesson progress. `run*` fields hold the in-progress practice run so
/// a learner can resume exactly where they stopped.
@DataClassName('LessonProgressRow')
class LessonProgress extends Table {
  TextColumn get lessonId => text()();
  TextColumn get langCode => text()();
  TextColumn get levelId => text()();
  TextColumn get moduleType => text()();
  IntColumn get status => integer()
      .withDefault(const Constant(0))(); // 0 new, 1 started, 2 completed
  RealColumn get bestScore => real().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get runIndex => integer().withDefault(const Constant(0))();
  IntColumn get runCorrect => integer().withDefault(const Constant(0))();
  IntColumn get runAnswered => integer().withDefault(const Constant(0))();
  IntColumn get runSkipped => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {lessonId};
}

@DataClassName('ExerciseAttempt')
class ExerciseAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get langCode => text()();
  TextColumn get lessonId => text()();
  TextColumn get questionId => text()();
  TextColumn get questionType => text()();
  BoolColumn get correct => boolean()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  TextColumn get answer => text().withDefault(const Constant(''))();
  IntColumn get score => integer().nullable()(); // pronunciation score
  DateTimeColumn get at => dateTime()();
}

@DataClassName('ExamAttempt')
class ExamAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get langCode => text()();
  TextColumn get levelId => text()(); // placement: recommended level
  TextColumn get kind =>
      text().withDefault(const Constant('exam'))(); // exam | placement
  RealColumn get percent => real()();
  BoolColumn get passed => boolean()();
  IntColumn get threshold => integer()();
  TextColumn get detailJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime()();
}

@DataClassName('LanguageProgressRow')
class LanguageProgress extends Table {
  TextColumn get langCode => text()();
  TextColumn get startLevelId => text().nullable()();
  TextColumn get placementLevelId => text().nullable()();
  TextColumn get lastLessonId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {langCode};
}

@DataClassName('StudyTimeRow')
class StudyTime extends Table {
  TextColumn get langCode => text()();
  DateTimeColumn get day => dateTime()(); // local midnight
  IntColumn get ms => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {langCode, day};
}

// ---------- Gamification (schema v4) ----------

@DataClassName('XpEvent')
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get langCode =>
      text()(); // 'de' | 'ko' | '' (not language-specific)
  IntColumn get amount => integer()();
  TextColumn get reason =>
      text()(); // lesson:<module> | exam | review | level | mission:<id> …
  DateTimeColumn get at => dateTime()();
}

/// One row per completed daily mission / weekly challenge. The period key
/// (local date, or week start) keeps the full history.
@DataClassName('MissionClaim')
class MissionClaims extends Table {
  TextColumn get periodKey => text()();
  TextColumn get missionId => text()();
  IntColumn get xp => integer()();
  DateTimeColumn get claimedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {periodKey, missionId};
}

@DataClassName('BadgeUnlock')
class BadgeUnlocks extends Table {
  TextColumn get badgeId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {badgeId};
}

@DataClassName('GameStateRow')
class GameState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get hearts => integer().withDefault(const Constant(5))();
  DateTimeColumn get heartsUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------- Account & bookmarks (schema v5) ----------

/// The signed-in account linked to this device's learning data. Profile
/// fields only — no passwords or tokens are ever stored.
@DataClassName('AccountRow')
class AccountProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get uid => text()();
  TextColumn get provider => text()(); // google | password
  TextColumn get displayName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get accountCreatedAt => dateTime().nullable()();
  DateTimeColumn get linkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Bookmark')
class Bookmarks extends Table {
  TextColumn get langCode => text()();
  TextColumn get target => text()();
  TextColumn get en => text()();
  TextColumn get pron => text().nullable()();
  TextColumn get example => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {langCode, target};
}

extension ReviewRowSrs on ReviewRow {
  ReviewState toSrs() => ReviewState(
        easeFactor: easeFactor,
        interval: intervalDays,
        repetitions: repetitions,
        lapses: lapses,
        dueAt: dueAt,
        stability: stability,
        difficulty: difficulty,
        lastReviewedAt: lastReviewedAt,
      );
}

class ProgressStats {
  final int streak;
  final int dailyGoal;
  final int reviewedToday;
  final int totalCards;
  final int learnedCards;
  final double? avgPronunciation;
  final List<({DateTime day, int count})> last7Days;
  final Map<DateTime, int> activity; // last 18 weeks, keyed by local day
  final int totalReviews;
  final int perfectPronunciations; // attempts scoring 90+
  final int longestStreakDays;

  const ProgressStats({
    required this.streak,
    required this.dailyGoal,
    required this.reviewedToday,
    required this.totalCards,
    required this.learnedCards,
    required this.avgPronunciation,
    required this.last7Days,
    this.activity = const {},
    this.totalReviews = 0,
    this.perfectPronunciations = 0,
    this.longestStreakDays = 0,
  });
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

@DriftDatabase(tables: [
  Lessons,
  Cards,
  ReviewStates,
  ReviewLogs,
  PronunciationAttempts,
  UserProgress,
  LessonProgress,
  ExerciseAttempts,
  ExamAttempts,
  LanguageProgress,
  StudyTime,
  XpEvents,
  MissionClaims,
  BadgeUnlocks,
  GameState,
  AccountProfile,
  Bookmarks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_cards_lesson ON cards (lesson_id)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_review_due ON review_states (due_at)');
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(reviewStates, reviewStates.stability);
            await m.addColumn(reviewStates, reviewStates.difficulty);
            await m.addColumn(reviewStates, reviewStates.lastReviewedAt);
          }
          if (from < 3) {
            await m.createTable(lessonProgress);
            await m.createTable(exerciseAttempts);
            await m.createTable(examAttempts);
            await m.createTable(languageProgress);
            await m.createTable(studyTime);
          }
          if (from < 4) {
            await m.createTable(xpEvents);
            await m.createTable(missionClaims);
            await m.createTable(badgeUnlocks);
            await m.createTable(gameState);
          }
          if (from < 5) {
            await m.createTable(accountProfile);
            await m.createTable(bookmarks);
          }
        },
        beforeOpen: (_) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------- Content ----------

  /// Inserts or updates a lesson pack. Existing review progress is kept;
  /// a pack is only re-applied when its version is newer.
  Future<void> upsertPack(LessonPack pack, DateTime now) =>
      transaction(() async {
        final existing = await getLesson(pack.id);
        if (existing != null && existing.version >= pack.version) return;

        await into(lessons).insertOnConflictUpdate(LessonsCompanion.insert(
          id: pack.id,
          langCode: pack.lang,
          level: pack.level,
          title: pack.title,
          sortOrder: pack.order,
          version: Value(pack.version),
        ));

        for (var i = 0; i < pack.cards.length; i++) {
          final c = pack.cards[i];
          await into(cards).insertOnConflictUpdate(CardsCompanion.insert(
            id: c.id,
            lessonId: pack.id,
            position: i,
            front: c.front,
            back: c.back,
            audioText: c.audio,
            romanization: Value(c.romanization),
            example: Value(c.example),
          ));
          await into(reviewStates).insert(
            ReviewStatesCompanion.insert(cardId: c.id, dueAt: now),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });

  Stream<List<Lesson>> watchLessons(String lang) => (select(lessons)
        ..where((l) => l.langCode.equals(lang))
        ..orderBy([(l) => OrderingTerm.asc(l.sortOrder)]))
      .watch();

  Future<Lesson?> getLesson(String id) =>
      (select(lessons)..where((l) => l.id.equals(id))).getSingleOrNull();

  Stream<List<FlashCard>> watchLessonCards(String lessonId) => (select(cards)
        ..where((c) => c.lessonId.equals(lessonId))
        ..orderBy([(c) => OrderingTerm.asc(c.position)]))
      .watch();

  // ---------- Review queue ----------

  Future<List<FlashCard>> _queue(String lang, DateTime now,
      {required bool fresh, required int limit}) {
    final seen = reviewStates.repetitions.isBiggerThanValue(0) |
        reviewStates.lapses.isBiggerThanValue(0);
    final unseen =
        reviewStates.repetitions.equals(0) & reviewStates.lapses.equals(0);

    final q = select(cards).join([
      innerJoin(reviewStates, reviewStates.cardId.equalsExp(cards.id)),
      innerJoin(lessons, lessons.id.equalsExp(cards.lessonId)),
    ])
      ..where(lessons.langCode.equals(lang) &
          (fresh
              ? unseen
              : (seen & reviewStates.dueAt.isSmallerOrEqualValue(now))))
      ..orderBy(fresh
          ? [
              OrderingTerm.asc(lessons.sortOrder),
              OrderingTerm.asc(cards.position)
            ]
          : [OrderingTerm.asc(reviewStates.dueAt)])
      ..limit(limit);
    return q.map((r) => r.readTable(cards)).get();
  }

  /// Due reviews first, then up to [newLimit] unseen cards.
  Future<List<FlashCard>> sessionQueue(String lang, DateTime now,
      {int newLimit = newCardsPerSession, int reviewLimit = 200}) async {
    final due = await _queue(lang, now, fresh: false, limit: reviewLimit);
    final fresh = await _queue(lang, now, fresh: true, limit: newLimit);
    return [...due, ...fresh];
  }

  Future<({int due, int fresh})> queueCounts(String lang, DateTime now) async {
    const base = 'SELECT COUNT(*) AS cnt FROM review_states r '
        'JOIN cards c ON c.id = r.card_id '
        'JOIN lessons s ON s.id = c.lesson_id WHERE s.lang_code = ? ';
    final due = await _count(
      '$base AND (r.repetitions > 0 OR r.lapses > 0) AND r.due_at <= ?',
      [Variable.withString(lang), Variable.withDateTime(now)],
    );
    final fresh = await _count(
      '$base AND r.repetitions = 0 AND r.lapses = 0',
      [Variable.withString(lang)],
    );
    return (due: due, fresh: min(fresh, newCardsPerSession));
  }

  Future<ReviewRow> getReviewRow(String cardId) =>
      (select(reviewStates)..where((r) => r.cardId.equals(cardId))).getSingle();

  Future<void> saveReview(
    String cardId,
    ReviewState next, {
    required int rating,
    required int elapsedMs,
    required DateTime now,
  }) =>
      transaction(() async {
        await (update(reviewStates)..where((r) => r.cardId.equals(cardId)))
            .write(ReviewStatesCompanion(
          easeFactor: Value(next.easeFactor),
          intervalDays: Value(next.interval),
          repetitions: Value(next.repetitions),
          lapses: Value(next.lapses),
          dueAt: Value(next.dueAt),
          stability: Value(next.stability),
          difficulty: Value(next.difficulty),
          lastReviewedAt: Value(next.lastReviewedAt),
        ));
        await into(reviewLogs).insert(ReviewLogsCompanion.insert(
          cardId: cardId,
          rating: rating,
          reviewedAt: now,
          elapsedMs: elapsedMs,
        ));
        await _touchStreak(now);
      });

  // ---------- Pronunciation ----------

  Future<void> addPronunciationAttempt(
          String cardId, String recognized, int score, DateTime now) =>
      transaction(() async {
        await into(pronunciationAttempts).insert(
            PronunciationAttemptsCompanion.insert(
                cardId: cardId, recognized: recognized, score: score, at: now));
        await _touchStreak(now);
      });

  // ---------- Progress ----------

  Future<ProgressRow> getProgress() async {
    final q = select(userProgress)..where((p) => p.id.equals(1));
    final row = await q.getSingleOrNull();
    if (row != null) return row;
    await into(userProgress).insert(UserProgressCompanion.insert());
    return q.getSingle();
  }

  Future<void> setDailyGoal(int goal) async {
    await getProgress();
    await (update(userProgress)..where((p) => p.id.equals(1)))
        .write(UserProgressCompanion(dailyGoal: Value(goal)));
  }

  Future<void> _touchStreak(DateTime now) async {
    final p = await getProgress();
    final today = _day(now);
    int streak;
    if (p.lastActiveDate == null) {
      streak = 1;
    } else {
      final diff = today.difference(_day(p.lastActiveDate!)).inDays;
      streak = diff == 0 ? max(p.streak, 1) : (diff == 1 ? p.streak + 1 : 1);
    }
    await (update(userProgress)..where((r) => r.id.equals(1))).write(
        UserProgressCompanion(
            streak: Value(streak), lastActiveDate: Value(now)));
  }

  Future<ProgressStats> stats(String lang, DateTime now) async {
    final p = await getProgress();
    final today = _day(now);

    // A streak only counts if the user was active today or yesterday.
    var streak = p.streak;
    if (p.lastActiveDate == null ||
        today.difference(_day(p.lastActiveDate!)).inDays > 1) {
      streak = 0;
    }

    const logsBase = 'SELECT COUNT(*) AS cnt FROM review_logs l '
        'JOIN cards c ON c.id = l.card_id '
        'JOIN lessons s ON s.id = c.lesson_id '
        'WHERE s.lang_code = ? AND l.reviewed_at >= ? AND l.reviewed_at < ?';

    Future<int> reviewsOn(DateTime day) => _count(logsBase, [
          Variable.withString(lang),
          Variable.withDateTime(day),
          Variable.withDateTime(day.add(const Duration(days: 1))),
        ]);

    final week = <({DateTime day, int count})>[];
    for (var i = 6; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      week.add((day: d, count: await reviewsOn(d)));
    }

    const cardsBase = 'SELECT COUNT(*) AS cnt FROM review_states r '
        'JOIN cards c ON c.id = r.card_id '
        'JOIN lessons s ON s.id = c.lesson_id WHERE s.lang_code = ?';
    final total = await _count(cardsBase, [Variable.withString(lang)]);
    final learned = await _count(
        '$cardsBase AND r.repetitions > 0', [Variable.withString(lang)]);

    final avgRow = await customSelect(
      'SELECT AVG(p.score) AS a FROM pronunciation_attempts p '
      'JOIN cards c ON c.id = p.card_id '
      'JOIN lessons s ON s.id = c.lesson_id WHERE s.lang_code = ?',
      variables: [Variable.withString(lang)],
    ).getSingle();

    // Activity heatmap: reviews + pronunciation attempts per local day.
    final since = today.subtract(const Duration(days: 7 * 18));
    final rows = await customSelect(
      "SELECT d, SUM(n) AS n FROM ("
      " SELECT date(l.reviewed_at, 'unixepoch', 'localtime') AS d, COUNT(*) AS n"
      " FROM review_logs l JOIN cards c ON c.id = l.card_id"
      " JOIN lessons s ON s.id = c.lesson_id"
      " WHERE s.lang_code = ?1 AND l.reviewed_at >= ?2 GROUP BY d"
      " UNION ALL"
      " SELECT date(p.at, 'unixepoch', 'localtime') AS d, COUNT(*) AS n"
      " FROM pronunciation_attempts p JOIN cards c ON c.id = p.card_id"
      " JOIN lessons s ON s.id = c.lesson_id"
      " WHERE s.lang_code = ?1 AND p.at >= ?2 GROUP BY d"
      " UNION ALL"
      " SELECT date(e.at, 'unixepoch', 'localtime') AS d, COUNT(*) AS n"
      " FROM exercise_attempts e WHERE e.lang_code = ?1 AND e.at >= ?2 GROUP BY d"
      ") GROUP BY d",
      variables: [Variable.withString(lang), Variable.withDateTime(since)],
    ).get();
    final activity = <DateTime, int>{
      for (final r in rows)
        DateTime.parse(r.read<String>('d')): r.read<int>('n'),
    };

    // Longest run of consecutive active days in the window.
    var longest = 0, run = 0;
    for (var d = since;
        !d.isAfter(today);
        d = DateTime(d.year, d.month, d.day + 1)) {
      run = (activity[d] ?? 0) > 0 ? run + 1 : 0;
      longest = max(longest, run);
    }

    final totalReviews = await _count(
      'SELECT COUNT(*) AS cnt FROM review_logs l JOIN cards c ON c.id = l.card_id '
      'JOIN lessons s ON s.id = c.lesson_id WHERE s.lang_code = ?',
      [Variable.withString(lang)],
    );
    final perfect = await _count(
      'SELECT COUNT(*) AS cnt FROM pronunciation_attempts p JOIN cards c ON c.id = p.card_id '
      'JOIN lessons s ON s.id = c.lesson_id WHERE s.lang_code = ? AND p.score >= 90',
      [Variable.withString(lang)],
    );

    return ProgressStats(
      activity: activity,
      totalReviews: totalReviews,
      perfectPronunciations: perfect,
      longestStreakDays: max(longest, streak),
      streak: streak,
      dailyGoal: p.dailyGoal,
      reviewedToday: week.last.count,
      totalCards: total,
      learnedCards: learned,
      avgPronunciation: avgRow.readNullable<double>('a'),
      last7Days: week,
    );
  }

  // ---------- Curriculum progress ----------

  Stream<List<LessonProgressRow>> watchLessonProgress(String lang) =>
      (select(lessonProgress)..where((p) => p.langCode.equals(lang))).watch();

  Future<LessonProgressRow?> getLessonProgress(String lessonId) =>
      (select(lessonProgress)..where((p) => p.lessonId.equals(lessonId)))
          .getSingleOrNull();

  Future<void> _ensureLesson(String lessonId, String lang, String levelId,
      String moduleType, DateTime now) async {
    await into(lessonProgress).insert(
      LessonProgressCompanion.insert(
        lessonId: lessonId,
        langCode: lang,
        levelId: levelId,
        moduleType: moduleType,
        updatedAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Records one answered question and advances the resumable run.
  Future<void> recordAnswer({
    required String lang,
    required String levelId,
    required String moduleType,
    required String lessonId,
    required String questionId,
    required String questionType,
    required bool correct,
    required bool skipped,
    required String answer,
    int? score,
    required int nextIndex,
    required DateTime now,
  }) =>
      transaction(() async {
        await _ensureLesson(lessonId, lang, levelId, moduleType, now);
        await into(exerciseAttempts).insert(ExerciseAttemptsCompanion.insert(
          langCode: lang,
          lessonId: lessonId,
          questionId: questionId,
          questionType: questionType,
          correct: correct,
          skipped: Value(skipped),
          answer: Value(answer),
          score: Value(score),
          at: now,
        ));
        final p = (await getLessonProgress(lessonId))!;
        await (update(lessonProgress)
              ..where((r) => r.lessonId.equals(lessonId)))
            .write(LessonProgressCompanion(
          status: Value(p.status == 2 ? 2 : 1),
          runIndex: Value(nextIndex),
          runCorrect: Value(p.runCorrect + (correct && !skipped ? 1 : 0)),
          runAnswered: Value(p.runAnswered + (skipped ? 0 : 1)),
          runSkipped: Value(p.runSkipped + (skipped ? 1 : 0)),
          updatedAt: Value(now),
        ));
        await _setLastLesson(lang, lessonId, now);
        await _touchStreak(now);
      });

  /// Ends a practice run. Returns the stored row.
  Future<LessonProgressRow> finishLessonRun({
    required String lang,
    required String levelId,
    required String moduleType,
    required String lessonId,
    required double percent,
    required bool passed,
    required DateTime now,
  }) =>
      transaction(() async {
        await _ensureLesson(lessonId, lang, levelId, moduleType, now);
        final p = (await getLessonProgress(lessonId))!;
        final completed = p.status == 2 || passed;
        await (update(lessonProgress)
              ..where((r) => r.lessonId.equals(lessonId)))
            .write(LessonProgressCompanion(
          status: Value(completed ? 2 : 1),
          bestScore: Value(max(p.bestScore, percent)),
          attempts: Value(p.attempts + 1),
          runIndex: const Value(0),
          runCorrect: const Value(0),
          runAnswered: const Value(0),
          runSkipped: const Value(0),
          updatedAt: Value(now),
          completedAt: Value(p.completedAt ?? (passed ? now : null)),
        ));
        return (await getLessonProgress(lessonId))!;
      });

  Future<void> resetLessonRun(String lessonId, DateTime now) async {
    await (update(lessonProgress)..where((r) => r.lessonId.equals(lessonId)))
        .write(LessonProgressCompanion(
      runIndex: const Value(0),
      runCorrect: const Value(0),
      runAnswered: const Value(0),
      runSkipped: const Value(0),
      updatedAt: Value(now),
    ));
  }

  Future<void> markLessonOpened(String lang, String levelId, String moduleType,
          String lessonId, DateTime now) =>
      transaction(() async {
        await _ensureLesson(lessonId, lang, levelId, moduleType, now);
        await _setLastLesson(lang, lessonId, now);
      });

  Future<void> _ensureLanguage(String lang, DateTime now) =>
      into(languageProgress).insert(
        LanguageProgressCompanion.insert(langCode: lang, updatedAt: now),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> _setLastLesson(
      String lang, String lessonId, DateTime now) async {
    await _ensureLanguage(lang, now);
    await (update(languageProgress)..where((r) => r.langCode.equals(lang)))
        .write(LanguageProgressCompanion(
            lastLessonId: Value(lessonId), updatedAt: Value(now)));
  }

  Stream<LanguageProgressRow?> watchLanguageProgress(String lang) =>
      (select(languageProgress)..where((r) => r.langCode.equals(lang)))
          .watchSingleOrNull();

  Future<void> setStartLevel(String lang, String levelId, DateTime now,
      {bool fromPlacement = false}) async {
    await _ensureLanguage(lang, now);
    await (update(languageProgress)..where((r) => r.langCode.equals(lang)))
        .write(LanguageProgressCompanion(
      startLevelId: Value(levelId),
      placementLevelId: fromPlacement ? Value(levelId) : const Value.absent(),
      updatedAt: Value(now),
    ));
  }

  Future<int> saveExamAttempt({
    required String lang,
    required String levelId,
    required String kind,
    required double percent,
    required bool passed,
    required int threshold,
    required String detailJson,
    required DateTime startedAt,
    required DateTime finishedAt,
  }) async {
    final id = await into(examAttempts).insert(ExamAttemptsCompanion.insert(
      langCode: lang,
      levelId: levelId,
      kind: Value(kind),
      percent: percent,
      passed: passed,
      threshold: threshold,
      detailJson: Value(detailJson),
      startedAt: startedAt,
      finishedAt: finishedAt,
    ));
    await _touchStreak(finishedAt);
    return id;
  }

  Stream<List<ExamAttempt>> watchExamAttempts(String lang) =>
      (select(examAttempts)
            ..where((e) => e.langCode.equals(lang))
            ..orderBy([(e) => OrderingTerm.desc(e.finishedAt)]))
          .watch();

  Future<void> addStudyTime(String lang, int ms, DateTime now) async {
    if (ms <= 0) return;
    final day = _day(now);
    await customStatement(
      'INSERT INTO study_time (lang_code, day, ms) VALUES (?, ?, ?) '
      'ON CONFLICT(lang_code, day) DO UPDATE SET ms = ms + excluded.ms',
      [lang, day.millisecondsSinceEpoch ~/ 1000, ms],
    );
    notifyUpdates({TableUpdate.onTable(studyTime)});
  }

  Future<int> studyMsOn(String lang, DateTime day) async {
    final row = await (select(studyTime)
          ..where((t) => t.langCode.equals(lang) & t.day.equals(_day(day))))
        .getSingleOrNull();
    return row?.ms ?? 0;
  }

  Future<int> totalStudyMs(String lang) async {
    final r = await customSelect(
      'SELECT COALESCE(SUM(ms), 0) AS cnt FROM study_time WHERE lang_code = ?',
      variables: [Variable.withString(lang)],
    ).getSingle();
    return r.read<int>('cnt');
  }

  /// Average pronunciation score from curriculum speaking practice.
  Future<double?> avgSpeechScore(String lang) async {
    final r = await customSelect(
      'SELECT AVG(score) AS a FROM exercise_attempts '
      'WHERE lang_code = ? AND score IS NOT NULL',
      variables: [Variable.withString(lang)],
    ).getSingle();
    return r.readNullable<double>('a');
  }

  // ---------- Gamification ----------

  Future<void> addXp(
      String lang, int amount, String reason, DateTime now) async {
    if (amount <= 0) return;
    await into(xpEvents).insert(XpEventsCompanion.insert(
        langCode: lang, amount: amount, reason: reason, at: now));
  }

  Stream<int> watchTotalXp() => customSelect(
        'SELECT COALESCE(SUM(amount), 0) AS cnt FROM xp_events',
        readsFrom: {xpEvents},
      ).watchSingle().map((r) => r.read<int>('cnt'));

  Future<int> xpBetween(DateTime from, DateTime to, {String? lang}) => _count(
        'SELECT COALESCE(SUM(amount), 0) AS cnt FROM xp_events '
        'WHERE at >= ? AND at < ?${lang == null ? '' : ' AND lang_code = ?'}',
        [
          Variable.withDateTime(from),
          Variable.withDateTime(to),
          if (lang != null) Variable.withString(lang),
        ],
      );

  /// XP from learning itself (excludes mission / badge rewards), so goals
  /// can't be met by claiming rewards.
  Future<int> learningXpBetween(DateTime from, DateTime to) => _count(
        "SELECT COALESCE(SUM(amount), 0) AS cnt FROM xp_events WHERE at >= ? AND at < ? "
        "AND reason NOT LIKE 'mission:%' AND reason NOT LIKE 'badge:%'",
        [Variable.withDateTime(from), Variable.withDateTime(to)],
      );

  Future<int> countXpEvents(String reasonLike, DateTime from, DateTime to) =>
      _count(
        'SELECT COUNT(*) AS cnt FROM xp_events WHERE reason LIKE ? AND at >= ? AND at < ?',
        [
          Variable.withString(reasonLike),
          Variable.withDateTime(from),
          Variable.withDateTime(to)
        ],
      );

  Future<int> reviewsBetween(DateTime from, DateTime to) => _count(
        'SELECT COUNT(*) AS cnt FROM review_logs WHERE reviewed_at >= ? AND reviewed_at < ?',
        [Variable.withDateTime(from), Variable.withDateTime(to)],
      );

  /// Cards whose very first review happened in the window ("new words").
  Future<int> newCardsBetween(DateTime from, DateTime to) => _count(
        'SELECT COUNT(*) AS cnt FROM (SELECT card_id, MIN(reviewed_at) AS first '
        'FROM review_logs GROUP BY card_id) WHERE first >= ? AND first < ?',
        [Variable.withDateTime(from), Variable.withDateTime(to)],
      );

  Future<int> attemptsBetween(List<String> types, DateTime from, DateTime to) {
    final marks = List.filled(types.length, '?').join(', ');
    return _count(
      'SELECT COUNT(*) AS cnt FROM exercise_attempts WHERE skipped = 0 AND '
      'question_type IN ($marks) AND at >= ? AND at < ?',
      [
        for (final t in types) Variable.withString(t),
        Variable.withDateTime(from),
        Variable.withDateTime(to)
      ],
    );
  }

  Future<int> pronunciationPracticeBetween(DateTime from, DateTime to) async =>
      await attemptsBetween(['speak', 'pronounce'], from, to) +
      await _count(
        'SELECT COUNT(*) AS cnt FROM pronunciation_attempts WHERE at >= ? AND at < ?',
        [Variable.withDateTime(from), Variable.withDateTime(to)],
      );

  /// Distinct local days with any learning activity in the window.
  Future<int> activeDaysBetween(DateTime from, DateTime to) => _count(
        "SELECT COUNT(DISTINCT d) AS cnt FROM ("
        " SELECT date(reviewed_at, 'unixepoch', 'localtime') AS d FROM review_logs WHERE reviewed_at >= ?1 AND reviewed_at < ?2"
        " UNION SELECT date(at, 'unixepoch', 'localtime') FROM exercise_attempts WHERE at >= ?1 AND at < ?2"
        " UNION SELECT date(at, 'unixepoch', 'localtime') FROM xp_events WHERE at >= ?1 AND at < ?2)",
        [Variable.withDateTime(from), Variable.withDateTime(to)],
      );

  /// XP per local day for the last [days] days, oldest first.
  Future<List<({DateTime day, int xp})>> xpByDay(DateTime now, int days) async {
    final today = _day(now);
    final out = <({DateTime day, int xp})>[];
    for (var i = days - 1; i >= 0; i--) {
      final d = DateTime(today.year, today.month, today.day - i);
      out.add((
        day: d,
        xp: await xpBetween(d, DateTime(d.year, d.month, d.day + 1))
      ));
    }
    return out;
  }

  /// Inserts the claim and its XP once; returns false if already claimed.
  Future<bool> claimMission(String periodKey, String missionId, int xp,
          String lang, DateTime now) =>
      transaction(() async {
        final existing = await (select(missionClaims)
              ..where((c) =>
                  c.periodKey.equals(periodKey) &
                  c.missionId.equals(missionId)))
            .getSingleOrNull();
        if (existing != null) return false;
        await into(missionClaims).insert(MissionClaimsCompanion.insert(
            periodKey: periodKey,
            missionId: missionId,
            xp: xp,
            claimedAt: now));
        await addXp(lang, xp, 'mission:$missionId', now);
        return true;
      });

  Future<Set<String>> claimedMissions(String periodKey) async =>
      (await (select(missionClaims)
                ..where((c) => c.periodKey.equals(periodKey)))
              .get())
          .map((c) => c.missionId)
          .toSet();

  Future<int> totalMissionsCompleted() =>
      _count('SELECT COUNT(*) AS cnt FROM mission_claims', []);

  Future<void> unlockBadges(Iterable<String> ids, DateTime now) async {
    for (final id in ids) {
      await into(badgeUnlocks).insert(
          BadgeUnlocksCompanion.insert(badgeId: id, unlockedAt: now),
          mode: InsertMode.insertOrIgnore);
    }
  }

  Stream<List<BadgeUnlock>> watchBadgeUnlocks() =>
      (select(badgeUnlocks)..orderBy([(b) => OrderingTerm.desc(b.unlockedAt)]))
          .watch();

  Future<int> totalLessonsCompleted() => _count(
      'SELECT COUNT(*) AS cnt FROM lesson_progress WHERE status = 2', []);

  Future<int> totalLearnedCards() => _count(
      'SELECT COUNT(*) AS cnt FROM review_states WHERE repetitions > 0', []);

  Future<int> totalPerfectPronunciations() async =>
      await _count(
          'SELECT COUNT(*) AS cnt FROM pronunciation_attempts WHERE score >= 90',
          []) +
      await _count(
          'SELECT COUNT(*) AS cnt FROM exercise_attempts WHERE score >= 90',
          []);

  Future<int> totalStudyMsAll() =>
      _count('SELECT COALESCE(SUM(ms), 0) AS cnt FROM study_time', []);

  // ---------- Hearts ----------

  /// Current hearts after regenerating one per [regen] since the last change.
  Future<int> currentHearts(DateTime now,
      {int max = 5, Duration regen = const Duration(minutes: 30)}) async {
    final row = await (select(gameState)..where((g) => g.id.equals(1)))
        .getSingleOrNull();
    if (row == null) return max;
    var hearts = row.hearts;
    var since = row.heartsUpdatedAt ?? now;
    if (hearts < max && now.isAfter(since)) {
      final gained = now.difference(since).inMinutes ~/ regen.inMinutes;
      if (gained > 0) {
        hearts = (hearts + gained).clamp(0, max);
        since = since.add(regen * gained);
        await _setHearts(hearts, hearts >= max ? now : since);
      }
    }
    return hearts;
  }

  Future<void> _setHearts(int hearts, DateTime at) =>
      into(gameState).insertOnConflictUpdate(GameStateCompanion.insert(
          id: const Value(1),
          hearts: Value(hearts),
          heartsUpdatedAt: Value(at)));

  Future<int> loseHeart(DateTime now, {int max = 5}) async {
    final h = await currentHearts(now, max: max);
    final next = (h - 1).clamp(0, max);
    await _setHearts(next, now);
    return next;
  }

  Future<void> refillHearts(DateTime now, {int max = 5}) =>
      _setHearts(max, now);

  // ---------- Account ----------

  Stream<AccountRow?> watchAccount() =>
      (select(accountProfile)..where((a) => a.id.equals(1)))
          .watchSingleOrNull();

  Future<AccountRow?> getAccount() =>
      (select(accountProfile)..where((a) => a.id.equals(1))).getSingleOrNull();

  /// Links this device's (guest) learning data to an account. Existing XP,
  /// streaks, lessons and history are untouched.
  Future<void> linkAccount({
    required String uid,
    required String provider,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    required DateTime now,
  }) async {
    final existing = await getAccount();
    await into(accountProfile)
        .insertOnConflictUpdate(AccountProfileCompanion.insert(
      id: const Value(1),
      uid: uid,
      provider: provider,
      displayName: Value(name),
      email: Value(email),
      photoUrl: Value(photoUrl),
      accountCreatedAt: Value(createdAt),
      linkedAt: existing?.uid == uid ? existing!.linkedAt : now,
    ));
  }

  Future<void> unlinkAccount() => delete(accountProfile).go();

  /// Erases all learning progress on this device (used only when the user
  /// explicitly asks for it while deleting their account). Lesson content
  /// stays; review states are reset to new.
  Future<void> eraseLearningData(DateTime now) => transaction(() async {
        for (final TableInfo t in [
          reviewLogs,
          pronunciationAttempts,
          lessonProgress,
          exerciseAttempts,
          examAttempts,
          languageProgress,
          studyTime,
          xpEvents,
          missionClaims,
          badgeUnlocks,
          gameState,
          userProgress,
          bookmarks,
          accountProfile,
        ]) {
          await delete(t).go();
        }
        await update(reviewStates).write(ReviewStatesCompanion(
          easeFactor: const Value(2.5),
          intervalDays: const Value(0),
          repetitions: const Value(0),
          lapses: const Value(0),
          dueAt: Value(now),
          stability: const Value(0),
          difficulty: const Value(0),
          lastReviewedAt: const Value(null),
        ));
      });

  // ---------- Bookmarks ----------

  Stream<List<Bookmark>> watchBookmarks(String lang) => (select(bookmarks)
        ..where((b) => b.langCode.equals(lang))
        ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
      .watch();

  /// Adds or removes a saved word; returns true if it is now bookmarked.
  Future<bool> toggleBookmark({
    required String lang,
    required String target,
    required String en,
    String? pron,
    String? example,
    required DateTime now,
  }) async {
    final where = select(bookmarks)
      ..where((b) => b.langCode.equals(lang) & b.target.equals(target));
    if (await where.getSingleOrNull() != null) {
      await (delete(bookmarks)
            ..where((b) => b.langCode.equals(lang) & b.target.equals(target)))
          .go();
      return false;
    }
    await into(bookmarks).insert(BookmarksCompanion.insert(
      langCode: lang,
      target: target,
      en: en,
      pron: Value(pron),
      example: Value(example),
      createdAt: now,
    ));
    return true;
  }

  Future<int> _count(String sql, List<Variable> vars) async {
    final row = await customSelect(sql, variables: vars).getSingle();
    return row.read<int>('cnt');
  }
}
