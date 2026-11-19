import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// Builds a database exactly as schema v1 shipped (before FSRS columns),
/// then opens it with the current code and checks data survives.
void main() {
  test(
      'v1 → v3 adds FSRS columns + curriculum tables and keeps review progress',
      () async {
    final raw = sqlite3.openInMemory();
    raw.execute('''
      CREATE TABLE lessons (id TEXT NOT NULL PRIMARY KEY, lang_code TEXT NOT NULL,
        level TEXT NOT NULL, title TEXT NOT NULL, sort_order INTEGER NOT NULL,
        version INTEGER NOT NULL DEFAULT 1);
      CREATE TABLE cards (id TEXT NOT NULL PRIMARY KEY, lesson_id TEXT NOT NULL REFERENCES lessons (id),
        position INTEGER NOT NULL, front TEXT NOT NULL, back TEXT NOT NULL, romanization TEXT,
        audio_text TEXT NOT NULL, example TEXT);
      CREATE TABLE review_states (card_id TEXT NOT NULL PRIMARY KEY REFERENCES cards (id),
        ease_factor REAL NOT NULL DEFAULT 2.5, interval_days INTEGER NOT NULL DEFAULT 0,
        repetitions INTEGER NOT NULL DEFAULT 0, lapses INTEGER NOT NULL DEFAULT 0,
        due_at INTEGER NOT NULL);
      CREATE TABLE review_logs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        card_id TEXT NOT NULL REFERENCES cards (id), rating INTEGER NOT NULL,
        reviewed_at INTEGER NOT NULL, elapsed_ms INTEGER NOT NULL);
      CREATE TABLE pronunciation_attempts (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        card_id TEXT NOT NULL REFERENCES cards (id), recognized TEXT NOT NULL,
        score INTEGER NOT NULL, at INTEGER NOT NULL);
      CREATE TABLE user_progress (id INTEGER NOT NULL DEFAULT 1 PRIMARY KEY,
        streak INTEGER NOT NULL DEFAULT 0, last_active_date INTEGER,
        daily_goal INTEGER NOT NULL DEFAULT 20);
      INSERT INTO lessons VALUES ('l1', 'de', 'A1', 'Old', 1, 1);
      INSERT INTO cards VALUES ('c1', 'l1', 0, 'Hallo', 'Hello', NULL, 'Hallo', NULL);
      INSERT INTO review_states VALUES ('c1', 2.6, 6, 2, 0, 1800000000);
      PRAGMA user_version = 1;
    ''');

    final db = AppDatabase(NativeDatabase.opened(raw));
    final row = await db.getReviewRow('c1');

    expect(row.repetitions, 2);
    expect(row.intervalDays, 6);
    expect(row.easeFactor, 2.6);
    expect(row.stability, 0); // new column, default
    expect(row.lastReviewedAt, isNull);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 5);
    // v4 gamification tables exist and start empty.
    expect(await db.watchTotalXp().first, 0);
    expect(await db.currentHearts(DateTime(2026)), 5);
    // v3 curriculum tables were created along the way.
    expect(await db.getLessonProgress('anything'), isNull);
    expect(await db.studyMsOn('de', DateTime(2026)), 0);
    await db.close();
  });
}
