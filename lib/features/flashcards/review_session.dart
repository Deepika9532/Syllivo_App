import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/providers.dart';
import '../gamification/game_providers.dart';

class ReviewSessionState {
  final List<FlashCard> queue;
  final int index;
  final bool revealed;
  final int done;
  final int again;
  final DateTime shownAt;

  const ReviewSessionState({
    required this.queue,
    required this.index,
    required this.revealed,
    required this.done,
    required this.again,
    required this.shownAt,
  });

  FlashCard? get current => index < queue.length ? queue[index] : null;
  bool get finished => current == null;

  ReviewSessionState copyWith({
    List<FlashCard>? queue,
    int? index,
    bool? revealed,
    int? done,
    int? again,
    DateTime? shownAt,
  }) =>
      ReviewSessionState(
        queue: queue ?? this.queue,
        index: index ?? this.index,
        revealed: revealed ?? this.revealed,
        done: done ?? this.done,
        again: again ?? this.again,
        shownAt: shownAt ?? this.shownAt,
      );
}

class ReviewSessionController
    extends AutoDisposeFamilyAsyncNotifier<ReviewSessionState, String> {
  bool _busy = false;

  @override
  Future<ReviewSessionState> build(String lang) async {
    final now = ref.read(clockProvider)();
    final queue = await ref.watch(databaseProvider).sessionQueue(lang, now);
    return ReviewSessionState(
      queue: queue,
      index: 0,
      revealed: false,
      done: 0,
      again: 0,
      shownAt: now,
    );
  }

  void reveal() {
    final s = state.valueOrNull;
    if (s == null || s.finished) return;
    state = AsyncData(s.copyWith(revealed: true));
  }

  /// [quality]: 1 = again, 3 = hard, 4 = good, 5 = easy.
  Future<void> rate(int quality) async {
    final s = state.valueOrNull;
    if (_busy || s == null || s.finished || !s.revealed) return;
    _busy = true;
    try {
      final card = s.current!;
      final now = ref.read(clockProvider)();
      final db = ref.read(databaseProvider);
      final row = await db.getReviewRow(card.id);
      final next =
          ref.read(schedulerProvider).review(row.toSrs(), quality, now);
      await db.saveReview(
        card.id,
        next,
        rating: quality,
        elapsedMs: now.difference(s.shownAt).inMilliseconds,
        now: now,
      );

      final game = ref.read(gameServiceProvider);
      await game.reviewRated(arg);
      // Failed cards come back at the end of this session.
      final failed = quality < 3;
      state = AsyncData(s.copyWith(
        queue: failed ? [...s.queue, card] : s.queue,
        index: s.index + 1,
        revealed: false,
        done: s.done + 1,
        again: s.again + (failed ? 1 : 0),
        shownAt: ref.read(clockProvider)(),
      ));
      final after = state.valueOrNull;
      // A finished session of 5+ cards refills hearts.
      if (after != null && after.finished && after.done >= 5) {
        await game.refillHearts();
      }
    } finally {
      _busy = false;
    }
  }
}

final reviewSessionProvider = AsyncNotifierProvider.autoDispose
    .family<ReviewSessionController, ReviewSessionState, String>(
        ReviewSessionController.new);
