import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/speak.dart';
import '../../../core/widgets/syllivo_widgets.dart';
import '../models.dart';

/// Renders the learning material of a lesson (before practice).
class ContentBlockView extends StatelessWidget {
  final ContentBlock block;
  final String lang;
  final bool showRomanization;

  /// Vocabulary lessons show words as swipeable cards.
  final bool vocabAsCards;

  /// Grammar lessons render tips as highlighted rules.
  final bool rules;

  /// Level vocabulary (target → English) highlighted in reading passages.
  final Map<String, String> glossary;

  const ContentBlockView({
    super.key,
    required this.block,
    required this.lang,
    required this.showRomanization,
    this.vocabAsCards = false,
    this.rules = false,
    this.glossary = const {},
  });

  /// German pronunciation guides always show; Korean romanization follows
  /// the learner's setting so it never replaces reading Hangul.
  String? _pron(String? p) =>
      p == null || (lang == 'ko' && !showRomanization) ? null : p;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    switch (block.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(block.str('text') ?? '', style: t.bodyLarge),
        );
      case 'heading':
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(block.str('text') ?? '', style: t.titleLarge),
        );
      case 'tip' when rules:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border(left: BorderSide(color: cs.primary, width: 5)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.rule_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 6),
              Text('RULE',
                  style: t.labelMedium?.copyWith(
                      color: cs.primary,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            Text(block.str('text') ?? '',
                style: t.bodyLarge?.copyWith(color: cs.onPrimaryContainer)),
          ]),
        );
      case 'tip':
        return Card(
          color: cs.tertiaryContainer,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lightbulb_outline, color: cs.onTertiaryContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(block.str('text') ?? '',
                    style:
                        t.bodyMedium?.copyWith(color: cs.onTertiaryContainer)),
              ),
            ]),
          ),
        );
      case 'example':
        return _TargetLine(
          target: block.str('target')!,
          en: block.str('en'),
          pron: _pron(block.str('pron')),
          note: block.str('note'),
          lang: lang,
        );
      case 'vocab' when vocabAsCards:
        return WordCardPager(
          lang: lang,
          showRomanization: showRomanization,
          items: [
            for (final raw in block.list('items'))
              (raw as Map).cast<String, dynamic>()
          ],
        );
      case 'vocab':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: [
            for (final raw in block.list('items'))
              _TargetLine(
                target: (raw as Map)['target'] as String,
                en: raw['en'] as String?,
                pron: _pron(raw['pron'] as String?),
                note: raw['example'] as String?,
                lang: lang,
                dense: true,
              ),
          ]),
        );
      case 'table':
        final head = block.list('head').cast<String>();
        final rows =
            block.list('rows').map((r) => (r as List).cast<String>()).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 36,
              dataRowMaxHeight: 52,
              columns: [for (final h in head) DataColumn(label: Text(h))],
              rows: [
                for (final r in rows)
                  DataRow(cells: [for (final c in r) DataCell(Text(c))]),
              ],
            ),
          ),
        );
      case 'dialogue':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: [
              if (block.str('title') != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(block.str('title')!, style: t.titleMedium)),
                ),
              for (final raw in block.list('lines'))
                ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    child: Text(
                        ((raw as Map)['speaker'] as String).substring(0, 1)),
                  ),
                  title: Text(raw['target'] as String, style: t.titleMedium),
                  subtitle: Text([
                    if (_pron(raw['pron'] as String?) != null) raw['pron'],
                    raw['en'],
                  ].join('\n')),
                  trailing:
                      SpeakButton(text: raw['target'] as String, lang: lang),
                ),
            ]),
          ),
        );
      case 'passage':
        return _Passage(block: block, lang: lang, glossary: glossary);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TargetLine extends StatelessWidget {
  final String target;
  final String? en;
  final String? pron;
  final String? note;
  final String lang;
  final bool dense;

  const _TargetLine({
    required this.target,
    required this.en,
    required this.pron,
    required this.note,
    required this.lang,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dense ? 12 : 0, vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(target,
                style: (dense ? t.titleMedium : t.titleLarge)
                    ?.copyWith(fontWeight: FontWeight.w600)),
            if (pron != null)
              Text('/$pron/', style: t.bodyMedium?.copyWith(color: cs.primary)),
            if (en != null) Text(en!, style: t.bodyMedium),
            if (note != null)
              Text(note!,
                  style: t.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
          ]),
        ),
        SpeakButton(text: target, lang: lang),
      ]),
    );
  }
}

class _Passage extends StatefulWidget {
  final ContentBlock block;
  final String lang;
  final Map<String, String> glossary;
  const _Passage(
      {required this.block, required this.lang, required this.glossary});

  @override
  State<_Passage> createState() => _PassageState();
}

class _PassageState extends State<_Passage> {
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final b = widget.block;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(b.str('title') ?? 'Text', style: t.titleMedium)),
            SpeakButton(text: b.str('target')!, lang: widget.lang),
            SpeakButton(text: b.str('target')!, lang: widget.lang, slow: true),
          ]),
          const SizedBox(height: 8),
          HighlightedPassage(
              text: b.str('target')!,
              lang: widget.lang,
              glossary: widget.glossary),
          if (widget.glossary.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Tap a highlighted word to see its meaning.',
                  style: t.bodySmall),
            ),
          if (b.str('en') != null) ...[
            TextButton.icon(
              onPressed: () =>
                  setState(() => _showTranslation = !_showTranslation),
              icon: Icon(
                  _showTranslation ? Icons.visibility_off : Icons.translate),
              label: Text(
                  _showTranslation ? 'Hide translation' : 'Show translation'),
            ),
            if (_showTranslation)
              Text(b.str('en')!,
                  style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
          ],
        ]),
      ),
    );
  }
}

/// Reading text with level vocabulary highlighted; tap a word for its
/// meaning and pronunciation.
class HighlightedPassage extends StatelessWidget {
  final String text;
  final String lang;
  final Map<String, String> glossary;
  const HighlightedPassage(
      {super.key,
      required this.text,
      required this.lang,
      required this.glossary});

  static final _punct = RegExp(r'[^\p{L}\p{N}]', unicode: true);

  /// Finds the glossary entry for a token. Korean words often carry
  /// particles (책을), so a Korean token matches an entry it starts with.
  MapEntry<String, String>? _match(String token) {
    final clean = token.replaceAll(_punct, '').toLowerCase();
    if (clean.isEmpty) return null;
    MapEntry<String, String>? best;
    for (final e in glossary.entries) {
      final key = e.key.toLowerCase();
      final words = key.split(' ');
      final last = words.last.replaceAll(_punct, '');
      final ok = lang == 'ko'
          ? (last.isNotEmpty &&
              clean.startsWith(last) &&
              clean.length <= last.length + 2)
          : clean == last;
      if (ok && (best == null || e.key.length > best.key.length)) best = e;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6);
    final cs = Theme.of(context).colorScheme;
    if (glossary.isEmpty) return Text(text, style: t);
    final tokens = text.split(' ');
    return Text.rich(
      TextSpan(style: t, children: [
        for (var i = 0; i < tokens.length; i++) ...[
          if (_match(tokens[i]) case final m?)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Consumer(
                builder: (context, ref, _) => GestureDetector(
                  onTap: () {
                    speakSafely(context, ref, m.key, lang);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text('${m.key} — ${m.value}')));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                          bottom: BorderSide(color: cs.primary, width: 2)),
                    ),
                    child: Text(tokens[i], style: t?.copyWith(height: 1.3)),
                  ),
                ),
              ),
            )
          else
            TextSpan(text: tokens[i]),
          if (i < tokens.length - 1) const TextSpan(text: ' '),
        ],
      ]),
    );
  }
}

final bookmarksProvider = StreamProvider.autoDispose
    .family<Set<String>, String>((ref, lang) => ref
        .watch(databaseProvider)
        .watchBookmarks(lang)
        .map((l) => {for (final b in l) b.target}));

/// Vocabulary as one word per card, with audio, example, bookmark and
/// previous/next navigation.
class WordCardPager extends ConsumerStatefulWidget {
  final String lang;
  final bool showRomanization;
  final List<Map<String, dynamic>> items;
  const WordCardPager(
      {super.key,
      required this.lang,
      required this.showRomanization,
      required this.items});

  @override
  ConsumerState<WordCardPager> createState() => _WordCardPagerState();
}

class _WordCardPagerState extends ConsumerState<WordCardPager> {
  final _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int i) => _pages.animateToPage(i,
      duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final saved =
        ref.watch(bookmarksProvider(widget.lang)).valueOrNull ?? const {};
    final n = widget.items.length;
    return Column(children: [
      const SizedBox(height: 8),
      Row(children: [
        Text('Word ${_index + 1} of $n',
            key: const Key('word-card-counter'), style: t.labelLarge),
        const SizedBox(width: 12),
        Expanded(child: AnimatedBar(value: (_index + 1) / n, height: 8)),
      ]),
      const SizedBox(height: 12),
      SizedBox(
        height: 300,
        child: PageView.builder(
          controller: _pages,
          itemCount: n,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) {
            final w = widget.items[i];
            final target = w['target'] as String;
            final pron = w['pron'] as String?;
            final showPron = pron != null &&
                (widget.lang != 'ko' || widget.showRomanization);
            final isSaved = saved.contains(target);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        key: Key('bookmark-$target'),
                        tooltip:
                            isSaved ? 'Remove from saved words' : 'Save word',
                        icon: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: isSaved ? cs.primary : null),
                        onPressed: () async {
                          final now =
                              await ref.read(databaseProvider).toggleBookmark(
                                    lang: widget.lang,
                                    target: target,
                                    en: w['en'] as String,
                                    pron: pron,
                                    example: w['example'] as String?,
                                    now: ref.read(clockProvider)(),
                                  );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text(now
                                      ? 'Saved “$target” to your word list.'
                                      : 'Removed “$target”.')));
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                    Text(target,
                        textAlign: TextAlign.center,
                        style: t.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    if (showPron)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('/$pron/',
                            style: t.titleMedium?.copyWith(color: cs.primary)),
                      ),
                    const SizedBox(height: 8),
                    Text(w['en'] as String,
                        textAlign: TextAlign.center,
                        style:
                            t.titleLarge?.copyWith(color: cs.onSurfaceVariant)),
                    if (w['example'] != null) ...[
                      const SizedBox(height: 10),
                      Text(w['example'] as String,
                          textAlign: TextAlign.center,
                          style: t.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic)),
                    ],
                    const Spacer(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SpeakButton(
                          text: (w['audio'] ?? target) as String,
                          lang: widget.lang,
                          size: 30),
                      SpeakButton(
                          text: (w['audio'] ?? target) as String,
                          lang: widget.lang,
                          slow: true,
                          size: 26),
                    ]),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            key: const Key('word-card-prev'),
            onPressed: _index == 0 ? null : () => _go(_index - 1),
            icon: const Icon(Icons.chevron_left_rounded),
            label: const Text('Previous'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            key: const Key('word-card-next'),
            onPressed: _index >= n - 1 ? null : () => _go(_index + 1),
            icon: const Icon(Icons.chevron_right_rounded),
            label: const Text('Next'),
          ),
        ),
      ]),
      const SizedBox(height: 8),
    ]);
  }
}
