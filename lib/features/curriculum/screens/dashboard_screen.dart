import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/lang.dart';
import '../curriculum_providers.dart';
import '../models.dart';

String formatMinutes(int ms) {
  final m = (ms / 60000).round();
  return m < 60 ? '$m min' : '${m ~/ 60} h ${m % 60} min';
}

/// Per-language progress dashboard (German and Korean are independent).
class DashboardScreen extends ConsumerWidget {
  final String lang;
  const DashboardScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learnStateProvider(lang));
    final extra = ref.watch(dashboardStatsProvider(lang));
    final info = languages[lang]!;
    return Scaffold(
      appBar: AppBar(title: Text('${info.flag} ${info.name} progress')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (s) => extra.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (x) => _Body(state: s, extra: x, lang: lang),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final LearnState state;
  final DashboardStats extra;
  final String lang;
  const _Body({required this.state, required this.extra, required this.lang});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = state;
    final lessons = s.levels.expand((l) => l.modules).toList();

    ({int done, int total, double avg}) moduleStats(ModuleType type) {
      final ls = lessons
          .where((m) => m.type == type)
          .expand((m) => m.lessons)
          .toList();
      final done = ls.where((l) => s.completedLessons.contains(l.id)).length;
      final scored = [
        for (final l in ls)
          if ((s.lessonProgress(l.id)?.attempts ?? 0) > 0)
            s.lessonProgress(l.id)!.bestScore,
      ];
      final avg =
          scored.isEmpty ? 0.0 : scored.reduce((a, b) => a + b) / scored.length;
      return (done: done, total: ls.length, avg: avg);
    }

    final quiz = moduleStats(ModuleType.quiz);
    final exams = s.exams.where((e) => e.kind == 'exam').toList();

    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Current level', style: t.labelLarge),
            Text('${s.currentLevel.code} · ${s.currentLevel.title}',
                style: t.headlineSmall),
            const SizedBox(height: 12),
            LinearProgressIndicator(
                value: s.overall,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5)),
            const SizedBox(height: 4),
            Text('Overall completion ${(s.overall * 100).round()}%',
                key: const Key('overall-completion')),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.15,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          _Tile('Lessons', '${s.completedCount}/${s.curriculum.totalLessons}',
              Icons.menu_book),
          _Tile('Words learned', '${extra.cards.learnedCards}', Icons.style),
          _Tile(
              'Streak',
              '${extra.cards.streak} ${extra.cards.streak == 1 ? 'day' : 'days'}',
              Icons.local_fire_department),
          _Tile('Today', formatMinutes(extra.todayMs), Icons.timer),
          _Tile('Total time', formatMinutes(extra.totalMs),
              Icons.hourglass_bottom),
          _Tile('Exams passed', '${s.passedExams.length}/${s.levels.length}',
              Icons.assignment_turned_in),
        ],
      ),
      const SizedBox(height: 16),
      Text('Skills', style: t.titleLarge),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            for (final type in ModuleType.values)
              Builder(builder: (_) {
                final m = moduleStats(type);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Icon(type.icon, size: 20),
                    const SizedBox(width: 8),
                    SizedBox(width: 110, child: Text(type.label)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: m.total == 0 ? 0 : m.done / m.total,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      child: Text(
                          '${m.done}/${m.total}'
                          '${m.avg > 0 ? ' · ${m.avg.round()}%' : ''}',
                          textAlign: TextAlign.end,
                          style: t.bodySmall),
                    ),
                  ]),
                );
              }),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      Text('Speaking & pronunciation', style: t.titleLarge),
      Card(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Speaking exercises (average score)'),
            trailing: Text(
                extra.avgSpeech == null ? '—' : '${extra.avgSpeech!.round()}'),
          ),
          ListTile(
            leading: const Icon(Icons.graphic_eq),
            title: const Text('Word-deck pronunciation (average)'),
            trailing: Text(extra.cards.avgPronunciation == null
                ? '—'
                : '${extra.cards.avgPronunciation!.round()}'),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child:
                Text('Scores come from on-device speech recognition and are a '
                    'practice guide, not a proficiency assessment.'),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      Text('Quizzes & examinations', style: t.titleLarge),
      Card(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz performance'),
            subtitle: Text('${quiz.done} of ${quiz.total} quizzes passed'),
            trailing: Text(quiz.avg == 0 ? '—' : '${quiz.avg.round()}%'),
          ),
          if (exams.isEmpty)
            const ListTile(title: Text('No examinations taken yet.')),
          for (final e in exams.take(10))
            ListTile(
              leading: Icon(e.passed ? Icons.verified : Icons.cancel,
                  color: e.passed
                      ? Colors.green
                      : Theme.of(context).colorScheme.error),
              title: Text(
                  '${s.curriculum.level(e.levelId)?.code ?? e.levelId} examination'),
              subtitle: Text(MaterialLocalizations.of(context)
                  .formatMediumDate(e.finishedAt)),
              trailing: Text('${e.percent.round()}%'),
            ),
        ]),
      ),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: () => context.push('/progress'),
        icon: const Icon(Icons.insights),
        label: const Text('Activity heatmap & achievements'),
      ),
    ]);
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Tile(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          FittedBox(child: Text(value, style: t.titleMedium)),
          Text(label, style: t.bodySmall, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
