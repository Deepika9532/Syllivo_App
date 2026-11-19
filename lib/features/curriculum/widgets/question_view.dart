import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/lang.dart';
import '../../../core/providers.dart';
import '../../../core/speech/pronunciation_diff.dart';
import '../../../core/speech/stt_service.dart';
import '../../../core/widgets/companion.dart';
import '../../../core/widgets/illustrations.dart';
import '../../../core/widgets/pronunciation_diff_view.dart';
import '../../../core/widgets/speak.dart';
import '../../../core/widgets/syllivo_widgets.dart';
import '../grading.dart';
import '../models.dart';

/// Full-height interactive question: prompt area at the top, answers in the
/// middle, a sticky Check bar at the bottom that turns into a feedback panel.
///
/// Practice mode ([showFeedback]) shows right/wrong, the correct answer and
/// an explanation before Continue. Exam mode submits without feedback.
/// The parent must give this widget a bounded height (e.g. [Expanded]).
class QuestionView extends ConsumerStatefulWidget {
  final Question question;
  final String lang;
  final bool showFeedback;
  final void Function(AnswerResult result) onDone;

  /// Called as soon as an answer is graded (before Continue), e.g. to update
  /// hearts and progress immediately.
  final void Function(AnswerResult result)? onGraded;

  /// Extra target-language words used as distractor tiles in translation
  /// exercises. When null (exams), translation uses the keyboard.
  final List<String>? wordBank;

  /// Overrides the label of the check button (e.g. 'Submit answer').
  final String? checkLabel;

  const QuestionView({
    super.key,
    required this.question,
    required this.lang,
    required this.showFeedback,
    required this.onDone,
    this.onGraded,
    this.wordBank,
    this.checkLabel,
  });

  @override
  ConsumerState<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends ConsumerState<QuestionView> {
  late final Random _rng;
  late final TextEditingController _text;
  int? _choice;
  late final List<int> _shuffledWords; // indices into q.words
  final List<int> _picked = [];
  late final List<int> _rightOrder;
  final Map<int, int> _matches = {};
  int? _selectedLeft;
  late final List<String> _tiles; // translation word bank
  final List<int> _tilePicked = [];
  bool _keyboard = false;
  String _heard = '';
  String? _speechError;
  AnswerResult? _result;
  late final SttService _stt;

  Question get q => widget.question;
  String get lang => widget.lang;

  @override
  void initState() {
    super.initState();
    _rng =
        Random(q.id.codeUnits.fold<int>(7, (a, b) => a * 31 + b) & 0x7fffffff);
    _text = TextEditingController(text: q.type == 'correction' ? q.prompt : '');
    _shuffledWords = List.generate(q.words.length, (i) => i)..shuffle(_rng);
    if (_shuffledWords.length > 1 &&
        List.generate(_shuffledWords.length, (i) => i).join() ==
            _shuffledWords.join()) {
      _shuffledWords.add(_shuffledWords.removeAt(0));
    }
    _rightOrder = List.generate(q.pairs.length, (i) => i)..shuffle(_rng);
    _tiles = _buildTiles();
    _keyboard = q.type == 'translate' && _tiles.isEmpty;
    _stt = ref.read(sttProvider);
  }

  List<String> _buildTiles() {
    if (q.type != 'translate' || widget.wordBank == null || q.answers.isEmpty) {
      return const [];
    }
    final answer =
        q.answers.first.split(' ').where((w) => w.isNotEmpty).toList();
    if (answer.length > 10) return const [];
    final lower = answer.map((w) => w.toLowerCase()).toSet();
    final extras = widget.wordBank!
        .where((w) => w.isNotEmpty && !lower.contains(w.toLowerCase()))
        .toSet()
        .toList()
      ..shuffle(_rng);
    return [...answer, ...extras.take(3)]..shuffle(_rng);
  }

  @override
  void dispose() {
    _text.dispose();
    if (q.isSpeech) _stt.stop();
    super.dispose();
  }

  bool get _canCheck => switch (q.type) {
        'mcq' || 'listening' || 'image' => _choice != null,
        'translate' =>
          _keyboard ? _text.text.trim().isNotEmpty : _tilePicked.isNotEmpty,
        'fill' || 'correction' || 'write' => _text.text.trim().isNotEmpty,
        'order' => _picked.length == _shuffledWords.length,
        'match' => _matches.length == q.pairs.length,
        _ => false,
      };

  void _check() {
    final r = switch (q.type) {
      'mcq' || 'listening' || 'image' => gradeChoice(q, _choice),
      'translate' => gradeText(
          q,
          _keyboard
              ? _text.text
              : [for (final i in _tilePicked) _tiles[i]].join(' '),
          lang),
      'fill' || 'correction' => gradeText(q, _text.text, lang),
      'order' => gradeOrder(
          q, [for (final p in _picked) q.words[_shuffledWords[p]]], lang),
      'match' => gradeMatch(q, _matches),
      'write' => gradeWriting(q, _text.text, lang),
      _ => throw StateError('not checkable'),
    };
    _finish(r);
  }

  void _finish(AnswerResult r) {
    FocusScope.of(context).unfocus();
    if (!r.skipped) {
      r.correct ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact();
    }
    widget.onGraded?.call(r);
    if (!widget.showFeedback) {
      widget.onDone(r);
    } else {
      setState(() => _result = r);
    }
  }

  Future<void> _listen() async {
    setState(() {
      _heard = '';
      _speechError = null;
    });
    try {
      await _stt.listen(
        locale: languages[lang]!.sttLocale,
        onResult: (text, isFinal) {
          if (!mounted) return;
          setState(() => _heard = text);
          if (isFinal) _finish(gradeSpeech(q, text, lang));
        },
      );
    } on SpeechUnavailableException catch (e) {
      if (mounted) setState(() => _speechError = e.message);
    } catch (e) {
      if (mounted) {
        setState(() => _speechError = '$speechUnavailableHelp\n\nDetails: $e');
      }
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final answered = _result != null;
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(_instruction,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 22)),
            const SizedBox(height: 16),
            ..._body(context),
          ]),
        ),
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween(begin: const Offset(0, 0.4), end: Offset.zero)
              .animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: answered
            ? _FeedbackPanel(
                key: const ValueKey('feedback-panel'),
                question: q,
                result: _result!,
                lang: lang,
                onContinue: () => widget.onDone(_result!),
                onRetry: q.isSpeech && !_result!.correct && !_result!.skipped
                    ? () => setState(() => _result = null)
                    : null,
              )
            : _CheckBar(
                key: const ValueKey('check-bar'),
                speech: q.isSpeech,
                label: widget.checkLabel ??
                    (widget.showFeedback ? 'Check' : 'Submit answer'),
                onCheck: _canCheck ? _check : null,
                onSkip: () => _finish(AnswerResult.skipped(q.audio ?? '')),
              ),
      ),
    ]);
  }

  String get _instruction => switch (q.type) {
        'mcq' => 'Choose the correct answer',
        'image' => 'Select the correct picture',
        'listening' => 'What do you hear?',
        'fill' => 'Fill in the blank',
        'translate' => 'Translate this sentence',
        'correction' => 'Fix the mistake',
        'order' => 'Build the sentence',
        'match' => 'Match the pairs',
        'speak' => 'Say this aloud',
        'pronounce' => 'Pronunciation practice',
        'write' => 'Writing task',
        _ => '',
      };

  /// Companion + speech bubble holding the prompt.
  Widget _promptBubble(BuildContext context, String text,
      {String? sub, Widget? trailing}) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const Sylli(size: 72, mood: SylliMood.think),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            border: Border.all(color: cs.outlineVariant),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: t.titleLarge),
                    if (sub != null) ...[
                      const SizedBox(height: 4),
                      Text(sub,
                          style: t.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ]),
            ),
            if (trailing != null) trailing,
          ]),
        ),
      ),
    ]);
  }

  List<Widget> _body(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final locked = _result != null;

    switch (q.type) {
      case 'mcq':
      case 'listening':
        return [
          if (q.type == 'listening')
            Center(child: _AudioButtons(text: q.audio!, lang: lang))
          else
            _promptBubble(context, q.prompt, sub: q.translation),
          if (q.type == 'listening' && q.prompt.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(q.prompt, style: t.titleMedium, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 20),
          for (var i = 0; i < q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
                key: Key('option-$i'),
                text: q.options[i],
                index: i,
                selected: _choice == i,
                state: !locked
                    ? null
                    : (i == q.answer ? true : (i == _choice ? false : null)),
                onTap: locked ? null : () => setState(() => _choice = i),
              ),
            ),
        ];
      case 'image':
        return [
          Text(q.prompt, style: t.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              for (var i = 0; i < q.options.length; i++)
                _ImageOption(
                  key: Key('image-option-$i'),
                  image: q.images[i],
                  label: q.options[i],
                  selected: _choice == i,
                  state: !locked
                      ? null
                      : (i == q.answer ? true : (i == _choice ? false : null)),
                  onTap: locked
                      ? null
                      : () {
                          setState(() => _choice = i);
                          speakSafely(context, ref, q.options[i], lang);
                        },
                ),
            ],
          ),
        ];
      case 'fill':
      case 'correction':
      case 'write':
        return [
          if (q.type == 'correction')
            _promptBubble(context, 'Something is wrong in this sentence.',
                sub: 'Edit it below.')
          else
            _promptBubble(context, q.prompt, sub: q.translation),
          if (q.type == 'write' && q.minWords > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('At least ${q.minWords} words', style: t.bodySmall),
            ),
          const SizedBox(height: 16),
          _field(locked),
        ];
      case 'translate':
        return [
          _promptBubble(context, q.prompt,
              sub: 'Into ${languages[lang]!.name}', trailing: null),
          const SizedBox(height: 16),
          if (_keyboard)
            _field(locked)
          else ...[
            _AnswerLine(
              children: [
                for (var k = 0; k < _tilePicked.length; k++)
                  _WordTile(
                    text: _tiles[_tilePicked[k]],
                    onTap: locked
                        ? null
                        : () => setState(() => _tilePicked.removeAt(k)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
                spacing: 8,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < _tiles.length; i++)
                    _WordTile(
                      key: Key('tile-$i'),
                      text: _tiles[i],
                      used: _tilePicked.contains(i),
                      onTap: locked || _tilePicked.contains(i)
                          ? null
                          : () => setState(() => _tilePicked.add(i)),
                    ),
                ]),
          ],
          if (_tiles.isNotEmpty && !locked)
            Center(
              child: TextButton.icon(
                key: const Key('use-keyboard'),
                onPressed: () => setState(() => _keyboard = !_keyboard),
                icon: Icon(_keyboard
                    ? Icons.grid_view_rounded
                    : Icons.keyboard_rounded),
                label: Text(_keyboard ? 'Use word tiles' : 'Use keyboard'),
              ),
            ),
        ];
      case 'order':
        return [
          _promptBubble(context, q.translation ?? q.prompt,
              sub: q.prompt.isNotEmpty && q.translation != null
                  ? q.prompt
                  : null),
          const SizedBox(height: 16),
          _AnswerLine(children: [
            for (var k = 0; k < _picked.length; k++)
              _WordTile(
                text: q.words[_shuffledWords[_picked[k]]],
                onTap:
                    locked ? null : () => setState(() => _picked.removeAt(k)),
              ),
          ]),
          const SizedBox(height: 16),
          Wrap(
              spacing: 8,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (var p = 0; p < _shuffledWords.length; p++)
                  _WordTile(
                    key: Key('word-$p'),
                    text: q.words[_shuffledWords[p]],
                    used: _picked.contains(p),
                    onTap: locked || _picked.contains(p)
                        ? null
                        : () => setState(() => _picked.add(p)),
                  ),
              ]),
        ];
      case 'match':
        const colors = [
          SyllivoColors.indigo, SyllivoColors.teal, SyllivoColors.coral,
          SyllivoColors.amber, //
          Color(0xFF7C3AED), Color(0xFF0284C7), Color(0xFF65A30D),
          Color(0xFFDB2777),
        ];
        Color? colorForRight(int j) {
          for (final e in _matches.entries) {
            if (e.value == j) return colors[e.key % colors.length];
          }
          return null;
        }

        return [
          if (q.prompt.isNotEmpty) Text(q.prompt, style: t.titleMedium),
          Text('Tap a word on the left, then its match on the right.',
              style: t.bodySmall),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(children: [
                for (var i = 0; i < q.pairs.length; i++)
                  _MatchTile(
                    text: q.pairs[i][0],
                    color: _matches.containsKey(i)
                        ? colors[i % colors.length]
                        : null,
                    selected: _selectedLeft == i,
                    onTap: locked
                        ? null
                        : () => setState(() {
                              _matches.remove(i);
                              _selectedLeft = i;
                            }),
                  ),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(children: [
                for (final j in _rightOrder)
                  _MatchTile(
                    text: q.pairs[j][1],
                    color: colorForRight(j),
                    selected: false,
                    onTap: locked || _selectedLeft == null
                        ? null
                        : () => setState(() {
                              _matches.removeWhere((_, v) => v == j);
                              _matches[_selectedLeft!] = j;
                              _selectedLeft = null;
                            }),
                  ),
              ]),
            ),
          ]),
        ];
      case 'speak':
      case 'pronounce':
        return [
          _promptBubble(context, q.audio!,
              sub: q.translation,
              trailing: SpeakButton(text: q.audio!, lang: lang)),
          if (q.prompt.isNotEmpty && q.prompt != q.audio)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(q.prompt, style: t.bodyMedium),
            ),
          const SizedBox(height: 12),
          Center(child: SpeakButton(text: q.audio!, lang: lang, slow: true)),
          const SizedBox(height: 12),
          if (!locked)
            Center(
              child: ValueListenableBuilder<bool>(
                valueListenable: _stt.listening,
                builder: (_, listening, __) => Column(children: [
                  _MicButton(
                      listening: listening,
                      onTap: listening ? _stt.stop : _listen),
                  const SizedBox(height: 8),
                  Text(
                      listening ? 'Listening…' : 'Tap the microphone and speak',
                      style: t.titleSmall),
                  if (_heard.isNotEmpty) Text('Heard: “$_heard”'),
                ]),
              ),
            ),
          if (_speechError != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: SyllivoColors.errorSoft,
                borderRadius: BorderRadius.circular(SyllivoRadii.card),
              ),
              child: Text(_speechError!,
                  key: const Key('speech-error'),
                  style: const TextStyle(color: SyllivoColors.navy)),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Scores come from your device’s speech recognition and are a practice '
              'guide, not a professional pronunciation assessment.',
              style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ];
      default:
        return [Text('Unsupported question type: ${q.type}')];
    }
  }

  Widget _field(bool locked) => TextField(
        key: const Key('answer-field'),
        controller: _text,
        enabled: !locked,
        minLines: q.type == 'write' ? 4 : 1,
        maxLines: q.type == 'write' ? 10 : 3,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: switch (q.type) {
            'translate' => 'Type in ${languages[lang]!.name}',
            'correction' => 'Edit the sentence',
            'write' => 'Write your answer',
            _ => 'Your answer',
          },
          helperText: q.type == 'write'
              ? '${_text.text.trim().isEmpty ? 0 : _text.text.trim().split(RegExp(r'\s+')).length} words'
              : null,
        ),
      );
}

// ------------------------------------------------------------ pieces

class _CheckBar extends StatelessWidget {
  final bool speech;
  final String label;
  final VoidCallback? onCheck;
  final VoidCallback onSkip;
  const _CheckBar(
      {super.key,
      required this.speech,
      required this.label,
      required this.onCheck,
      required this.onSkip});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant)),
        ),
        child: speech
            ? TextButton(
                onPressed: onSkip,
                child: const Text('Skip — can’t speak right now'))
            : FilledButton(
                key: const Key('check-answer'),
                onPressed: onCheck,
                child: Text(label)),
      );
}

class _FeedbackPanel extends StatelessWidget {
  final Question question;
  final AnswerResult result;
  final String lang;
  final VoidCallback onContinue;
  final VoidCallback? onRetry;

  const _FeedbackPanel({
    super.key,
    required this.question,
    required this.result,
    required this.lang,
    required this.onContinue,
    this.onRetry,
  });

  static const _praise = [
    'Brilliant!',
    'Nicely done!',
    'Spot on!',
    'You got it!',
    'Great work!'
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final q = question;
    final ok = result.correct;
    final isWrite = q.type == 'write';
    final check = isWrite ? checkWriting(q, result.given, lang) : null;
    final skipped = result.skipped;
    final bg = skipped
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : ok
            ? SyllivoColors.successSoft
            : SyllivoColors.errorSoft;
    final fg = skipped
        ? SyllivoColors.navy
        : (ok ? SyllivoColors.success : SyllivoColors.error);
    final title = skipped
        ? 'Skipped — not counted in your score'
        : isWrite
            ? (ok ? 'Looks good!' : 'Not quite there yet')
            : (ok ? 'Correct!' : 'Not quite');

    return Container(
      key: const Key('feedback'),
      width: double.infinity,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.55),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        if (!skipped)
                          Sylli(
                              size: 44,
                              mood: ok ? SylliMood.cheer : SylliMood.sad),
                        if (!skipped) const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: t.titleLarge?.copyWith(
                                        color: fg,
                                        fontWeight: FontWeight.w800)),
                                if (ok && !skipped && !isWrite)
                                  Text(_praise[q.id.length % _praise.length],
                                      style: t.bodyMedium?.copyWith(
                                          color: SyllivoColors.navy)),
                              ]),
                        ),
                        if (result.score != null)
                          Text('${result.score}/100',
                              style: t.titleMedium?.copyWith(
                                  color: fg, fontWeight: FontWeight.w800)),
                      ]),
                      if (q.isSpeech && result.given.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        PronunciationDiffView(
                            marks: diffPronunciation(
                                result.expected, result.given, lang)),
                      ],
                      if (check != null) ...[
                        const SizedBox(height: 8),
                        _CheckLine(check.wordCount >= check.minWords,
                            '${check.wordCount} / ${check.minWords} words'),
                        if (q.keywords.isNotEmpty)
                          _CheckLine(
                              check.missingKeywords.isEmpty,
                              check.missingKeywords.isEmpty
                                  ? 'Uses the target words/structures'
                                  : 'Try to use: ${check.missingKeywords.join(', ')}'),
                        const SizedBox(height: 8),
                        Text('Model answer',
                            style: t.labelLarge
                                ?.copyWith(color: SyllivoColors.navy)),
                        Text(q.sample ?? '',
                            style: t.bodyMedium
                                ?.copyWith(color: SyllivoColors.navy)),
                        const SizedBox(height: 6),
                        Text(
                            'This automatic check looks at length and target words only. It is not a teacher’s grade.',
                            style: t.bodySmall
                                ?.copyWith(color: SyllivoColors.slate)),
                      ] else if (!ok && !skipped && !q.isSpeech) ...[
                        const SizedBox(height: 10),
                        Text('Correct answer:',
                            style: t.labelLarge?.copyWith(color: fg)),
                        Text(result.expected,
                            key: const Key('expected-answer'),
                            style: t.titleMedium
                                ?.copyWith(color: SyllivoColors.navy)),
                      ],
                      if (q.explanation != null) ...[
                        const SizedBox(height: 8),
                        Text(q.explanation!,
                            style: t.bodyMedium
                                ?.copyWith(color: SyllivoColors.navy)),
                      ],
                    ]),
              ),
            ),
            const SizedBox(height: 14),
            Row(children: [
              if (onRetry != null) ...[
                Expanded(
                  child: OutlinedButton(
                      onPressed: onRetry, child: const Text('Try again')),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton(
                  key: const Key('continue'),
                  style: FilledButton.styleFrom(
                    backgroundColor: skipped ? SyllivoColors.indigo : fg,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ]),
          ]),
    );
  }
}

class _AudioButtons extends StatelessWidget {
  final String text;
  final String lang;
  const _AudioButtons({required this.text, required this.lang});

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (context, ref, _) =>
            Row(mainAxisSize: MainAxisSize.min, children: [
          Pressable(
            onTap: () => speakSafely(context, ref, text, lang),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [SyllivoColors.indigo, Color(0xFF6366F1)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: SyllivoColors.indigo.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: const Icon(Icons.volume_up_rounded,
                  color: Colors.white, size: 48, semanticLabel: 'Play audio'),
            ),
          ),
          const SizedBox(width: 16),
          Pressable(
            onTap: () => speakSafely(context, ref, text, lang, slow: true),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: SyllivoColors.lavender,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.slow_motion_video_rounded,
                  color: SyllivoColors.indigo,
                  size: 32,
                  semanticLabel: 'Play slowly'),
            ),
          ),
        ]),
      );
}

class _MicButton extends StatefulWidget {
  final bool listening;
  final VoidCallback onTap;
  const _MicButton({required this.listening, required this.onTap});

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void didUpdateWidget(_MicButton old) {
    super.didUpdateWidget(old);
    if (widget.listening && !_pulse.isAnimating) _pulse.repeat();
    if (!widget.listening) _pulse.stop();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.listening ? SyllivoColors.coral : SyllivoColors.indigo;
    return SizedBox.square(
      dimension: 132,
      child: Stack(alignment: Alignment.center, children: [
        if (widget.listening)
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              width: 92 + 40 * _pulse.value,
              height: 92 + 40 * _pulse.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.25 * (1 - _pulse.value)),
              ),
            ),
          ),
        Semantics(
          button: true,
          label: widget.listening ? 'Stop recording' : 'Start speaking',
          child: Pressable(
            key: const Key('mic'),
            onTap: widget.onTap,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Icon(
                  widget.listening ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 44),
            ),
          ),
        ),
      ]),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final bool selected;
  final bool? state; // true = correct, false = wrong choice
  final VoidCallback? onTap;

  const _OptionTile({
    super.key,
    required this.text,
    required this.index,
    required this.selected,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = switch (state) {
      true => SyllivoColors.success,
      false => SyllivoColors.error,
      null => selected ? SyllivoColors.indigo : cs.outlineVariant,
    };
    final fill = switch (state) {
      true => SyllivoColors.successSoft,
      false => SyllivoColors.errorSoft,
      null => selected ? cs.primaryContainer : cs.surfaceContainerLow,
    };
    return Semantics(
      button: true,
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(SyllivoRadii.button),
            border: Border.all(
                color: border, width: selected || state != null ? 2 : 1.2),
            boxShadow: [
              BoxShadow(
                  color: border.withValues(alpha: selected ? 0.35 : 0.15),
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Row(children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${index + 1}',
                  style: Theme.of(context).textTheme.labelMedium),
            ),
            const SizedBox(width: 12),
            Expanded(
                child:
                    Text(text, style: Theme.of(context).textTheme.bodyLarge)),
            if (state == true)
              const Icon(Icons.check_circle_rounded,
                  color: SyllivoColors.success),
            if (state == false)
              const Icon(Icons.cancel_rounded, color: SyllivoColors.error),
          ]),
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final String image;
  final String label;
  final bool selected;
  final bool? state;
  final VoidCallback? onTap;

  const _ImageOption({
    super.key,
    required this.image,
    required this.label,
    required this.selected,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = switch (state) {
      true => SyllivoColors.success,
      false => SyllivoColors.error,
      null => selected ? SyllivoColors.indigo : cs.outlineVariant,
    };
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(SyllivoRadii.card),
            border: Border.all(
                color: border, width: selected || state != null ? 2.5 : 1.2),
            boxShadow: [
              BoxShadow(
                  color: border.withValues(alpha: 0.2),
                  offset: const Offset(0, 4))
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
                child: LayoutBuilder(
                    builder: (_, c) =>
                        Illustration(image, size: c.biggest.shortestSide))),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall),
          ]),
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  final List<Widget> children;
  const _AnswerLine({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant, width: 2),
          top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Wrap(spacing: 8, runSpacing: 10, children: children),
    );
  }
}

class _WordTile extends StatelessWidget {
  final String text;
  final bool used;
  final VoidCallback? onTap;
  const _WordTile(
      {super.key, required this.text, this.used = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: text,
      child: Pressable(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: used ? 0.25 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant, width: 1.5),
              boxShadow: [
                BoxShadow(color: cs.outlineVariant, offset: const Offset(0, 3))
              ],
            ),
            child: Text(text, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final String text;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;

  const _MatchTile(
      {required this.text,
      required this.color,
      required this.selected,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: color?.withValues(alpha: 0.15) ?? cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: selected
                    ? SyllivoColors.indigo
                    : (color ?? cs.outlineVariant),
                width: selected ? 2.5 : 1.5),
          ),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final bool ok;
  final String text;
  const _CheckLine(this.ok, this.text);

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(ok ? Icons.check_rounded : Icons.close_rounded,
            size: 18, color: ok ? SyllivoColors.success : SyllivoColors.error),
        const SizedBox(width: 6),
        Expanded(
            child:
                Text(text, style: const TextStyle(color: SyllivoColors.navy))),
      ]);
}
