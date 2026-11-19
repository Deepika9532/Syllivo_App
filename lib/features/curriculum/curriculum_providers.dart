import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart' hide Lesson;
import '../../core/providers.dart';
import 'curriculum_repository.dart';
import 'grading.dart';
import 'models.dart';

final curriculumRepositoryProvider =
    Provider<CurriculumRepository>((ref) => CurriculumRepository(rootBundle));

final curriculumProvider = FutureProvider.family<Curriculum, String>(
    (ref, lang) => ref.watch(curriculumRepositoryProvider).load(lang));

/// Passing threshold for lessons and exams (default 80%), set in Settings.
class PassThresholdNotifier extends Notifier<int> {
  @override
  int build() =>
      ref.watch(sharedPrefsProvider).getInt('passPercent') ??
      defaultPassPercent;

  void set(int percent) {
    ref.read(sharedPrefsProvider).setInt('passPercent', percent);
    state = percent;
  }
}

final passThresholdProvider =
    NotifierProvider<PassThresholdNotifier, int>(PassThresholdNotifier.new);

/// Korean romanization is a crutch for early levels; learners can hide it.
class RomanizationNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(sharedPrefsProvider).getBool('romanization') ?? true;

  void set(bool on) {
    ref.read(sharedPrefsProvider).setBool('romanization', on);
    state = on;
  }
}

final romanizationProvider =
    NotifierProvider<RomanizationNotifier, bool>(RomanizationNotifier.new);

final lessonProgressProvider = StreamProvider.autoDispose
    .family<Map<String, LessonProgressRow>, String>((ref, lang) => ref
        .watch(databaseProvider)
        .watchLessonProgress(lang)
        .map((rows) => {for (final r in rows) r.lessonId: r}));

final languageProgressProvider = StreamProvider.autoDispose
    .family<LanguageProgressRow?, String>(
        (ref, lang) => ref.watch(databaseProvider).watchLanguageProgress(lang));

final examAttemptsProvider = StreamProvider.autoDispose
    .family<List<ExamAttempt>, String>(
        (ref, lang) => ref.watch(databaseProvider).watchExamAttempts(lang));

/// Everything the curriculum UI needs, derived from content + stored progress.
class LearnState {
  final Curriculum curriculum;
  final Map<String, LessonProgressRow> progress;
  final LanguageProgressRow? language;
  final List<ExamAttempt> exams;
  final int threshold;

  LearnState({
    required this.curriculum,
    required this.progress,
    required this.language,
    required this.exams,
    required this.threshold,
  });

  List<Level> get levels => curriculum.levels;

  late final Set<String> completedLessons = {
    for (final p in progress.values)
      if (p.status == 2) p.lessonId,
  };

  late final Set<String> passedExams = {
    for (final e in exams)
      if (e.kind == 'exam' && e.passed) e.levelId,
  };

  late final Set<String> unlocked = unlockedLevels(levels,
      startLevelId: language?.startLevelId, passedExams: passedExams);

  bool isUnlocked(Level l) => unlocked.contains(l.id);
  bool isCompleted(Level l) => levelCompleted(l, completedLessons, passedExams);
  double progressOf(Level l) => levelProgress(l, completedLessons, passedExams);
  LessonProgressRow? lessonProgress(String id) => progress[id];

  ExamAttempt? bestExam(String levelId) {
    ExamAttempt? best;
    for (final e in exams) {
      if (e.kind == 'exam' && e.levelId == levelId) {
        if (best == null || e.percent > best.percent) best = e;
      }
    }
    return best;
  }

  /// Highest unlocked level that is not yet complete.
  Level get currentLevel {
    Level? current;
    for (final l in levels) {
      if (isUnlocked(l) && !isCompleted(l)) current = l;
    }
    if (current != null) return current;
    final open = levels.where(isUnlocked).toList();
    return open.isEmpty ? levels.first : open.last;
  }

  int get completedCount => curriculum.levels
      .expand((l) => l.lessons)
      .where((l) => completedLessons.contains(l.id))
      .length;

  double get overall {
    final units = curriculum.totalLessons + levels.length;
    final done = completedCount + passedExams.length;
    return units == 0 ? 0 : done / units;
  }

  /// Resume the last opened lesson if unfinished, else the next lesson in
  /// the current level.
  Lesson? get nextLesson {
    final last = language?.lastLessonId;
    if (last != null && !completedLessons.contains(last)) {
      final level = curriculum.levelOfLesson(last);
      if (level != null && isUnlocked(level)) return curriculum.lesson(last);
    }
    // Prefer the current level (a placement can skip earlier levels).
    final current = currentLevel;
    for (final l in [
      current,
      ...curriculum.levels.where((l) => l != current && isUnlocked(l))
    ]) {
      for (final lesson in l.lessons) {
        if (!completedLessons.contains(lesson.id)) return lesson;
      }
    }
    return null;
  }
}

final learnStateProvider =
    FutureProvider.autoDispose.family<LearnState, String>((ref, lang) async {
  final curriculum = await ref.watch(curriculumProvider(lang).future);
  final progress = await ref.watch(lessonProgressProvider(lang).future);
  final language = await ref.watch(languageProgressProvider(lang).future);
  final exams = await ref.watch(examAttemptsProvider(lang).future);
  return LearnState(
    curriculum: curriculum,
    progress: progress,
    language: language,
    exams: exams,
    threshold: ref.watch(passThresholdProvider),
  );
});

/// Extra numbers for the dashboard that are not part of [LearnState].
class DashboardStats {
  final ProgressStats cards;
  final int todayMs;
  final int totalMs;
  final double? avgSpeech;
  const DashboardStats(this.cards, this.todayMs, this.totalMs, this.avgSpeech);
}

final dashboardStatsProvider = FutureProvider.autoDispose
    .family<DashboardStats, String>((ref, lang) async {
  final db = ref.watch(databaseProvider);
  final now = ref.read(clockProvider)();
  // Refresh whenever curriculum progress changes.
  await ref.watch(lessonProgressProvider(lang).future);
  return DashboardStats(
    await db.stats(lang, now),
    await db.studyMsOn(lang, now),
    await db.totalStudyMs(lang),
    await db.avgSpeechScore(lang),
  );
});
