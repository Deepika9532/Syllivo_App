import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/lang.dart';
import '../../../core/providers.dart';
import '../curriculum_providers.dart';
import '../models.dart';

/// One language's learning path: levels, modules, exams and quick actions.
class CurriculumScreen extends ConsumerStatefulWidget {
  final String lang;
  const CurriculumScreen({super.key, required this.lang});

  @override
  ConsumerState<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends ConsumerState<CurriculumScreen> {
  String? _expanded;

  @override
  void initState() {
    super.initState();
    // Existing screens (reviews, decks, stats) follow the selected language.
    Future.microtask(() {
      if (ref.read(languageProvider) != widget.lang) {
        ref.read(languageProvider.notifier).select(widget.lang);
      }
    });
  }

  Future<void> _go(String path) async {
    await context.push(path);
    ref.invalidate(queueCountsProvider(widget.lang));
  }

  Future<void> _chooseStart(LearnState s) async {
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose your starting level'),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('Levels up to your choice are unlocked. Nothing is '
                'marked as completed; earlier levels stay available for review.'),
          ),
          for (final l in s.levels)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, l.id),
              child: Text('${l.code} · ${l.title}'),
            ),
        ],
      ),
    );
    if (chosen != null) {
      await ref
          .read(databaseProvider)
          .setStartLevel(widget.lang, chosen, ref.read(clockProvider)());
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = languages[widget.lang]!;
    final state = ref.watch(learnStateProvider(widget.lang));
    final counts = ref.watch(queueCountsProvider(widget.lang)).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text('${info.flag}  ${info.nativeName}'),
        actions: [
          IconButton(
            tooltip: 'Progress dashboard',
            icon: const Icon(Icons.dashboard),
            onPressed: () => _go('/learn/${widget.lang}/dashboard'),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load the course: $e'))),
        data: (s) {
          _expanded ??= s.currentLevel.id;
          final next = s.nextLesson;
          final t = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _Header(state: s, lang: widget.lang),
              const SizedBox(height: 12),
              if (next != null)
                FilledButton.icon(
                  key: const Key('continue-learning'),
                  onPressed: () =>
                      _go('/learn/${widget.lang}/lesson/${next.id}'),
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Continue: ${next.title}',
                      overflow: TextOverflow.ellipsis),
                ),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ActionChip(
                  avatar: const Icon(Icons.style, size: 18),
                  label: Text(counts == null
                      ? 'Review cards'
                      : 'Review · ${counts.due} due · ${counts.fresh} new'),
                  onPressed: () => _go('/review'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.explore, size: 18),
                  label: const Text('Placement test'),
                  onPressed: () => _go('/learn/${widget.lang}/placement'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.flag, size: 18),
                  label: const Text('Starting level'),
                  onPressed: () => _chooseStart(s),
                ),
                ActionChip(
                  avatar: const Icon(Icons.collections_bookmark, size: 18),
                  label: const Text('Word decks'),
                  onPressed: () => _go('/lessons'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.insights, size: 18),
                  label: const Text('Activity & achievements'),
                  onPressed: () => _go('/progress'),
                ),
              ]),
              const SizedBox(height: 20),
              Text('Learning path', style: t.titleLarge),
              const SizedBox(height: 8),
              for (final level in s.levels)
                _LevelCard(
                  level: level,
                  state: s,
                  lang: widget.lang,
                  expanded: _expanded == level.id,
                  onToggle: () => setState(
                      () => _expanded = _expanded == level.id ? '' : level.id),
                  onOpen: _go,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final LearnState state;
  final String lang;
  const _Header({required this.state, required this.lang});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final level = state.currentLevel;
    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Current level', style: t.labelLarge),
          Text('${level.code} · ${level.title}',
              key: const Key('current-level'), style: t.headlineSmall),
          if (level.alignment != null)
            Text(level.alignment!, style: t.bodySmall),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: state.overall,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text('${(state.overall * 100).round()}% of the course · '
              '${state.completedCount} / ${state.curriculum.totalLessons} lessons · '
              '${state.passedExams.length} / ${state.levels.length} exams passed'),
        ]),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final LearnState state;
  final String lang;
  final bool expanded;
  final VoidCallback onToggle;
  final Future<void> Function(String path) onOpen;

  const _LevelCard({
    required this.level,
    required this.state,
    required this.lang,
    required this.expanded,
    required this.onToggle,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final unlocked = state.isUnlocked(level);
    final completed = state.isCompleted(level);
    final progress = state.progressOf(level);
    final exam = state.bestExam(level.id);
    final i = state.levels.indexOf(level);
    final prev = i > 0 ? state.levels[i - 1] : null;

    return Card(
      key: Key('level-${level.id}'),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        ListTile(
          onTap: unlocked
              ? onToggle
              : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Locked. Pass the ${prev?.code} examination '
                        '(${state.threshold}%+), take the placement test, or '
                        'choose a starting level to unlock ${level.code}.'),
                  )),
          leading: CircleAvatar(
            backgroundColor: completed
                ? Colors.green
                : unlocked
                    ? cs.primary
                    : cs.surfaceContainerHighest,
            foregroundColor: unlocked || completed ? Colors.white : cs.outline,
            child: completed
                ? const Icon(Icons.check)
                : unlocked
                    ? Text(level.code, style: const TextStyle(fontSize: 13))
                    : const Icon(Icons.lock, size: 18),
          ),
          title: Text('${level.code} · ${level.title}', style: t.titleMedium),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(level.description,
                maxLines: expanded ? 4 : 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ]),
          trailing: unlocked
              ? Icon(expanded ? Icons.expand_less : Icons.expand_more)
              : null,
        ),
        if (expanded && unlocked) ...[
          if (level.alignment != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(level.alignment!, style: t.bodySmall),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(spacing: 6, runSpacing: 6, children: [
              for (final topic in level.topics.take(8))
                Chip(label: Text(topic), visualDensity: VisualDensity.compact),
            ]),
          ),
          for (final m in level.modules)
            for (final lesson in m.lessons)
              _LessonTile(
                lesson: lesson,
                module: m,
                state: state,
                onTap: () => onOpen('/learn/$lang/lesson/${lesson.id}'),
              ),
          ListTile(
            key: Key('exam-${level.id}'),
            leading: Icon(Icons.assignment,
                color: state.passedExams.contains(level.id)
                    ? Colors.green
                    : cs.primary),
            title: Text('${level.code} examination'),
            subtitle: Text(exam == null
                ? '${level.exam.length} questions · pass mark ${state.threshold}%'
                : 'Best ${exam.percent.round()}%${exam.passed ? ' · passed' : ''}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onOpen('/learn/$lang/exam/${level.id}'),
          ),
          if (completed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                onPressed: () => onOpen('/learn/$lang/complete/${level.id}'),
                icon: const Icon(Icons.workspace_premium),
                label: Text('${level.code} summary'),
              ),
            ),
        ],
      ]),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final CurriculumModule module;
  final LearnState state;
  final VoidCallback onTap;

  const _LessonTile(
      {required this.lesson,
      required this.module,
      required this.state,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = state.lessonProgress(lesson.id);
    final status = p?.status ?? 0;
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      key: Key('lesson-${lesson.id}'),
      dense: true,
      leading: Icon(module.type.icon),
      title: Text(module.type.label),
      subtitle:
          Text(lesson.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: switch (status) {
        2 => Row(mainAxisSize: MainAxisSize.min, children: [
            Text('${p!.bestScore.round()}%'),
            const SizedBox(width: 4),
            const Icon(Icons.check_circle, color: Colors.green),
          ]),
        1 => Icon(Icons.timelapse,
            color: cs.tertiary, semanticLabel: 'In progress'),
        _ => Icon(Icons.circle_outlined,
            color: cs.outline, semanticLabel: 'Not started'),
      },
      onTap: onTap,
    );
  }
}
