/// FSRS-4.5 (Free Spaced Repetition Scheduler), the algorithm used by Anki.
///
/// Models each card with:
///  - stability S: days until recall probability drops to 90%
///  - difficulty D: 1 (easy) .. 10 (hard)
///  - retrievability R: current recall probability, from S and elapsed time
///
/// Reference: https://github.com/open-spaced-repetition/fsrs4anki/wiki/The-Algorithm
library;

import 'dart:math';

import 'scheduler.dart';

export 'scheduler.dart';

class FsrsScheduler implements Scheduler {
  /// Default FSRS-4.5 parameters (trained on millions of Anki reviews).
  static const List<double> defaultWeights = [
    0.4872,
    1.4003,
    3.7145,
    13.8206,
    5.1618,
    1.2298,
    0.8975,
    0.031,
    1.6474,
    0.1367,
    1.0461,
    2.1072,
    0.0793,
    0.3246,
    1.587,
    0.2272,
    2.8755,
  ];

  static const double _decay = -0.5;
  static const double _factor = 19 / 81; // makes R(S, S) = 0.9

  final List<double> w;
  final double desiredRetention;
  final int maxIntervalDays;

  const FsrsScheduler({
    this.w = defaultWeights,
    this.desiredRetention = 0.9,
    this.maxIntervalDays = 36500,
  });

  @override
  String get name => 'FSRS';

  /// Maps the app's 0..5 quality to FSRS grades 1..4.
  static int gradeFor(int quality) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError.value(quality, 'quality', 'must be 0..5');
    }
    if (quality < 3) return 1; // again
    if (quality == 3) return 2; // hard
    if (quality == 4) return 3; // good
    return 4; // easy
  }

  double retrievability(double elapsedDays, double stability) =>
      pow(1 + _factor * elapsedDays / stability, _decay).toDouble();

  double _initStability(int g) => max(w[g - 1], 0.1);

  double _initDifficulty(int g) => (w[4] - (g - 3) * w[5]).clamp(1.0, 10.0);

  double _nextDifficulty(double d, int g) {
    final next = d - w[6] * (g - 3);
    final reverted = w[7] * _initDifficulty(4) + (1 - w[7]) * next;
    return reverted.clamp(1.0, 10.0);
  }

  double _recallStability(double d, double s, double r, int g) {
    final hardPenalty = g == 2 ? w[15] : 1.0;
    final easyBonus = g == 4 ? w[16] : 1.0;
    return s *
        (1 +
            exp(w[8]) *
                (11 - d) *
                pow(s, -w[9]) *
                (exp(w[10] * (1 - r)) - 1) *
                hardPenalty *
                easyBonus);
  }

  double _forgetStability(double d, double s, double r) {
    final next =
        w[11] * pow(d, -w[12]) * (pow(s + 1, w[13]) - 1) * exp(w[14] * (1 - r));
    return min(next, s);
  }

  int intervalFor(double stability) {
    final days = stability / _factor * (pow(desiredRetention, 1 / _decay) - 1);
    return days.round().clamp(1, maxIntervalDays);
  }

  @override
  ReviewState review(ReviewState state, int quality, DateTime now) {
    final g = gradeFor(quality);

    double s, d;
    if (state.stability <= 0 || state.lastReviewedAt == null) {
      s = _initStability(g);
      d = _initDifficulty(g);
    } else {
      final elapsed =
          max(0, now.difference(state.lastReviewedAt!).inMinutes) / 1440.0;
      final r = retrievability(elapsed, state.stability);
      d = _nextDifficulty(state.difficulty, g);
      s = g == 1
          ? _forgetStability(state.difficulty, state.stability, r)
          : _recallStability(state.difficulty, state.stability, r, g);
    }

    final failed = g == 1;
    final interval = failed ? 1 : intervalFor(s);

    return state.copyWith(
      stability: s,
      difficulty: d,
      interval: interval,
      repetitions: failed ? 0 : state.repetitions + 1,
      lapses: failed ? state.lapses + 1 : state.lapses,
      dueAt: now.add(Duration(days: interval)),
      lastReviewedAt: now,
    );
  }
}
