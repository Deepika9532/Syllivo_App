import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/lang.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/companion.dart';
import '../../../core/widgets/syllivo_widgets.dart';
import '../../gamification/game_providers.dart';
import '../curriculum_providers.dart';
import '../grading.dart';
import '../models.dart';
import '../widgets/question_view.dart';

/// Saved state of an unfinished placement test, so closing the app midway
/// resumes at the same question.
class PlacementProgress {
  final int levelIndex;
  final int qIndex;
  final Map<String, ({int correct, int total})> results;
  final DateTime startedAt;

  const PlacementProgress({
    required this.levelIndex,
    required this.qIndex,
    required this.results,
    required this.startedAt,
  });

  static String key(String lang) => 'placementProgress_$lang';

  String encode() => jsonEncode({
        'level': levelIndex,
        'q': qIndex,
        'startedAt': startedAt.toIso8601String(),
        'results': {
          for (final e in results.entries)
            e.key: [e.value.correct, e.value.total],
        },
      });

  static PlacementProgress? decode(String? raw) {
    if (raw == null) return null;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return PlacementProgress(
        levelIndex: j['level'] as int,
        qIndex: j['q'] as int,
        startedAt: DateTime.parse(j['startedAt'] as String),
        results: {
          for (final e in (j['results'] as Map<String, dynamic>).entries)
            e.key: (
              correct: (e.value as List)[0] as int,
              total: (e.value as List)[1] as int,
            ),
        },
      );
    } catch (_) {
      return null; // corrupt or from an older version: start fresh
    }
  }
}

/// Adaptive placement test: three questions per level, stopping at the
/// first level where fewer than two are correct. Each language uses only
/// its own curriculum's questions.
class PlacementScreen extends ConsumerStatefulWidget {
  final String lang;
  const PlacementScreen({super.key, required this.lang});

  @override
  ConsumerState<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends ConsumerState<PlacementScreen> {
  bool _started = false;
  int _levelIndex = 0;
  int _qIndex = 0;
  final Map<String, ({int correct, int total})> _results = {};
  String? _recommended;
  DateTime? _startedAt;
  PlacementProgress? _saved;

  @override
  void initState() {
    super.initState();
    _saved = PlacementProgress.decode(ref
        .read(sharedPrefsProvider)
        .getString(PlacementProgress.key(widget.lang)));
  }

  void _persist() {
    ref.read(sharedPrefsProvider).setString(
        PlacementProgress.key(widget.lang),
        PlacementProgress(
          levelIndex: _levelIndex,
          qIndex: _qIndex,
          results: _results,
          startedAt: _startedAt!,
        ).encode());
  }

  void _clearSaved() =>
      ref.read(sharedPrefsProvider).remove(PlacementProgress.key(widget.lang));

  void _start({PlacementProgress? resume}) {
    setState(() {
      _started = true;
      _results.clear();
      if (resume != null) {
        _levelIndex = resume.levelIndex;
        _qIndex = resume.qIndex;
        _results.addAll(resume.results);
        _startedAt = resume.startedAt;
      } else {
        _levelIndex = 0;
        _qIndex = 0;
        _startedAt = ref.read(clockProvider)();
      }
    });
    _persist();
  }

  Future<void> _answer(Curriculum c, AnswerResult r) async {
    final level = c.levels[_levelIndex];
    final qs = placementQuestionsFor(level);
    final prev = _results[level.id] ?? (correct: 0, total: 0);
    _results[level.id] = (
      correct: prev.correct + (r.correct ? 1 : 0),
      total: prev.total + 1,
    );
    if (_qIndex + 1 < qs.length) {
      setState(() => _qIndex++);
      _persist();
      return;
    }
    final res = _results[level.id]!;
    final failedHere = res.correct * 3 < res.total * 2;
    if (!failedHere && _levelIndex + 1 < c.levels.length) {
      setState(() {
        _levelIndex++;
        _qIndex = 0;
      });
      _persist();
      return;
    }
    final rec = recommendLevel(c.levels, _results);
    final total = _results.values.fold<int>(0, (a, b) => a + b.total);
    final correct = _results.values.fold<int>(0, (a, b) => a + b.correct);
    await ref.read(databaseProvider).saveExamAttempt(
          lang: widget.lang,
          levelId: rec,
          kind: 'placement',
          percent: total == 0 ? 0 : correct * 100 / total,
          passed: true,
          threshold: 0,
          detailJson: jsonEncode({
            for (final e in _results.entries)
              e.key: {'correct': e.value.correct, 'total': e.value.total},
          }),
          startedAt: _startedAt!,
          finishedAt: ref.read(clockProvider)(),
        );
    _clearSaved();
    await ref.read(gameServiceProvider).placementDone(widget.lang);
    if (mounted) setState(() => _recommended = rec);
  }

  Future<void> _accept(String levelId) async {
    final c = await ref.read(curriculumProvider(widget.lang).future);
    final db = ref.read(databaseProvider);
    final now = ref.read(clockProvider)();
    if (levelId == c.levels.first.id) {
      // Starting from the beginning needs no unlocks.
      await db.setStartLevel(widget.lang, levelId, now);
    } else {
      await db.setStartLevel(widget.lang, levelId, now, fromPlacement: true);
    }
    ref.invalidate(learnStateProvider(widget.lang));
    if (mounted) context.pushReplacement('/learn/${widget.lang}/welcome');
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
        final running = _started && _recommended == null;
        const perLevel = placementPerLevel;
        final progress = running
            ? (_levelIndex * perLevel + _qIndex) /
                (curriculum.levels.length * perLevel)
            : (_recommended != null ? 1.0 : 0.0);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Placement test'),
            bottom: running
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(14),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: AnimatedBar(
                          key: const Key('placement-progress'),
                          value: progress,
                          color: SyllivoColors.teal,
                          height: 6),
                    ),
                  )
                : null,
          ),
          body: SafeArea(
            child: !_started
                ? _intro(context, curriculum)
                : _recommended != null
                    ? _result(context, curriculum)
                    : _question(context, curriculum),
          ),
        );
      },
    );
  }

  Widget _intro(BuildContext context, Curriculum c) {
    final t = Theme.of(context).textTheme;
    final info = languages[widget.lang]!;
    final last = ref
        .watch(examAttemptsProvider(widget.lang))
        .valueOrNull
        ?.where((e) => e.kind == 'placement')
        .firstOrNull;
    final lastLevel = last == null ? null : c.level(last.levelId);
    final saved = _saved;
    return ListView(padding: const EdgeInsets.all(24), children: [
      const Center(child: Sylli(size: 120, mood: SylliMood.think)),
      const SizedBox(height: 12),
      Text('Find your ${info.name} level',
          style: t.headlineSmall, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Text(
        'You’ll answer $placementPerLevel questions per level, starting with '
        'the easiest. The test stops as soon as questions get too hard, so it '
        'takes 2–10 minutes. Levels up to your result are unlocked; nothing '
        'is marked as completed. Only ${info.name} questions are used.',
        style: t.bodyLarge,
      ),
      if (lastLevel != null) ...[
        const SizedBox(height: 16),
        Card(
          key: const Key('last-placement'),
          child: ListTile(
            leading: const Icon(Icons.history_rounded),
            title: Text('Last result: ${lastLevel.code} · ${lastLevel.title}'),
            subtitle: Text('${last!.percent.round()}% correct'),
            trailing: TextButton(
              key: const Key('use-last-placement'),
              onPressed: () => _accept(lastLevel.id),
              child: const Text('Use'),
            ),
          ),
        ),
      ],
      const SizedBox(height: 24),
      if (saved != null &&
          saved.levelIndex < c.levels.length &&
          saved.qIndex < placementPerLevel) ...[
        FilledButton.icon(
          key: const Key('resume-placement'),
          onPressed: () => _start(resume: saved),
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text('Resume at ${c.levels[saved.levelIndex].code} · '
              'question ${saved.qIndex + 1}'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          key: const Key('start-placement'),
          onPressed: () => _start(),
          child: const Text('Start over'),
        ),
      ] else
        FilledButton(
          key: const Key('start-placement'),
          onPressed: () => _start(),
          child: Text(lastLevel == null ? 'Start' : 'Take the test again'),
        ),
    ]);
  }

  Widget _question(BuildContext context, Curriculum c) {
    final t = Theme.of(context).textTheme;
    final level = c.levels[_levelIndex];
    final qs = placementQuestionsFor(level);
    final q = qs[_qIndex];
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(children: [
          Text('Level ${level.code}',
              style: t.labelLarge?.copyWith(color: SyllivoColors.indigo)),
          const Spacer(),
          Text('Question ${_qIndex + 1} of ${qs.length}',
              key: const Key('placement-counter'), style: t.labelLarge),
        ]),
      ),
      Expanded(
        child: QuestionView(
          key: ValueKey('placement_${q.id}'),
          question: q,
          lang: widget.lang,
          showFeedback: true,
          checkLabel: 'Submit answer',
          onDone: (r) => _answer(c, r),
        ),
      ),
    ]);
  }

  Widget _result(BuildContext context, Curriculum c) {
    final t = Theme.of(context).textTheme;
    final level = c.level(_recommended!)!;
    final first = c.levels.first;
    final total = _results.values.fold<int>(0, (a, b) => a + b.total);
    final correct = _results.values.fold<int>(0, (a, b) => a + b.correct);
    return ListView(padding: const EdgeInsets.all(24), children: [
      Center(
          child: Text(languages[widget.lang]!.flag,
              style: const TextStyle(fontSize: 56))),
      const SizedBox(height: 8),
      Text('Recommended start',
          style: t.titleMedium, textAlign: TextAlign.center),
      Text(level.code,
          key: const Key('placement-result'),
          style: t.displayMedium?.copyWith(
              color: SyllivoColors.indigo, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center),
      Text(level.title, style: t.titleLarge, textAlign: TextAlign.center),
      const SizedBox(height: 4),
      Text('$correct of $total correct',
          key: const Key('placement-score'),
          style: t.bodyMedium,
          textAlign: TextAlign.center),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your assessment', style: t.titleMedium),
            for (final l in c.levels)
              if (_results[l.id] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(children: [
                    SizedBox(width: 36, child: Text(l.code)),
                    Expanded(
                      child: AnimatedBar(
                          value:
                              _results[l.id]!.correct / _results[l.id]!.total,
                          height: 8),
                    ),
                    const SizedBox(width: 10),
                    Text('${_results[l.id]!.correct}/${_results[l.id]!.total}'),
                  ]),
                ),
          ]),
        ),
      ),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('accept-placement'),
        onPressed: () => _accept(level.id),
        child: Text('Start at ${level.code}'),
      ),
      if (level.id != first.id)
        TextButton(
          key: const Key('start-from-first'),
          onPressed: () => _accept(first.id),
          child: Text('Start from ${first.code} instead'),
        ),
    ]);
  }
}
