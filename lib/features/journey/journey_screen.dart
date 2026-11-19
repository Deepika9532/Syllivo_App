import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../curriculum/curriculum_providers.dart';
import '../curriculum/models.dart';

/// The Learn tab: a winding path of lesson nodes for each level, plus the
/// level examination. Uses the existing unlocking and completion rules.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final state = ref.watch(learnStateProvider(lang));

    Future<void> open(String path) async {
      await context.push(path);
      ref.invalidate(learnStateProvider(lang));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning journey'),
        actions: [
          IconButton(
            tooltip: 'Course overview & placement test',
            icon: const Icon(Icons.list_alt_rounded),
            onPressed: () => open('/learn/$lang'),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SegmentedButton<String>(
            segments: [
              for (final l in languages.values)
                ButtonSegment(
                    value: l.code,
                    label: Text(l.name, key: Key('journey-${l.code}'))),
            ],
            selected: {lang},
            showSelectedIcon: false,
            onSelectionChanged: (s) =>
                ref.read(languageProvider.notifier).select(s.first),
          ),
        ),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (s) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                for (final level in s.levels)
                  _LevelSection(
                      level: level, state: s, lang: lang, onOpen: open),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

enum _NodeState { done, current, open, locked }

class _LevelSection extends StatelessWidget {
  final Level level;
  final LearnState state;
  final String lang;
  final Future<void> Function(String) onOpen;

  const _LevelSection(
      {required this.level,
      required this.state,
      required this.lang,
      required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final unlocked = state.isUnlocked(level);
    final completed = state.isCompleted(level);
    final colors = SyllivoColors.forLang(lang);
    final i = state.levels.indexOf(level);
    final prev = i > 0 ? state.levels[i - 1] : null;
    final current = state.nextLesson;

    void locked() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Locked. Pass the ${prev?.code} examination (${state.threshold}%+), take the '
              'placement test, or choose a starting level to unlock ${level.code}.'),
        ));

    final lessons =
        level.modules.expand((m) => m.lessons.map((l) => (m, l))).toList();
    final allLessonsDone =
        lessons.every((e) => state.completedLessons.contains(e.$2.id));
    final exam = state.bestExam(level.id);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Level banner
      Container(
        key: Key('journey-level-${level.id}'),
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: unlocked ? LinearGradient(colors: colors) : null,
          color: unlocked
              ? null
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(SyllivoRadii.card),
        ),
        child: Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${level.code} · ${level.title}',
                  style: t.titleLarge
                      ?.copyWith(color: unlocked ? Colors.white : null)),
              const SizedBox(height: 6),
              if (unlocked) ...[
                AnimatedBar(
                    value: state.progressOf(level),
                    color: Colors.white,
                    height: 8),
                const SizedBox(height: 4),
                Text(
                    '${(state.progressOf(level) * 100).round()}% complete'
                    '${completed ? ' · level complete' : ''}',
                    style: t.bodySmall?.copyWith(color: Colors.white)),
              ] else
                Text('Locked — pass the ${prev?.code ?? ''} exam to open',
                    style: t.bodySmall),
            ]),
          ),
          Icon(
            completed
                ? Icons.workspace_premium_rounded
                : unlocked
                    ? Icons.route_rounded
                    : Icons.lock_rounded,
            color: unlocked ? Colors.white : null,
            size: 32,
          ),
        ]),
      ),
      if (unlocked)
        LayoutBuilder(builder: (context, c) {
          final width = c.maxWidth;
          const step = 104.0;
          final count = lessons.length + 1;
          double xFor(int k) => width / 2 + sin(k * 0.9) * (width / 2 - 56);
          return SizedBox(
            height: count * step,
            child: Stack(children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PathPainter(
                    [
                      for (var k = 0; k < count; k++)
                        Offset(xFor(k), k * step + 40)
                    ],
                    Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              for (var k = 0; k < lessons.length; k++)
                Builder(builder: (_) {
                  final (m, l) = lessons[k];
                  final p = state.lessonProgress(l.id);
                  final st = state.completedLessons.contains(l.id)
                      ? _NodeState.done
                      : current?.id == l.id
                          ? _NodeState.current
                          : _NodeState.open;
                  return Positioned(
                    left: xFor(k) - 40,
                    top: k * step,
                    child: _Node(
                      key: Key('node-${l.id}'),
                      icon: m.type.icon,
                      label: m.type.label,
                      state: st,
                      score:
                          st == _NodeState.done ? p?.bestScore.round() : null,
                      onTap: () => onOpen('/learn/$lang/lesson/${l.id}'),
                    ),
                  );
                }),
              Positioned(
                left: xFor(lessons.length) - 40,
                top: lessons.length * step,
                child: _Node(
                  key: Key('node-exam-${level.id}'),
                  icon: Icons.emoji_events_rounded,
                  label: exam?.passed == true
                      ? 'Exam ${exam!.percent.round()}%'
                      : allLessonsDone
                          ? 'Exam ready'
                          : 'Exam',
                  state: state.passedExams.contains(level.id)
                      ? _NodeState.done
                      : allLessonsDone
                          ? _NodeState.current
                          : _NodeState.open,
                  exam: true,
                  onTap: () => onOpen('/learn/$lang/exam/${level.id}'),
                ),
              ),
            ]),
          );
        })
      else
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (final (m, l) in lessons.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _Node(
                  key: Key('node-${l.id}'),
                  icon: m.type.icon,
                  label: '',
                  state: _NodeState.locked,
                  small: true,
                  onTap: locked,
                ),
              ),
          ]),
        ),
    ]);
  }
}

class _PathPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  _PathPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      path.cubicTo(
          a.dx, (a.dy + b.dy) / 2, b.dx, (a.dy + b.dy) / 2, b.dx, b.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_PathPainter o) => o.points != points || o.color != color;
}

class _Node extends StatelessWidget {
  final IconData icon;
  final String label;
  final _NodeState state;
  final int? score;
  final bool exam;
  final bool small;
  final VoidCallback onTap;

  const _Node({
    super.key,
    required this.icon,
    required this.label,
    required this.state,
    required this.onTap,
    this.score,
    this.exam = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = small ? 44.0 : 72.0;
    final (Color bg, Color fg, Color edge) = switch (state) {
      _NodeState.done => (
          SyllivoColors.teal,
          Colors.white,
          const Color(0xFF0F766E)
        ),
      _NodeState.current => (
          exam ? SyllivoColors.amber : SyllivoColors.indigo,
          Colors.white,
          exam ? const Color(0xFFB45309) : SyllivoColors.navy
        ),
      _NodeState.open => (
          cs.surfaceContainerLow,
          SyllivoColors.indigo,
          cs.outlineVariant
        ),
      _NodeState.locked => (
          cs.surfaceContainerHighest,
          cs.outline,
          cs.outlineVariant
        ),
    };
    final node = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(color: edge, width: 3),
        boxShadow: [BoxShadow(color: edge, offset: const Offset(0, 5))],
      ),
      child: Icon(
        state == _NodeState.locked
            ? Icons.lock_rounded
            : (state == _NodeState.done && !exam ? Icons.check_rounded : icon),
        color: fg,
        size: size * 0.45,
      ),
    );
    return Semantics(
      button: true,
      label: '$label, ${state.name}',
      child: Pressable(
        onTap: onTap,
        child: SizedBox(
          width: small ? size : 80,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (state == _NodeState.current && !small)
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    node,
                    Positioned(
                      right: -26,
                      top: -14,
                      child: Sylli(
                          size: 34,
                          mood: exam ? SylliMood.cheer : SylliMood.wave),
                    ),
                  ])
            else
              node,
            if (!small) ...[
              const SizedBox(height: 6),
              Text(
                score != null ? '$label · $score%' : label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
