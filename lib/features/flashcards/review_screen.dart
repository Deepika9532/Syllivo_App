import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/message_view.dart';
import 'review_session.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final session = ref.watch(reviewSessionProvider(lang));
    final ctrl = ref.read(reviewSessionProvider(lang).notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Review · ${languages[lang]!.name}')),
      body: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load session: $e')),
        data: (s) {
          if (s.queue.isEmpty) {
            return const MessageView(
              icon: Icons.celebration,
              title: 'All caught up!',
              body:
                  'No cards are due right now. Come back later or open a lesson.',
            );
          }
          if (s.finished) {
            return MessageView(
              icon: Icons.check_circle,
              title: 'Session complete',
              body: 'You reviewed ${s.done} cards (${s.again} marked “Again”).',
              action: FilledButton(
                  onPressed: () => context.pop(), child: const Text('Done')),
            );
          }

          final card = s.current!;
          return Column(children: [
            LinearProgressIndicator(value: s.index / s.queue.length),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: s.revealed ? null : ctrl.reveal,
                  child: _CardFace(
                    card: card,
                    revealed: s.revealed,
                    onSpeak: () =>
                        ref.read(ttsProvider).speak(card.audioText, lang),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: s.revealed
                  ? _RatingBar(onRate: ctrl.rate)
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                          onPressed: ctrl.reveal,
                          child: const Text('Show answer')),
                    ),
            ),
          ]);
        },
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final FlashCard card;
  final bool revealed;
  final VoidCallback onSpeak;

  const _CardFace(
      {required this.card, required this.revealed, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(card.front,
                  style: t.displaySmall, textAlign: TextAlign.center),
              if (card.romanization != null) ...[
                const SizedBox(height: 8),
                Text(card.romanization!, style: t.titleMedium),
              ],
              IconButton(
                  icon: const Icon(Icons.volume_up),
                  iconSize: 32,
                  onPressed: onSpeak),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: revealed
                    ? Column(key: const ValueKey('back'), children: [
                        const Divider(height: 32),
                        Text(card.back,
                            style: t.headlineSmall,
                            textAlign: TextAlign.center),
                        if (card.example != null) ...[
                          const SizedBox(height: 12),
                          Text(card.example!,
                              style: t.bodyLarge
                                  ?.copyWith(fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center),
                        ],
                      ])
                    : Padding(
                        key: const ValueKey('hint'),
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Tap to reveal', style: t.bodyMedium),
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final Future<void> Function(int) onRate;
  const _RatingBar({required this.onRate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget btn(String label, int q, Color bg, Color fg) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: bg, foregroundColor: fg),
                onPressed: () => onRate(q),
                child: Text(label),
              ),
            ),
          ),
        );
    return Row(children: [
      btn('Again', 1, cs.errorContainer, cs.onErrorContainer),
      btn('Hard', 3, cs.tertiaryContainer, cs.onTertiaryContainer),
      btn('Good', 4, cs.primaryContainer, cs.onPrimaryContainer),
      btn('Easy', 5, cs.primary, cs.onPrimary),
    ]);
  }
}
