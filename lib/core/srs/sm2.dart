/// SM-2 spaced-repetition algorithm (pure Dart).
library;

import 'scheduler.dart';

export 'scheduler.dart';

class Sm2Scheduler implements Scheduler {
  static const double minEase = 1.3;

  @override
  String get name => 'SM-2';

  @override
  ReviewState review(ReviewState state, int quality, DateTime now) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError.value(quality, 'quality', 'must be 0..5');
    }

    final q = 5 - quality;
    final newEase =
        (state.easeFactor + 0.1 - q * (0.08 + q * 0.02)).clamp(minEase, 10.0);

    if (quality < 3) {
      return state.copyWith(
        repetitions: 0,
        interval: 1,
        lapses: state.lapses + 1,
        easeFactor: newEase,
        dueAt: now.add(const Duration(days: 1)),
        lastReviewedAt: now,
      );
    }

    final reps = state.repetitions + 1;
    final interval = switch (reps) {
      1 => 1,
      2 => 6,
      _ => (state.interval * state.easeFactor).round(),
    };

    return state.copyWith(
      repetitions: reps,
      interval: interval,
      easeFactor: newEase,
      dueAt: now.add(Duration(days: interval)),
      lastReviewedAt: now,
    );
  }
}
