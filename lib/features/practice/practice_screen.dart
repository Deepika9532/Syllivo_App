import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../gamification/game_providers.dart';
import '../curriculum/widgets/content_blocks.dart' show bookmarksProvider;
import '../gamification/game_widgets.dart';
import '../../core/widgets/speak.dart';

/// Practice tab: flashcard reviews, daily & weekly challenges, speaking
/// drills and quick tools. Everything here uses existing features.
class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final counts = ref.watch(queueCountsProvider(lang)).valueOrNull;
    final daily = ref.watch(dailyMissionsProvider);
    final weekly = ref.watch(weeklyChallengesProvider);
    final decks = ref.watch(lessonsProvider(lang)).valueOrNull ?? const [];
    final t = Theme.of(context).textTheme;

    Future<void> open(String path) async {
      await context.push(path);
      ref.invalidate(queueCountsProvider(lang));
      ref.invalidate(dailyMissionsProvider);
    }

    final dueTotal = (counts?.due ?? 0) + (counts?.fresh ?? 0);

    return Scaffold(
      appBar: AppBar(title: Text('Practice · ${languages[lang]!.name}')),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            // Flashcards
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [SyllivoColors.teal, Color(0xFF0EA5E9)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Flashcard review',
                            style: t.titleLarge?.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(
                          counts == null
                              ? '…'
                              : '${counts.due} due · ${counts.fresh} new · scheduled by FSRS',
                          style: t.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          key: const Key('practice-review'),
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: SyllivoColors.indigo),
                          onPressed: () => open('/review'),
                          icon: const Icon(Icons.style_rounded),
                          label: Text(
                              dueTotal == 0 ? 'Review anyway' : 'Start review'),
                        ),
                      ]),
                ),
                const Sylli(size: 84, mood: SylliMood.happy),
              ]),
            ),
            const SizedBox(height: 6),
            Text('Reviewing 5+ cards also refills your hearts.',
                style: t.bodySmall, textAlign: TextAlign.center),

            // Daily challenges
            const SectionHeader('Daily challenges'),
            Card(
              key: const Key('daily-challenges'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: daily.when(
                  loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: LinearProgressIndicator(value: 0)),
                  error: (e, _) => Text('$e'),
                  data: (list) => Column(children: [
                    for (final m in list) MissionTile(m),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                          'New challenges every day at midnight (your local time).',
                          style: t.bodySmall),
                    ),
                  ]),
                ),
              ),
            ),

            const SectionHeader('Weekly challenges'),
            Card(
              key: const Key('weekly-challenges'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: weekly.when(
                  loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: LinearProgressIndicator(value: 0)),
                  error: (e, _) => Text('$e'),
                  data: (list) =>
                      Column(children: [for (final m in list) MissionTile(m)]),
                ),
              ),
            ),

            const SectionHeader('Speaking drills'),
            if (decks.isEmpty)
              const Card(child: ListTile(title: Text('No word decks yet.')))
            else
              Card(
                child: Column(children: [
                  for (final d in decks.take(6))
                    ListTile(
                      key: Key('drill-${d.id}'),
                      leading: const Icon(Icons.record_voice_over_rounded,
                          color: SyllivoColors.coral),
                      title: Text(d.title),
                      subtitle: Text(d.level),
                      trailing: const Icon(Icons.mic_rounded),
                      onTap: () => open('/pronounce/${d.id}'),
                    ),
                ]),
              ),

            const SectionHeader('Saved words'),
            _SavedWords(lang: lang),
            const SectionHeader('More practice'),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.collections_bookmark_rounded,
                      color: SyllivoColors.indigo),
                  title: const Text('Browse word decks'),
                  subtitle:
                      const Text('Listen to every word with native voices'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => open('/lessons'),
                ),
                ListTile(
                  leading: const Icon(Icons.explore_rounded,
                      color: SyllivoColors.teal),
                  title: const Text('Placement test'),
                  subtitle: const Text('Find the right level for you'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => open('/learn/$lang/placement'),
                ),
              ]),
            ),
          ]),
    );
  }
}

final _savedWordsProvider = StreamProvider.autoDispose.family(
    (ref, String lang) => ref.watch(databaseProvider).watchBookmarks(lang));

class _SavedWords extends ConsumerWidget {
  final String lang;
  const _SavedWords({required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(_savedWordsProvider(lang)).valueOrNull;
    ref.watch(bookmarksProvider(lang));
    if (words == null) return const SizedBox(height: 60);
    if (words.isEmpty) {
      return const Card(
        key: Key('saved-words-empty'),
        child: ListTile(
          leading: Icon(Icons.bookmark_border_rounded),
          title: Text('No saved words yet'),
          subtitle:
              Text('Tap the bookmark on any word card in a vocabulary lesson.'),
        ),
      );
    }
    return Card(
      key: const Key('saved-words'),
      child: Column(children: [
        for (final w in words.take(20))
          ListTile(
            title:
                Text(w.target, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
                [w.en, if (w.example != null) w.example!].join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              SpeakButton(text: w.target, lang: lang),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.bookmark_remove_rounded),
                onPressed: () => ref.read(databaseProvider).toggleBookmark(
                    lang: lang,
                    target: w.target,
                    en: w.en,
                    now: ref.read(clockProvider)()),
              ),
            ]),
          ),
      ]),
    );
  }
}
