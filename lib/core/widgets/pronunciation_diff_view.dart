import 'package:flutter/material.dart';

import '../speech/pronunciation_diff.dart';

/// Highlights each letter/syllable: green = correct, red = wrong,
/// grey underlined = not heard.
class PronunciationDiffView extends StatelessWidget {
  final List<CharMark> marks;
  const PronunciationDiffView({super.key, required this.marks});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = Theme.of(context).textTheme.headlineMedium!;
    const green = Color(0xFF2E7D32);

    TextStyle styleFor(MarkStatus s) => switch (s) {
          MarkStatus.correct =>
            base.copyWith(color: green, fontWeight: FontWeight.w600),
          MarkStatus.wrong => base.copyWith(
              color: cs.error,
              fontWeight: FontWeight.w700,
              backgroundColor: cs.errorContainer),
          MarkStatus.missing => base.copyWith(
              color: cs.outline,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted),
          MarkStatus.neutral => base,
        };

    Widget legend(Color c, String label) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ]);

    return Column(children: [
      Text.rich(
        key: const Key('pronunciation-diff'),
        TextSpan(children: [
          for (final m in marks)
            TextSpan(text: m.text, style: styleFor(m.status))
        ]),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 12, alignment: WrapAlignment.center, children: [
        legend(green, 'correct'),
        legend(cs.error, 'mispronounced'),
        legend(cs.outline, 'not heard'),
      ]),
    ]);
  }
}
