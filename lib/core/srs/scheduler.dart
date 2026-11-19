/// Shared review state and scheduler interface. SM-2 and FSRS both
/// implement [Scheduler], so the algorithm can be switched at runtime.
library;

class ReviewState {
  final double easeFactor; // SM-2
  final int interval; // days
  final int repetitions;
  final int lapses;
  final DateTime dueAt;
  final double stability; // FSRS (days); 0 = never reviewed
  final double difficulty; // FSRS (1..10)
  final DateTime? lastReviewedAt;

  const ReviewState({
    this.easeFactor = 2.5,
    this.interval = 0,
    this.repetitions = 0,
    this.lapses = 0,
    required this.dueAt,
    this.stability = 0,
    this.difficulty = 0,
    this.lastReviewedAt,
  });

  factory ReviewState.initial(DateTime now) => ReviewState(dueAt: now);

  ReviewState copyWith({
    double? easeFactor,
    int? interval,
    int? repetitions,
    int? lapses,
    DateTime? dueAt,
    double? stability,
    double? difficulty,
    DateTime? lastReviewedAt,
  }) =>
      ReviewState(
        easeFactor: easeFactor ?? this.easeFactor,
        interval: interval ?? this.interval,
        repetitions: repetitions ?? this.repetitions,
        lapses: lapses ?? this.lapses,
        dueAt: dueAt ?? this.dueAt,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      );
}

/// [quality] uses the app's 0..5 scale: below 3 = again, 3 = hard,
/// 4 = good, 5 = easy.
abstract interface class Scheduler {
  String get name;
  ReviewState review(ReviewState state, int quality, DateTime now);
}
