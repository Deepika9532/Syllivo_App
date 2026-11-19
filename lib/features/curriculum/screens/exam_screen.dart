import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/providers.dart';
import '../../gamification/game_providers.dart';
import '../curriculum_providers.dart';
import '../grading.dart';
import '../models.dart';
import '../widgets/question_view.dart';

const examDisclaimer =
    'This is a Syllivo practice examination. It checks the material in this '
    'course level and is not an official CEFR, Goethe, TestDaF or TOPIK '
    'result.';

enum _ExamPhase { intro, running, result }

/// Level examination: all questions without feedback, then a full review.
class ExamScreen extends ConsumerStatefulWidget {
  final String lang;
  final String levelId;
  const ExamScreen({super.key, required this.lang, required this.levelId});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  _ExamPhase _phase = _ExamPhase.intro;
  int _index = 0;
  final List<(Question, AnswerResult)> _results = [];
  DateTime? _startedAt;
  ScoreSummary? _summary;
  bool _passed = false;
  bool _completedLevel = false;
  int _xp = 0;

  void _start() => setState(() {
        _phase = _ExamPhase.running;
        _index = 0;
        _results.clear();
        _startedAt = ref.read(clockProvider)();
      });

  Future<void> _answer(Level level, AnswerResult r) async {
    _results.add((level.exam[_index], r));
    if (_index + 1 < level.exam.length) {
      setState(() => _index++);
      return;
    }
    final s = summarize(_results);
    final threshold = ref.read(passThresholdProvider);
    final passed = s.passed(threshold);
    final now = ref.read(clockProvider)();
    await ref.read(databaseProvider).saveExamAttempt(
          lang: widget.lang,
          levelId: level.id,
          kind: 'exam',
          percent: s.percent,
          passed: passed,
          threshold: threshold,
          detailJson: jsonEncode({
            'bySkill': {
              for (final e in s.bySkill.entries)
                e.key: {'correct': e.value.correct, 'total': e.value.total},
            },
            'answers': [
              for (final (q, a) in _results)
                {'id': q.id, 'correct': a.correct, 'given': a.given},
            ],
          }),
          startedAt: _startedAt!,
          finishedAt: now,
        );
    final wasComplete = ref
            .read(learnStateProvider(widget.lang))
            .valueOrNull
            ?.isCompleted(level) ??
        false;
    final game = ref.read(gameServiceProvider);
    var xp = await game.examFinished(widget.lang, level.id, passed);
    final state = await ref.refresh(learnStateProvider(widget.lang).future);
    if (!wasComplete && state.isCompleted(level)) {
      xp += await game.levelCompleted(widget.lang, level.id);
    }
    if (!mounted) return;
    setState(() {
      _xp = xp;
      _summary = s;
      _passed = passed;
      _completedLevel = state.isCompleted(level);
      _phase = _ExamPhase.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(curriculumProvider(widget.lang));
    return c.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (curriculum) {
        final level = curriculum.level(widget.levelId)!;
        return Scaffold(
          appBar: AppBar(
            title: Text('${level.code} examination'),
            bottom: _phase == _ExamPhase.running
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(4),
                    child: LinearProgressIndicator(
                        value: _index / level.exam.length),
                  )
                : null,
          ),
          body: SafeArea(
            child: switch (_phase) {
              _ExamPhase.intro => _intro(context, level),
              _ExamPhase.running => Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Text(
                        'Question ${_index + 1} of ${level.exam.length} · '
                        '${level.exam[_index].skill}',
                        key: const Key('question-counter')),
                  ),
                  Expanded(
                    child: QuestionView(
                      key: ValueKey(level.exam[_index].id),
                      question: level.exam[_index],
                      lang: widget.lang,
                      showFeedback: false,
                      onDone: (r) => _answer(level, r),
                    ),
                  ),
                ]),
              _ExamPhase.result => _result(context, curriculum, level),
            },
          ),
        );
      },
    );
  }

  Widget _intro(BuildContext context, Level level) {
    final t = Theme.of(context).textTheme;
    final threshold = ref.watch(passThresholdProvider);
    final skills = level.exam.map((q) => q.skill!).toSet().toList();
    final best = ref
        .watch(learnStateProvider(widget.lang))
        .valueOrNull
        ?.bestExam(level.id);
    return ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.assignment, size: 64),
      const SizedBox(height: 12),
      Text('${level.code} · ${level.title}',
          style: t.headlineSmall, textAlign: TextAlign.center),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${level.exam.length} questions', style: t.titleMedium),
            Text('Skills tested: ${skills.join(', ')}'),
            Text('Pass mark: $threshold%'),
            const Text(
                'No feedback until the end; then you can review every answer.'),
            if (best != null)
              Text('Your best so far: ${best.percent.round()}%'
                  '${best.passed ? ' (passed)' : ''}'),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      Text(examDisclaimer, style: t.bodySmall),
      const SizedBox(height: 24),
      FilledButton(
        key: const Key('start-exam'),
        onPressed: _start,
        child: const Text('Start examination'),
      ),
    ]);
  }

  Widget _result(BuildContext context, Curriculum c, Level level) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final s = _summary!;
    final threshold = ref.watch(passThresholdProvider);
    final i = c.levels.indexOf(level);
    final nextLevel = i + 1 < c.levels.length ? c.levels[i + 1] : null;

    return ListView(padding: const EdgeInsets.all(16), children: [
      Icon(_passed ? Icons.verified : Icons.school,
          size: 64, color: _passed ? Colors.green : cs.primary),
      Text(_passed ? 'Passed!' : 'Not passed yet',
          style: t.headlineSmall, textAlign: TextAlign.center),
      Text('${s.percent.round()}%',
          key: const Key('exam-score'),
          style: t.displayMedium,
          textAlign: TextAlign.center),
      Text('${s.correct} of ${s.answered} correct · pass mark $threshold%',
          textAlign: TextAlign.center),
      Text('+$_xp XP',
          textAlign: TextAlign.center,
          style: t.titleMedium?.copyWith(
              color: SyllivoColors.amber, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      if (_passed && nextLevel != null)
        Text('${nextLevel.code} is now unlocked.',
            textAlign: TextAlign.center, style: t.titleMedium),
      if (_passed && !_completedLevel)
        Text('Finish the remaining lessons to complete ${level.code}.',
            textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('By skill', style: t.titleMedium),
            for (final e in s.bySkill.entries)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(children: [
                  SizedBox(width: 110, child: Text(e.key)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: e.value.correct / e.value.total,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${e.value.correct}/${e.value.total}'),
                ]),
              ),
          ]),
        ),
      ),
      if (_completedLevel)
        FilledButton.icon(
          onPressed: () => context
              .pushReplacement('/learn/${widget.lang}/complete/${level.id}'),
          icon: const Icon(Icons.workspace_premium),
          label: Text('${level.code} complete — see your summary'),
        ),
      const SizedBox(height: 8),
      OutlinedButton(
          onPressed: _start, child: const Text('Retake examination')),
      TextButton(
          onPressed: () => context.pop(), child: const Text('Back to course')),
      const SizedBox(height: 16),
      Text('Review your answers', style: t.titleMedium),
      for (final (q, r) in _results)
        Card(
          child: ListTile(
            leading: Icon(r.correct ? Icons.check_circle : Icons.cancel,
                color: r.correct ? Colors.green : cs.error),
            title: Text(q.prompt.isEmpty ? (q.audio ?? q.type) : q.prompt),
            subtitle: Text([
              if (q.type == 'listening') 'Audio: ${q.audio}',
              if (!r.correct) 'Your answer: ${r.given.isEmpty ? '—' : r.given}',
              'Correct: ${r.expected}',
              if (q.explanation != null) q.explanation!,
            ].join('\n')),
            isThreeLine: true,
          ),
        ),
      const SizedBox(height: 8),
      Text(examDisclaimer, style: t.bodySmall),
    ]);
  }
}
