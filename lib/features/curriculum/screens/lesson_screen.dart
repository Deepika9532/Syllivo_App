import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/db/app_database.dart' hide Lesson;
import '../../../core/providers.dart';
import '../../../core/widgets/companion.dart';
import '../../../core/widgets/message_view.dart';
import '../../../core/widgets/syllivo_widgets.dart';
import '../../gamification/game_providers.dart';
import '../curriculum_providers.dart';
import '../grading.dart';
import '../models.dart';
import '../widgets/content_blocks.dart';
import '../widgets/question_view.dart';

enum _Phase { learn, practice, outOfHearts, result }

/// A lesson: short learning material, then a full-screen practice player
/// with hearts and progress, then a results/celebration screen.
class LessonScreen extends ConsumerStatefulWidget {
  final String lang;
  final String lessonId;
  const LessonScreen({super.key, required this.lang, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  final _watch = Stopwatch()..start();
  late final AppDatabase _db;
  _Phase _phase = _Phase.learn;
  int _index = 0;
  int _baseCorrect = 0, _baseAnswered = 0, _baseSkipped = 0;
  final List<(Question, AnswerResult)> _results = [];
  LessonProgressRow? _saved;
  bool _loadedProgress = false;
  bool _justCompletedLevel = false;
  double _percent = 0;
  bool _passed = false;
  int _xp = 0;
  int _hearts = maxHearts;

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
  }

  @override
  void dispose() {
    _db.addStudyTime(widget.lang, _watch.elapsedMilliseconds, DateTime.now());
    super.dispose();
  }

  GameService get _game => ref.read(gameServiceProvider);

  Future<void> _loadProgress(Curriculum c) async {
    if (_loadedProgress) return;
    _loadedProgress = true;
    final level = c.levelOfLesson(widget.lessonId)!;
    final module = c.moduleOfLesson(widget.lessonId)!;
    final now = ref.read(clockProvider)();
    await _db.markLessonOpened(
        widget.lang, level.id, module.type.name, widget.lessonId, now);
    final p = await _db.getLessonProgress(widget.lessonId);
    final h = await _game.hearts();
    if (mounted) {
      setState(() {
        _saved = p;
        _hearts = h;
      });
    }
  }

  Future<void> _startPractice({required bool resume}) async {
    final p = _saved;
    final hearts = await _game.hearts();
    if (!mounted) return;
    setState(() {
      _hearts = hearts;
      _results.clear();
      if (resume && p != null && p.runIndex > 0) {
        _index = p.runIndex;
        _baseCorrect = p.runCorrect;
        _baseAnswered = p.runAnswered;
        _baseSkipped = p.runSkipped;
      } else {
        _index = 0;
        _baseCorrect = _baseAnswered = _baseSkipped = 0;
      }
      _phase = _game.heartsEnabled && hearts <= 0
          ? _Phase.outOfHearts
          : _Phase.practice;
    });
    if (!resume && p != null && p.runIndex > 0) {
      await _db.resetLessonRun(widget.lessonId, ref.read(clockProvider)());
    }
  }

  Future<void> _onGraded(AnswerResult r) async {
    if (r.correct || r.skipped) return;
    final h = await _game.loseHeart();
    if (mounted) setState(() => _hearts = h);
  }

  Future<void> _onAnswer(Curriculum c, Lesson lesson, AnswerResult r) async {
    final q = lesson.questions[_index];
    final level = c.levelOfLesson(lesson.id)!;
    final module = c.moduleOfLesson(lesson.id)!;
    final now = ref.read(clockProvider)();
    _results.add((q, r));
    await _db.recordAnswer(
      lang: widget.lang,
      levelId: level.id,
      moduleType: module.type.name,
      lessonId: lesson.id,
      questionId: q.id,
      questionType: q.type,
      correct: r.correct,
      skipped: r.skipped,
      answer: r.given,
      score: r.score,
      nextIndex: _index + 1,
      now: now,
    );
    if (_index + 1 < lesson.questions.length) {
      setState(() {
        _index++;
        if (_game.heartsEnabled && _hearts <= 0) _phase = _Phase.outOfHearts;
      });
      return;
    }

    final s = summarize(_results);
    final correct = _baseCorrect + s.correct;
    final answered = _baseAnswered + s.answered;
    final percent = answered == 0 ? 0.0 : correct * 100 / answered;
    final threshold = ref.read(passThresholdProvider);
    final passed = answered > 0 && percent >= threshold;
    final wasLevelComplete = _levelCompleteNow(level);
    final row = await _db.finishLessonRun(
      lang: widget.lang,
      levelId: level.id,
      moduleType: module.type.name,
      lessonId: lesson.id,
      percent: percent,
      passed: passed,
      now: now,
    );
    var xp = await _game.lessonFinished(
        widget.lang, module.type.name, percent, passed);
    final state = await ref.refresh(learnStateProvider(widget.lang).future);
    final levelDone = !wasLevelComplete && state.isCompleted(level);
    if (levelDone) xp += await _game.levelCompleted(widget.lang, level.id);
    if (passed) HapticFeedback.mediumImpact();
    if (!mounted) return;
    setState(() {
      _saved = row;
      _percent = percent;
      _passed = passed;
      _xp = xp;
      _justCompletedLevel = levelDone;
      _phase = _Phase.result;
    });
  }

  bool _levelCompleteNow(Level level) =>
      ref
          .read(learnStateProvider(widget.lang))
          .valueOrNull
          ?.isCompleted(level) ??
      false;

  /// Target-language words from the lesson, used as distractor tiles.
  List<String> _wordBank(Lesson lesson) => {
        for (final q in lesson.questions) ...[
          ...q.words,
          for (final a in q.answers.take(1)) ...a.split(' '),
        ],
        for (final b in lesson.blocks.where((b) => b.type == 'vocab'))
          for (final i in b.list('items'))
            ...((i as Map)['target'] as String).split(' '),
      }.where((w) => w.length > 1).toList();

  @override
  Widget build(BuildContext context) {
    final curriculum = ref.watch(curriculumProvider(widget.lang));
    return curriculum.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (c) {
        final lesson = c.lesson(widget.lessonId);
        if (lesson == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const MessageView(
                icon: Icons.search_off,
                title: 'Lesson not found',
                body: 'This lesson is no longer part of the course.'),
          );
        }
        _loadProgress(c);
        final module = c.moduleOfLesson(lesson.id)!;
        final level = c.levelOfLesson(lesson.id)!;
        return switch (_phase) {
          _Phase.learn => Scaffold(
              appBar:
                  AppBar(title: Text('${level.code} · ${module.type.label}')),
              body: SafeArea(child: _learn(context, lesson, module, level)),
            ),
          _Phase.practice => Scaffold(
              body: SafeArea(
                child: Column(children: [
                  _PlayerTopBar(
                    progress: _index / lesson.questions.length,
                    hearts: _hearts,
                    heartsEnabled: _game.heartsEnabled,
                    counter: '${_index + 1} / ${lesson.questions.length}',
                    onClose: () => context.pop(),
                  ),
                  Expanded(
                    child: QuestionView(
                      key: ValueKey(lesson.questions[_index].id),
                      question: lesson.questions[_index],
                      lang: widget.lang,
                      showFeedback: true,
                      wordBank: _wordBank(lesson),
                      onGraded: _onGraded,
                      onDone: (r) => _onAnswer(c, lesson, r),
                    ),
                  ),
                ]),
              ),
            ),
          _Phase.outOfHearts =>
            Scaffold(body: SafeArea(child: _outOfHearts(context, lesson))),
          _Phase.result => Scaffold(
              body: SafeArea(child: _resultView(context, c, lesson, level))),
        };
      },
    );
  }

  /// Level vocabulary for highlighting words in reading passages.
  Map<String, String> _glossary(Level level) => {
        for (final m
            in level.modules.where((m) => m.type == ModuleType.vocabulary))
          for (final l in m.lessons)
            for (final b in l.blocks.where((b) => b.type == 'vocab'))
              for (final i in b.list('items'))
                ((i as Map)['target'] as String): i['en'] as String,
      };

  Widget _learn(BuildContext context, Lesson lesson, CurriculumModule module,
      Level level) {
    final t = Theme.of(context).textTheme;
    final roman = ref.watch(romanizationProvider);
    final p = _saved;
    final canResume =
        p != null && p.runIndex > 0 && p.runIndex < lesson.questions.length;
    final colors = SyllivoColors.forLang(widget.lang);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(SyllivoRadii.card),
          ),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(module.type.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title,
                        style: t.titleLarge?.copyWith(color: Colors.white)),
                    if (lesson.summary != null)
                      Text(lesson.summary!,
                          style: t.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9))),
                  ]),
            ),
          ]),
        ),
        if (p?.status == 2)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                  avatar: Icon(Icons.check, size: 18),
                  label: Text('Completed')),
            ),
          ),
        const SizedBox(height: 8),
        for (final b in lesson.blocks)
          ContentBlockView(
            block: b,
            lang: widget.lang,
            showRomanization: roman,
            vocabAsCards: module.type == ModuleType.vocabulary,
            rules: module.type == ModuleType.grammar,
            glossary: _glossary(level),
          ),
        const SizedBox(height: 16),
        const SylliSays(
            'Ready? Read through the examples, then let’s practise together.',
            mood: SylliMood.wave,
            size: 56),
        const SizedBox(height: 16),
        if (canResume) ...[
          FilledButton.icon(
            key: const Key('resume-practice'),
            onPressed: () => _startPractice(resume: true),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
                'Resume practice (question ${p.runIndex + 1} of ${lesson.questions.length})'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _startPractice(resume: false),
            child: const Text('Start over'),
          ),
        ] else
          FilledButton.icon(
            key: const Key('start-practice'),
            onPressed: () => _startPractice(resume: false),
            icon: const Icon(Icons.play_arrow_rounded),
            label:
                Text('Start practice · ${lesson.questions.length} questions'),
          ),
        if (p != null && p.attempts > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Best score: ${p.bestScore.round()}%',
                textAlign: TextAlign.center, style: t.bodySmall),
          ),
      ],
    );
  }

  Widget _outOfHearts(BuildContext context, Lesson lesson) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Sylli(size: 140, mood: SylliMood.sad),
        const SizedBox(height: 16),
        Text('You’re out of hearts',
            key: const Key('out-of-hearts'), style: t.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Your progress is saved. Hearts refill one every 30 minutes — or '
          'practise flashcards now to refill them all. You can also turn hearts '
          'off in Profile.',
          textAlign: TextAlign.center,
          style: t.bodyLarge,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () async {
            await context.push('/review');
            final h = await _game.hearts();
            if (!mounted) return;
            setState(() {
              _hearts = h;
              if (h > 0) _phase = _Phase.practice;
            });
          },
          icon: const Icon(Icons.style_rounded),
          label: const Text('Practise to refill'),
        ),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () => context.pop(),
            child: const Text('Back to journey')),
      ]),
    );
  }

  Widget _resultView(
      BuildContext context, Curriculum c, Lesson lesson, Level level) {
    final t = Theme.of(context).textTheme;
    final threshold = ref.watch(passThresholdProvider);
    final s = summarize(_results);
    final next = _nextLessonInLevel(level, lesson);
    final mascot =
        Sylli(size: 150, mood: _passed ? SylliMood.cheer : SylliMood.think);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 12),
        Center(child: _passed ? ConfettiBurst(child: mascot) : mascot),
        const SizedBox(height: 12),
        Text(_passed ? 'Lesson complete!' : 'Keep practising',
            style: t.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: _ResultStat(
              label: 'Score',
              value: '${_percent.round()}%',
              valueKey: const Key('lesson-score'),
              color: _passed ? SyllivoColors.success : SyllivoColors.coral,
              icon: Icons.track_changes_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ResultStat(
              label: 'XP earned',
              value: '+$_xp',
              color: SyllivoColors.amber,
              icon: Icons.bolt_rounded,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text(
          _passed
              ? 'You passed (pass mark $threshold%).'
              : 'You need $threshold% to complete this lesson.',
          textAlign: TextAlign.center,
        ),
        if (s.skipped + _baseSkipped > 0)
          Text(
              '${s.skipped + _baseSkipped} skipped question(s) were not counted.',
              textAlign: TextAlign.center,
              style: t.bodySmall),
        const SizedBox(height: 24),
        if (_justCompletedLevel) ...[
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: SyllivoColors.amber),
            onPressed: () => context
                .pushReplacement('/learn/${widget.lang}/complete/${level.id}'),
            icon: const Icon(Icons.workspace_premium_rounded),
            label: Text('${level.code} complete — see your summary'),
          ),
          const SizedBox(height: 8),
        ],
        if (next != null)
          FilledButton.icon(
            key: const Key('next-lesson'),
            onPressed: () => context
                .pushReplacement('/learn/${widget.lang}/lesson/${next.id}'),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('Next: ${next.title}', overflow: TextOverflow.ellipsis),
          )
        else
          FilledButton.icon(
            onPressed: () => context
                .pushReplacement('/learn/${widget.lang}/exam/${level.id}'),
            icon: const Icon(Icons.assignment_rounded),
            label: Text('Go to the ${level.code} examination'),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('retry'),
          onPressed: () => _startPractice(resume: false),
          icon: const Icon(Icons.replay_rounded),
          label: const Text('Retry practice'),
        ),
        TextButton(
            onPressed: () => context.pop(),
            child: const Text('Back to journey')),
      ],
    );
  }

  Lesson? _nextLessonInLevel(Level level, Lesson current) {
    final all = level.lessons.toList();
    final i = all.indexWhere((l) => l.id == current.id);
    return i >= 0 && i + 1 < all.length ? all[i + 1] : null;
  }
}

/// Top of the lesson player: close, animated progress, counter, hearts.
class _PlayerTopBar extends StatelessWidget {
  final double progress;
  final int hearts;
  final bool heartsEnabled;
  final String counter;
  final VoidCallback onClose;

  const _PlayerTopBar({
    required this.progress,
    required this.hearts,
    required this.heartsEnabled,
    required this.counter,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
        child: Row(children: [
          IconButton(
            tooltip: 'Leave lesson (progress is saved)',
            icon: const Icon(Icons.close_rounded),
            onPressed: onClose,
          ),
          Expanded(
              child: AnimatedBar(
                  value: progress, color: SyllivoColors.teal, height: 14)),
          const SizedBox(width: 10),
          Text(counter,
              key: const Key('question-counter'),
              style: Theme.of(context).textTheme.labelLarge),
          if (heartsEnabled) ...[
            const SizedBox(width: 10),
            StatPill(
              icon: Icons.favorite_rounded,
              value: '$hearts',
              color: SyllivoColors.coral,
              semantics: '$hearts hearts left',
            ),
          ],
        ]),
      );
}

class _ResultStat extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final Key? valueKey;
  const _ResultStat(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon,
      this.valueKey});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(SyllivoRadii.card),
          border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
        ),
        child: Column(children: [
          Text(label.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: color, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Text(value,
                key: valueKey,
                style: Theme.of(context).textTheme.headlineSmall),
          ]),
        ]),
      );
}
