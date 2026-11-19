import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/skeleton.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../auth/account_widgets.dart';
import '../curriculum/curriculum_providers.dart';
import '../curriculum/models.dart';
import '../gamification/game_providers.dart';
import '../gamification/game_widgets.dart';
import 'language_picker.dart';

String greeting(DateTime now) => now.hour < 12
    ? 'Good morning'
    : now.hour < 18
        ? 'Good afternoon'
        : 'Good evening';

/// Home: Continue Learning first, then today's goal, languages, the day's
/// plan, challenges and the weekly summary.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final lang = ref.watch(languageProvider);
    final now = ref.watch(clockProvider)();
    final t = Theme.of(context).textTheme;

    Future<void> open(String path) async {
      await context.push(path);
      ref.invalidate(queueCountsProvider(lang));
      ref.invalidate(learnStateProvider(lang));
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dailyMissionsProvider);
            ref.invalidate(learnStateProvider(lang));
            ref.invalidate(queueCountsProvider(lang));
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(children: [
                Semantics(
                  button: true,
                  label: 'Open profile',
                  child: Pressable(
                    onTap: () =>
                        StatefulNavigationShell.maybeOf(context)?.goBranch(4),
                    child: const AccountAvatar(size: 46),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting(now),
                            style: t.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                        Text(
                            profile.name.isEmpty
                                ? 'Welcome back!'
                                : '${profile.name}!',
                            key: const Key('welcome'),
                            style: t.titleLarge,
                            overflow: TextOverflow.ellipsis),
                      ]),
                ),
                _LanguageChip(lang: lang),
              ]),
              const SizedBox(height: 20),
              _ContinueCard(lang: lang, onOpen: open),
              const SizedBox(height: 16),
              const _StatsRow(),
              const SizedBox(height: 8),
              const SectionHeader('Your languages'),
              _LanguageRows(active: lang),
              _TodayActivities(lang: lang, onOpen: open),
              SectionHeader('Daily challenges',
                  action: 'See all',
                  onAction: () =>
                      StatefulNavigationShell.maybeOf(context)?.goBranch(2)),
              const _MissionsCard(),
              SectionHeader('This week',
                  action: 'Progress',
                  onAction: () =>
                      StatefulNavigationShell.maybeOf(context)?.goBranch(3)),
              const _WeeklySummary(),
              const SectionHeader('Review vocabulary'),
              _ReviewCard(lang: lang, onOpen: open),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String lang;
  const _LanguageChip({required this.lang});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Change language, currently ${languages[lang]!.name}',
        child: Pressable(
          key: const Key('language-chip'),
          onTap: () => showLanguagePicker(context),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(languages[lang]!.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(languages[lang]!.name,
                  style: Theme.of(context).textTheme.labelLarge),
              const Icon(Icons.expand_more_rounded, size: 20),
            ]),
          ),
        ),
      );
}

class _ContinueCard extends ConsumerWidget {
  final String lang;
  final Future<void> Function(String) onOpen;
  const _ContinueCard({required this.lang, required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learnStateProvider(lang)).valueOrNull;
    if (state == null) return const Skeleton(height: 250, radius: 28);
    final t = Theme.of(context).textTheme;
    const white = Colors.white;
    final next = state.nextLesson;
    final module =
        next == null ? null : state.curriculum.moduleOfLesson(next.id);
    final level = next == null
        ? state.currentLevel
        : state.curriculum.levelOfLesson(next.id)!;
    final started =
        next != null && (state.lessonProgress(next.id)?.status ?? 0) == 1;

    return Container(
      key: Key('course-$lang'),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SyllivoColors.indigo, Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: SyllivoColors.indigo.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 10))
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(started ? 'PICK UP WHERE YOU LEFT OFF' : 'CONTINUE LEARNING',
                  style: t.labelMedium?.copyWith(
                      color: white.withValues(alpha: 0.8), letterSpacing: 1.2)),
              const SizedBox(height: 6),
              Text(next?.title ?? '${level.code} examination',
                  key: const Key('continue-title'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.headlineSmall?.copyWith(color: white)),
              const SizedBox(height: 6),
              Text(
                '${languages[lang]!.name} · ${level.code} ${level.title}${module == null ? '' : ' · ${module.type.label}'}',
                key: const Key('home-level'),
                style:
                    t.bodyMedium?.copyWith(color: white.withValues(alpha: 0.9)),
              ),
            ]),
          ),
          const Sylli(size: 72, mood: SylliMood.happy, animate: false),
        ]),
        const SizedBox(height: 18),
        AnimatedBar(value: state.progressOf(level), color: white, height: 10),
        const SizedBox(height: 6),
        Text(
            '${(state.progressOf(level) * 100).round()}% of ${level.code} · '
            '${(state.overall * 100).round()}% of the course',
            key: Key('progress-$lang'),
            style: t.bodySmall?.copyWith(color: white)),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const Key('continue-learning-home'),
            style: FilledButton.styleFrom(
              backgroundColor: white,
              foregroundColor: SyllivoColors.indigo,
              minimumSize: const Size.fromHeight(56),
            ),
            onPressed: () => onOpen(next == null
                ? '/learn/$lang/exam/${level.id}'
                : '/learn/$lang/lesson/${next.id}'),
            icon: Icon(
                started ? Icons.play_circle_rounded : Icons.play_arrow_rounded),
            label: Text(started
                ? 'Resume lesson'
                : next == null
                    ? 'Take the exam'
                    : 'Continue learning'),
          ),
        ),
      ]),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider).valueOrNull ?? 0;
    final xp = ref.watch(totalXpProvider).valueOrNull ?? 0;
    final today = ref.watch(todayXpProvider).valueOrNull ?? 0;
    final goal = ref.watch(profileProvider.select((p) => p.dailyGoalXp));
    final heartsOn = ref.watch(profileProvider.select((p) => p.heartsEnabled));
    final hearts = ref.watch(heartsProvider).valueOrNull ?? maxHearts;
    final t = Theme.of(context).textTheme;
    final done = today >= goal;

    Widget tile(
            {required Widget lead,
            required String value,
            required String label,
            Key? key,
            Key? valueKey}) =>
        Expanded(
          child: Card(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(children: [
                lead,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(value,
                              key: valueKey,
                              style: t.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ),
                        Text(label,
                            style: t.labelSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ]),
                ),
              ]),
            ),
          ),
        );

    return Row(children: [
      tile(
        key: const Key('goal-tile'),
        lead: ProgressRing(
          value: today / goal,
          size: 36,
          color: done ? SyllivoColors.success : SyllivoColors.amber,
          center: const Icon(Icons.bolt_rounded,
              size: 16, color: SyllivoColors.amber),
        ),
        value: '$today/$goal',
        valueKey: const Key('today-xp'),
        label: done ? 'Goal met' : 'Daily goal',
      ),
      const SizedBox(width: 10),
      tile(
        key: const Key('streak-pill'),
        lead: const Icon(Icons.local_fire_department_rounded,
            color: Color(0xFFF97316), size: 30),
        value: '$streak',
        label: streak == 1 ? 'day streak' : 'day streak',
      ),
      const SizedBox(width: 10),
      tile(
        key: const Key('xp-pill'),
        lead: heartsOn
            ? const Icon(Icons.favorite_rounded,
                color: SyllivoColors.coral, size: 28)
            : const Icon(Icons.stars_rounded,
                color: SyllivoColors.amber, size: 28),
        value: heartsOn ? '$hearts' : '$xp',
        label: heartsOn ? 'hearts · $xp XP' : 'total XP',
      ),
    ]);
  }
}

class _LanguageRows extends ConsumerWidget {
  final String active;
  const _LanguageRows({required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        for (final l in languages.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: KeyedSubtree(
              key: Key('switch-${l.code}'),
              child: LanguageCard(
                lang: l.code,
                selected: l.code == active,
                // Make it active and open its learning path (Learn tab).
                onTap: () {
                  ref.read(languageProvider.notifier).select(l.code);
                  StatefulNavigationShell.maybeOf(context)?.goBranch(1);
                },
              ),
            ),
          ),
      ]);
}

class _TodayActivities extends ConsumerWidget {
  final String lang;
  final Future<void> Function(String) onOpen;
  const _TodayActivities({required this.lang, required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(learnStateProvider(lang)).valueOrNull;
    if (s == null) return const SizedBox.shrink();
    final level = s.currentLevel;
    final nextId = s.nextLesson?.id;
    final todo = level.modules
        .expand((m) => m.lessons.map((l) => (m, l)))
        .where(
            (e) => !s.completedLessons.contains(e.$2.id) && e.$2.id != nextId)
        .take(3)
        .toList();
    if (todo.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader('Today’s activities'),
      Card(
        child: Column(children: [
          for (final (CurriculumModule m, Lesson l) in todo)
            ListTile(
              key: Key('today-${l.id}'),
              minVerticalPadding: 12,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(m.type.icon,
                    color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(m.type.label),
              subtitle:
                  Text(l.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => onOpen('/learn/$lang/lesson/${l.id}'),
            ),
        ]),
      ),
    ]);
  }
}

class _MissionsCard extends ConsumerWidget {
  const _MissionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(dailyMissionsProvider).valueOrNull;
    if (missions == null) return const Skeleton(height: 180);
    final done = missions.where((m) => m.done).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$done of ${missions.length} completed today',
              style: Theme.of(context).textTheme.labelLarge),
          for (final m in missions.take(3)) MissionTile(m),
        ]),
      ),
    );
  }
}

class _WeeklySummary extends ConsumerWidget {
  const _WeeklySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(weeklyXpProvider).valueOrNull;
    if (week == null) return const Skeleton(height: 120);
    final t = Theme.of(context).textTheme;
    final total = week.fold<int>(0, (a, d) => a + d.xp);
    final active = week.where((d) => d.xp > 0).length;
    final maxXp = week.fold<int>(1, (a, d) => d.xp > a ? d.xp : a);
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Card(
      key: const Key('weekly-summary'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$total XP', style: t.headlineSmall),
            Text('$active of 7 days active', style: t.bodySmall),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 64,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for (var i = 0; i < week.length; i++)
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 4 + 40 * week[i].xp / maxXp,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: SyllivoColors.indigo.withValues(
                                  alpha: week[i].xp == 0
                                      ? 0.15
                                      : (i == week.length - 1 ? 1 : 0.5)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(labels[week[i].day.weekday - 1],
                              style: t.labelSmall),
                        ]),
                  ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  final String lang;
  final Future<void> Function(String) onOpen;
  const _ReviewCard({required this.lang, required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(queueCountsProvider(lang)).valueOrNull;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.style_rounded, color: cs.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Flashcards', style: t.titleMedium),
              Text(
                  counts == null
                      ? 'Loading…'
                      : '${counts.due} due · ${counts.fresh} new words',
                  key: const Key('review-counts'),
                  style: t.bodyMedium),
            ]),
          ),
          FilledButton.tonal(
            key: const Key('review-now'),
            onPressed: () => onOpen('/review'),
            child: const Text('Review'),
          ),
        ]),
      ),
    );
  }
}
