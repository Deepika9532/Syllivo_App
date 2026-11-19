import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/core/srs/sm2.dart';

void main() {
  final now = DateTime(2026, 11, 10);
  final scheduler = Sm2Scheduler();

  test('first correct review schedules 1 day', () {
    final s = scheduler.review(ReviewState.initial(now), 4, now);
    expect(s.repetitions, 1);
    expect(s.interval, 1);
    expect(s.dueAt, now.add(const Duration(days: 1)));
  });

  test('second correct review schedules 6 days', () {
    var s = scheduler.review(ReviewState.initial(now), 4, now);
    s = scheduler.review(s, 4, now);
    expect(s.interval, 6);
  });

  test('third review multiplies interval by ease factor', () {
    var s = ReviewState.initial(now);
    for (var i = 0; i < 3; i++) {
      s = scheduler.review(s, 5, now);
    }
    expect(s.interval, greaterThan(6));
  });

  test('failed review resets repetitions and counts a lapse', () {
    var s = scheduler.review(ReviewState.initial(now), 5, now);
    s = scheduler.review(s, 5, now);
    s = scheduler.review(s, 1, now);
    expect(s.repetitions, 0);
    expect(s.interval, 1);
    expect(s.lapses, 1);
  });

  test('ease factor never drops below 1.3', () {
    var s = ReviewState.initial(now);
    for (var i = 0; i < 20; i++) {
      s = scheduler.review(s, 0, now);
    }
    expect(s.easeFactor, Sm2Scheduler.minEase);
  });

  test('perfect rating raises ease factor', () {
    final s = scheduler.review(ReviewState.initial(now), 5, now);
    expect(s.easeFactor, closeTo(2.6, 1e-9));
  });

  test('rejects out-of-range quality', () {
    expect(() => scheduler.review(ReviewState.initial(now), 6, now),
        throwsArgumentError);
  });
}
