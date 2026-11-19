import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../curriculum/curriculum_providers.dart';
import '../curriculum/models.dart';
import '../curriculum/screens/dashboard_screen.dart' show formatMinutes;
import '../gamification/game_providers.dart';
import '../gamification/game_widgets.dart';

/// Totals across both languages, all read from the local database.
class StatsTotals {
  final int studyMs, lessons, words;
  const StatsTotals(this.studyMs, this.lessons, this.words);
}

final statsTotalsProvider =
    FutureProvider.autoDispose<StatsTotals>((ref) async {
  await ref.watch(totalXpProvider.future);
  final db = ref.watch(databaseProvider);
  return StatsTotals(await db.totalStudyMsAll(),
      await db.totalLessonsCompleted(), await db.totalLearnedCards());
});

/// Progress tab: totals, weekly activity, per-language and per-skill
/// performance, exams, and achievement history.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final xp = ref.watch(totalXpProvider).valueOrNull ?? 0;
    final streak = ref.watch(streakProvider).valueOrNull ?? 0;
    final totals = ref.watch(statsTotalsProvider).valueOrNull;
    final week = ref.watch(weeklyXpProvider).valueOrNull;
    final de = ref.watch(learnStateProvider('de')).valueOrNull;
    final ko = ref.watch(learnStateProvider('ko')).valueOrNull;
    final badges = ref.watch(badgesProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                _Tile(Icons.bolt_rounded, '$xp', 'Total XP',
                    const Color(0xFFD97706),
                    key: const Key('stat-xp')),
                _Tile(Icons.local_fire_department_rounded, '$streak',
                    'Day streak', const Color(0xFFF97316)),
                _Tile(
                    Icons.timer_rounded,
                    totals == null ? '…' : formatMinutes(totals.studyMs),
                    'Learning time',
                    SyllivoColors.teal),
                _Tile(Icons.menu_book_rounded, '${totals?.lessons ?? '…'}',
                    'Lessons done', SyllivoColors.indigo,
                    key: const Key('stat-lessons')),
                _Tile(Icons.style_rounded, '${totals?.words ?? '…'}',
                    'Words learned', const Color(0xFF7C3AED)),
                _Tile(
                    Icons.verified_rounded,
                    '${(de?.passedExams.length ?? 0) + (ko?.passedExams.length ?? 0)}',
                    'Exams passed',
                    SyllivoColors.success),
              ],
            ),
            const SectionHeader('This week'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: week == null
                    ? const SizedBox(height: 150)
                    : _WeekBars(week),
              ),
            ),
            const SectionHeader('Languages'),
            for (final (lang, s) in [('de', de), ('ko', ko)])
              if (s != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    key: Key('lang-progress-$lang'),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(SyllivoRadii.card),
                      onTap: () => context.push('/learn/$lang/dashboard'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: Text(
                                      '${languages[lang]!.name} · ${s.currentLevel.code}',
                                      style: t.titleMedium),
                                ),
                                Text('${(s.overall * 100).round()}%',
                                    style: t.titleMedium),
                                const Icon(Icons.chevron_right_rounded),
                              ]),
                              const SizedBox(height: 8),
                              AnimatedBar(
                                  value: s.overall,
                                  color: SyllivoColors.forLang(lang).first),
                              const SizedBox(height: 6),
                              Text(
                                  '${s.completedCount}/${s.curriculum.totalLessons} lessons · '
                                  '${s.passedExams.length}/${s.levels.length} exams passed',
                                  style: t.bodySmall),
                            ]),
                      ),
                    ),
                  ),
                ),
            const SectionHeader('Skill performance'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                        width: 96,
                        child: Text('German',
                            textAlign: TextAlign.center, style: t.labelMedium)),
                    SizedBox(
                        width: 96,
                        child: Text('Korean',
                            textAlign: TextAlign.center, style: t.labelMedium)),
                  ]),
                  for (final type in ModuleType.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(children: [
                        Icon(type.icon, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(type.label)),
                        _SkillCell(
                            state: de,
                            type: type,
                            color: SyllivoColors.german.first),
                        _SkillCell(
                            state: ko,
                            type: type,
                            color: SyllivoColors.korean.first),
                      ]),
                    ),
                  const SizedBox(height: 6),
                  Text(
                      'Average best score in each skill’s lessons. “–” means not practised yet.',
                      style: t.bodySmall),
                ]),
              ),
            ),
            const SectionHeader('Examinations'),
            Card(
              child: Builder(builder: (context) {
                final exams = [
                  ...?de?.exams.where((e) => e.kind == 'exam').map((e) =>
                      ('German', de.curriculum.level(e.levelId)?.code, e)),
                  ...?ko?.exams.where((e) => e.kind == 'exam').map((e) =>
                      ('Korean', ko.curriculum.level(e.levelId)?.code, e)),
                ]..sort((a, b) => b.$3.finishedAt.compareTo(a.$3.finishedAt));
                if (exams.isEmpty) {
                  return const ListTile(
                      title: Text('No examinations taken yet.'));
                }
                return Column(children: [
                  for (final (name, code, e) in exams.take(8))
                    ListTile(
                      leading: Icon(
                          e.passed
                              ? Icons.verified_rounded
                              : Icons.cancel_rounded,
                          color: e.passed
                              ? SyllivoColors.success
                              : SyllivoColors.error),
                      title: Text('$name ${code ?? ''} examination'),
                      subtitle: Text(MaterialLocalizations.of(context)
                          .formatMediumDate(e.finishedAt)),
                      trailing:
                          Text('${e.percent.round()}%', style: t.titleMedium),
                    ),
                ]);
              }),
            ),
            SectionHeader('Achievements',
                action: 'Activity heatmap',
                onAction: () => context.push('/progress')),
            if (badges != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 8,
                      runSpacing: 16,
                      children: [
                        for (final b in badges) BadgeMedal(b, size: 56),
                      ]),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                key: const Key('achievement-history'),
                child: Builder(builder: (context) {
                  final earned = badges.where((b) => b.earned).toList()
                    ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
                  if (earned.isEmpty) {
                    return const ListTile(
                      leading: Icon(Icons.emoji_events_outlined),
                      title: Text('Your first badge is one lesson away.'),
                    );
                  }
                  return Column(children: [
                    for (final b in earned)
                      ListTile(
                        leading: Icon(b.def.icon, color: b.def.color),
                        title: Text(b.def.title),
                        subtitle: Text(b.def.description),
                        trailing: Text(
                            MaterialLocalizations.of(context)
                                .formatShortDate(b.unlockedAt!),
                            style: t.bodySmall),
                      ),
                  ]);
                }),
              ),
            ],
          ]),
    );
  }
}

class _SkillCell extends StatelessWidget {
  final LearnState? state;
  final ModuleType type;
  final Color color;
  const _SkillCell(
      {required this.state, required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    final s = state;
    double? avg;
    if (s != null) {
      final scores = [
        for (final l in s.levels)
          for (final m in l.modules.where((m) => m.type == type))
            for (final lesson in m.lessons)
              if ((s.lessonProgress(lesson.id)?.attempts ?? 0) > 0)
                s.lessonProgress(lesson.id)!.bestScore,
      ];
      if (scores.isNotEmpty) {
        avg = scores.reduce((a, b) => a + b) / scores.length;
      }
    }
    return SizedBox(
      width: 96,
      child: Row(children: [
        Expanded(
            child:
                AnimatedBar(value: (avg ?? 0) / 100, color: color, height: 6)),
        SizedBox(
          width: 36,
          child: Text(avg == null ? '–' : '${avg.round()}',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelMedium),
        ),
      ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _Tile(this.icon, this.value, this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(SyllivoRadii.card),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          FittedBox(
              child:
                  Text(value, style: Theme.of(context).textTheme.titleLarge)),
          Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall),
        ]),
      );
}

class _WeekBars extends StatelessWidget {
  final List<({DateTime day, int xp})> days;
  const _WeekBars(this.days);

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxXp = days.fold<int>(1, (a, d) => d.xp > a ? d.xp : a);
    final total = days.fold<int>(0, (a, d) => a + d.xp);
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$total XP in the last 7 days',
          key: const Key('week-total'), style: t.titleMedium),
      const SizedBox(height: 12),
      SizedBox(
        height: 140,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('${days[i].xp}', style: t.labelSmall),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  tween: Tween(end: days[i].xp / maxXp),
                  duration: const Duration(milliseconds: 500),
                  builder: (_, v, __) => Container(
                    height: 6 + 90 * v,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: i == days.length - 1
                          ? SyllivoColors.indigo
                          : SyllivoColors.indigo
                              .withValues(alpha: days[i].xp == 0 ? 0.15 : 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(labels[days[i].day.weekday - 1], style: t.labelSmall),
              ]),
            ),
        ]),
      ),
    ]);
  }
}
