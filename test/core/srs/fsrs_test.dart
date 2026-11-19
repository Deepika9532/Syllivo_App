import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/srs/fsrs.dart';

void main() {
  const fsrs = FsrsScheduler();
  final t0 = DateTime(2026, 11, 10, 9);

  ReviewState reviewAt(ReviewState s, int q, int dayOffset) =>
      fsrs.review(s, q, t0.add(Duration(days: dayOffset)));

  test('quality maps to FSRS grades', () {
    expect(FsrsScheduler.gradeFor(0), 1);
    expect(FsrsScheduler.gradeFor(1), 1);
    expect(FsrsScheduler.gradeFor(3), 2);
    expect(FsrsScheduler.gradeFor(4), 3);
    expect(FsrsScheduler.gradeFor(5), 4);
    expect(() => FsrsScheduler.gradeFor(6), throwsArgumentError);
  });

  test('first review uses initial stability per grade', () {
    final good = reviewAt(ReviewState.initial(t0), 4, 0);
    expect(good.stability, closeTo(FsrsScheduler.defaultWeights[2], 1e-9));
    expect(good.interval, 4); // S≈3.7 days at 90% retention
    expect(good.repetitions, 1);
    expect(good.lastReviewedAt, t0);
  });

  test('easier first answers give longer intervals', () {
    final start = ReviewState.initial(t0);
    final hard = reviewAt(start, 3, 0).interval;
    final good = reviewAt(start, 4, 0).interval;
    final easy = reviewAt(start, 5, 0).interval;
    expect(hard, lessThan(good));
    expect(good, lessThan(easy));
  });

  test('successful reviews grow stability', () {
    var s = reviewAt(ReviewState.initial(t0), 4, 0);
    final s1 = s.stability;
    s = reviewAt(s, 4, s.interval);
    expect(s.stability, greaterThan(s1));
    final s2 = s.stability;
    s = reviewAt(s, 4, s.interval + s.interval);
    expect(s.stability, greaterThan(s2));
  });

  test('forgetting lowers stability, counts a lapse, schedules tomorrow', () {
    var s = reviewAt(ReviewState.initial(t0), 4, 0);
    s = reviewAt(s, 4, s.interval);
    final before = s.stability;
    s = reviewAt(s, 1, s.interval);
    expect(s.stability, lessThan(before));
    expect(s.lapses, 1);
    expect(s.repetitions, 0);
    expect(s.interval, 1);
  });

  test('difficulty stays within 1..10', () {
    var s = ReviewState.initial(t0);
    for (var i = 0; i < 30; i++) {
      s = reviewAt(s, 1, i);
      expect(s.difficulty, inInclusiveRange(1, 10));
    }
    for (var i = 30; i < 60; i++) {
      s = reviewAt(s, 5, i);
      expect(s.difficulty, inInclusiveRange(1, 10));
    }
  });

  test('retrievability is 0.9 after exactly S days', () {
    expect(fsrs.retrievability(10, 10), closeTo(0.9, 1e-9));
    expect(fsrs.retrievability(0, 10), 1.0);
  });
}
