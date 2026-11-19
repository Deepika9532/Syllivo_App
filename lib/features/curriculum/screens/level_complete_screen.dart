import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../curriculum_providers.dart';

class LevelCompleteScreen extends ConsumerWidget {
  final String lang;
  final String levelId;
  const LevelCompleteScreen(
      {super.key, required this.lang, required this.levelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final state = ref.watch(learnStateProvider(lang));
    return Scaffold(
      appBar: AppBar(title: const Text('Level summary')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (s) {
          final level = s.curriculum.level(levelId)!;
          final done = s.isCompleted(level);
          final exam = s.bestExam(level.id);
          final lessons = level.lessons.toList();
          final i = s.levels.indexOf(level);
          final next = i + 1 < s.levels.length ? s.levels[i + 1] : null;
          final avg = lessons.isEmpty
              ? 0
              : lessons
                      .map((l) => s.lessonProgress(l.id)?.bestScore ?? 0)
                      .reduce((a, b) => a + b) /
                  lessons.length;
          return ListView(padding: const EdgeInsets.all(24), children: [
            Icon(done ? Icons.workspace_premium : Icons.hourglass_bottom,
                size: 96, color: done ? Colors.amber.shade700 : null),
            const SizedBox(height: 12),
            Text(
                done
                    ? 'You completed ${level.code}!'
                    : '${level.code} not complete yet',
                key: const Key('level-complete-title'),
                style: t.headlineMedium,
                textAlign: TextAlign.center),
            Text(level.title,
                style: t.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text('Lessons completed'),
                  trailing: Text(
                      '${lessons.where((l) => s.completedLessons.contains(l.id)).length} / ${lessons.length}'),
                ),
                ListTile(
                  leading: const Icon(Icons.percent),
                  title: const Text('Average lesson score'),
                  trailing: Text('${avg.round()}%'),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in),
                  title: const Text('Best examination score'),
                  trailing:
                      Text(exam == null ? '—' : '${exam.percent.round()}%'),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Text(
              'This summary records your progress in the Syllivo course. It is '
              'not an official CEFR certificate or TOPIK result.',
              style: t.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (next != null && s.isUnlocked(next))
              FilledButton(
                onPressed: () => context.pop(),
                child: Text('Continue to ${next.code}'),
              )
            else
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Back to course'),
              ),
          ]);
        },
      ),
    );
  }
}
