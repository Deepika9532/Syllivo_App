import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/content/lesson_pack.dart';
import 'package:syllivo/core/db/app_database.dart';
import 'package:syllivo/core/srs/sm2.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 10, 9);

  const pack = LessonPack(
    id: 'de_test',
    lang: 'de',
    level: 'A1',
    title: 'Test',
    order: 1,
    version: 1,
    cards: [
      PackCard(id: 'c1', front: 'Hallo', back: 'Hello', audio: 'Hallo'),
      PackCard(id: 'c2', front: 'Danke', back: 'Thank you', audio: 'Danke'),
    ],
  );

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeded cards are new and queued', () async {
    await db.upsertPack(pack, now);
    final counts = await db.queueCounts('de', now);
    expect(counts.fresh, 2);
    expect(counts.due, 0);
    expect((await db.sessionQueue('de', now)).length, 2);
    expect((await db.sessionQueue('ko', now)), isEmpty);
  });

  test('a good review schedules the card for tomorrow', () async {
    await db.upsertPack(pack, now);
    final row = await db.getReviewRow('c1');
    final next = Sm2Scheduler().review(row.toSrs(), 4, now);
    await db.saveReview('c1', next, rating: 4, elapsedMs: 1200, now: now);

    expect((await db.sessionQueue('de', now)).map((c) => c.id), ['c2']);
    final tomorrow = now.add(const Duration(days: 1));
    expect((await db.queueCounts('de', tomorrow)).due, 1);

    final stats = await db.stats('de', now);
    expect(stats.reviewedToday, 1);
    expect(stats.learnedCards, 1);
    expect(stats.streak, 1);
  });

  test('re-seeding the same version keeps progress', () async {
    await db.upsertPack(pack, now);
    final row = await db.getReviewRow('c1');
    final next = Sm2Scheduler().review(row.toSrs(), 5, now);
    await db.saveReview('c1', next, rating: 5, elapsedMs: 800, now: now);

    await db.upsertPack(pack, now);
    expect((await db.getReviewRow('c1')).repetitions, 1);
  });

  test('streak increments on consecutive days', () async {
    await db.upsertPack(pack, now);
    for (var d = 0; d < 3; d++) {
      final t = now.add(Duration(days: d));
      await db.addPronunciationAttempt('c1', 'hallo', 100, t);
    }
    final stats = await db.stats('de', now.add(const Duration(days: 2)));
    expect(stats.streak, 3);
    expect(stats.avgPronunciation, 100);
  });
}
