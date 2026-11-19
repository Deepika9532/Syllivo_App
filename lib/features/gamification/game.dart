/// Syllivo gamification rules: XP, daily missions, weekly challenges,
/// badges and hearts. Pure definitions + a service that reads/writes the
/// database. All values are derived from real stored activity.
library;

import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';

// ---------------- XP rules ----------------

abstract final class Xp {
  static const lessonPassed = 10;
  static const lessonAttempt = 3;
  static const perfectBonus = 5;
  static const examPassed = 50;
  static const examAttempt = 10;
  static const levelComplete = 100;
  static const reviewCard = 1;
  static const placement = 15;
  static const badge = 25;
}

DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);
DateTime weekStart(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - 1));
String _two(int n) => n.toString().padLeft(2, '0');
String dayKey(DateTime d) => 'D${d.year}-${_two(d.month)}-${_two(d.day)}';
String weekKey(DateTime d) {
  final w = weekStart(d);
  return 'W${w.year}-${_two(w.month)}-${_two(w.day)}';
}

// ---------------- Missions ----------------

enum MissionPeriod { daily, weekly }

class Mission {
  final String id;
  final String title;
  final IconData icon;
  final int target;
  final int xp;
  final MissionPeriod period;
  final Future<int> Function(AppDatabase db, DateTime from, DateTime to)
      measure;

  const Mission(this.id, this.title, this.icon, this.target, this.xp,
      this.period, this.measure);
}

class MissionStatus {
  final Mission mission;
  final int progress;
  final bool claimed;
  const MissionStatus(this.mission, this.progress, this.claimed);
  bool get done => progress >= mission.target;
  double get fraction => (progress / mission.target).clamp(0, 1).toDouble();
}

Future<int> _lessons(AppDatabase db, DateTime f, DateTime t) =>
    db.countXpEvents('lesson:%', f, t);

Mission dailyGoalMission(int goalXp) => Mission(
    'daily_goal',
    'Reach your daily goal of $goalXp XP',
    Icons.bolt_rounded,
    goalXp,
    10,
    MissionPeriod.daily,
    (db, f, t) => db.learningXpBetween(f, t));

final dailyMissionPool = <Mission>[
  Mission('new_words', 'Learn 10 new words', Icons.style_rounded, 10, 15,
      MissionPeriod.daily, (db, f, t) => db.newCardsBetween(f, t)),
  Mission('review_15', 'Review 15 flashcards', Icons.repeat_rounded, 15, 15,
      MissionPeriod.daily, (db, f, t) => db.reviewsBetween(f, t)),
  Mission(
      'grammar_lesson',
      'Complete a grammar lesson',
      Icons.account_tree_rounded,
      1,
      15,
      MissionPeriod.daily,
      (db, f, t) => db.countXpEvents('lesson:grammar', f, t)),
  Mission(
      'listening_5',
      'Answer 5 listening questions',
      Icons.headphones_rounded,
      5,
      10,
      MissionPeriod.daily,
      (db, f, t) => db.attemptsBetween(['listening'], f, t)),
  Mission(
      'pronounce_5',
      'Practise pronunciation 5 times',
      Icons.graphic_eq_rounded,
      5,
      15,
      MissionPeriod.daily,
      (db, f, t) => db.pronunciationPracticeBetween(f, t)),
  const Mission('two_lessons', 'Complete 2 lessons', Icons.menu_book_rounded, 2,
      20, MissionPeriod.daily, _lessons),
];

final weeklyChallenges = <Mission>[
  Mission('week_xp_250', 'Earn 250 XP this week', Icons.bolt_rounded, 250, 75,
      MissionPeriod.weekly, (db, f, t) => db.learningXpBetween(f, t)),
  Mission(
      'week_5_days',
      'Learn on 5 different days',
      Icons.calendar_month_rounded,
      5,
      60,
      MissionPeriod.weekly,
      (db, f, t) => db.activeDaysBetween(f, t)),
  const Mission('week_7_lessons', 'Complete 7 lessons', Icons.menu_book_rounded,
      7, 60, MissionPeriod.weekly, _lessons),
  Mission('week_75_reviews', 'Review 75 flashcards', Icons.repeat_rounded, 75,
      50, MissionPeriod.weekly, (db, f, t) => db.reviewsBetween(f, t)),
];

/// Today's missions: the daily goal plus three from the pool, chosen by
/// date so they are stable all day and vary day to day.
List<Mission> missionsFor(DateTime day, int goalXp) {
  final seed = day.year * 372 + day.month * 31 + day.day;
  final pool = [...dailyMissionPool];
  final picked = <Mission>[];
  var i = seed;
  while (picked.length < 3) {
    picked.add(pool.removeAt(i % pool.length));
    i = i * 7 + 3;
  }
  return [dailyGoalMission(goalXp), ...picked];
}

// ---------------- Badges ----------------

class BadgeContext {
  final int totalXp,
      lessons,
      learnedWords,
      bestStreak,
      missions,
      perfectVoice,
      levels,
      exams;
  const BadgeContext({
    required this.totalXp,
    required this.lessons,
    required this.learnedWords,
    required this.bestStreak,
    required this.missions,
    required this.perfectVoice,
    required this.levels,
    required this.exams,
  });
}

class BadgeDef {
  final String id, title, description;
  final IconData icon;
  final Color color;
  final int target;
  final int Function(BadgeContext c) value;
  const BadgeDef(this.id, this.title, this.description, this.icon, this.color,
      this.target, this.value);
  double progress(BadgeContext c) => (value(c) / target).clamp(0, 1).toDouble();
  bool earned(BadgeContext c) => value(c) >= target;
}

final badges = <BadgeDef>[
  BadgeDef('first_lesson', 'First Steps', 'Complete your first lesson',
      Icons.flag_rounded, const Color(0xFF4F46E5), 1, (c) => c.lessons),
  BadgeDef(
      'lessons_10',
      'Bookworm',
      'Complete 10 lessons',
      Icons.auto_stories_rounded,
      const Color(0xFF7C3AED),
      10,
      (c) => c.lessons),
  BadgeDef('lessons_50', 'Scholar', 'Complete 50 lessons', Icons.school_rounded,
      const Color(0xFF1D4ED8), 50, (c) => c.lessons),
  BadgeDef('xp_100', 'Spark', 'Earn 100 XP', Icons.bolt_rounded,
      const Color(0xFFF59E0B), 100, (c) => c.totalXp),
  BadgeDef(
      'xp_1000',
      'Powerhouse',
      'Earn 1,000 XP',
      Icons.electric_bolt_rounded,
      const Color(0xFFEA580C),
      1000,
      (c) => c.totalXp),
  BadgeDef('xp_5000', 'Supernova', 'Earn 5,000 XP', Icons.auto_awesome_rounded,
      const Color(0xFFDB2777), 5000, (c) => c.totalXp),
  BadgeDef(
      'streak_3',
      'Warming Up',
      'Reach a 3-day streak',
      Icons.local_fire_department_rounded,
      const Color(0xFFF97316),
      3,
      (c) => c.bestStreak),
  BadgeDef('streak_7', 'On Fire', 'Reach a 7-day streak',
      Icons.whatshot_rounded, const Color(0xFFEF4444), 7, (c) => c.bestStreak),
  BadgeDef(
      'streak_30',
      'Unstoppable',
      'Reach a 30-day streak',
      Icons.emoji_events_rounded,
      const Color(0xFFCA8A04),
      30,
      (c) => c.bestStreak),
  BadgeDef('words_25', 'Word Sprout', 'Master 25 words in reviews',
      Icons.spa_rounded, const Color(0xFF14B8A6), 25, (c) => c.learnedWords),
  BadgeDef('words_100', 'Word Garden', 'Master 100 words', Icons.park_rounded,
      const Color(0xFF0D9488), 100, (c) => c.learnedWords),
  BadgeDef('words_250', 'Word Forest', 'Master 250 words', Icons.forest_rounded,
      const Color(0xFF15803D), 250, (c) => c.learnedWords),
  BadgeDef('missions_10', 'Go-getter', 'Complete 10 missions',
      Icons.task_alt_rounded, const Color(0xFF2563EB), 10, (c) => c.missions),
  BadgeDef(
      'voice_10',
      'Clear Voice',
      'Score 90+ in pronunciation 10 times',
      Icons.record_voice_over_rounded,
      const Color(0xFFFB7185),
      10,
      (c) => c.perfectVoice),
  BadgeDef('exam_1', 'Test Ace', 'Pass a level examination',
      Icons.verified_rounded, const Color(0xFF16A34A), 1, (c) => c.exams),
  BadgeDef(
      'level_1',
      'Level Up',
      'Complete a whole level',
      Icons.workspace_premium_rounded,
      const Color(0xFF9333EA),
      1,
      (c) => c.levels),
];
