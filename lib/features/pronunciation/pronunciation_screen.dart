import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/speech/pronunciation_diff.dart';
import '../../core/speech/pronunciation_scorer.dart';
import '../../core/speech/stt_service.dart';
import '../../core/widgets/pronunciation_diff_view.dart';

class PronunciationScreen extends ConsumerStatefulWidget {
  final String lessonId;
  const PronunciationScreen({super.key, required this.lessonId});

  @override
  ConsumerState<PronunciationScreen> createState() =>
      _PronunciationScreenState();
}

class _PronunciationScreenState extends ConsumerState<PronunciationScreen> {
  final _page = PageController();
  late final SttService _stt;
  int _index = 0;
  String _heard = '';
  PronunciationResult? _result;
  bool _slow = false;

  @override
  void initState() {
    super.initState();
    _stt = ref.read(sttProvider);
  }

  @override
  void dispose() {
    _stt.stop();
    _page.dispose();
    super.dispose();
  }

  void _reset() => setState(() {
        _heard = '';
        _result = null;
      });

  Future<void> _listen(FlashCard card, String lang) async {
    _reset();
    try {
      await _stt.listen(
        locale: languages[lang]!.sttLocale,
        onResult: (text, isFinal) {
          if (!mounted) return;
          setState(() => _heard = text);
          if (isFinal) _score(card, lang, text);
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _score(FlashCard card, String lang, String text) async {
    final r = PronunciationScorer.score(
        expected: card.audioText, heard: text, lang: lang);
    setState(() => _result = r);
    await ref
        .read(databaseProvider)
        .addPronunciationAttempt(card.id, text, r.score, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final lesson = ref.watch(lessonProvider(widget.lessonId)).valueOrNull;
    final cards = ref.watch(lessonCardsProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson == null ? 'Speaking' : 'Speaking · ${lesson.title}'),
        actions: [
          IconButton(
            tooltip: _slow ? 'Normal speed' : 'Slow speed',
            icon: Icon(_slow ? Icons.slow_motion_video : Icons.speed),
            onPressed: () => setState(() => _slow = !_slow),
          ),
        ],
      ),
      body: lesson == null
          ? const Center(child: CircularProgressIndicator())
          : cards.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load cards: $e')),
              data: (list) => Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text('${_index + 1} / ${list.length}'),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _page,
                    itemCount: list.length,
                    onPageChanged: (i) {
                      _stt.stop();
                      setState(() => _index = i);
                      _reset();
                    },
                    itemBuilder: (_, i) =>
                        _practicePage(list[i], lesson.langCode),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _index == 0
                              ? null
                              : () => _page.previousPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut),
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Previous'),
                        ),
                        TextButton.icon(
                          onPressed: _index >= list.length - 1
                              ? null
                              : () => _page.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut),
                          icon: const Icon(Icons.chevron_right),
                          label: const Text('Next'),
                        ),
                      ]),
                ),
              ]),
            ),
    );
  }

  Widget _practicePage(FlashCard card, String lang) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final r = _result;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text(card.front, style: t.displaySmall, textAlign: TextAlign.center),
        if (card.romanization != null)
          Text(card.romanization!, style: t.titleMedium),
        const SizedBox(height: 4),
        Text(card.back, style: t.bodyLarge),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => ref
              .read(ttsProvider)
              .speak(card.audioText, lang, rate: _slow ? 0.3 : 0.45),
          icon: const Icon(Icons.volume_up),
          label: const Text('Listen'),
        ),
        const SizedBox(height: 32),
        ValueListenableBuilder<bool>(
          valueListenable: _stt.listening,
          builder: (_, listening, __) => Column(children: [
            SizedBox(
              width: 96,
              height: 96,
              child: IconButton.filled(
                iconSize: 48,
                style: IconButton.styleFrom(
                    backgroundColor: listening ? cs.error : cs.primary),
                icon: Icon(listening ? Icons.stop : Icons.mic),
                onPressed: () => listening ? _stt.stop() : _listen(card, lang),
              ),
            ),
            const SizedBox(height: 8),
            Text(listening ? 'Listening…' : 'Tap the mic and say it'),
          ]),
        ),
        const SizedBox(height: 24),
        if (_heard.isNotEmpty) Text('Heard: “$_heard”', style: t.titleMedium),
        if (r != null) ...[
          const SizedBox(height: 16),
          Card(
            color: r.score >= 70 ? cs.primaryContainer : cs.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Text('${r.score}', style: t.displayMedium),
                Text(r.feedback, style: t.titleMedium),
              ]),
            ),
          ),
          if (_heard.isNotEmpty) ...[
            const SizedBox(height: 16),
            PronunciationDiffView(
                marks: diffPronunciation(card.audioText, _heard, lang)),
          ],
        ],
      ]),
    );
  }
}
