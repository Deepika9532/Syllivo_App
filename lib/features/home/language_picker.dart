import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../curriculum/curriculum_providers.dart';

/// Flag + language badge used across the app.
class LanguageFlag extends StatelessWidget {
  final String lang;
  final double size;
  const LanguageFlag(this.lang, {super.key, this.size = 44});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(size * 0.3),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Text(languages[lang]!.flag,
            style: TextStyle(fontSize: size * 0.55)),
      );
}

/// Bottom sheet to switch the active language, with level and progress.
Future<void> showLanguagePicker(BuildContext context) => showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const _LanguagePicker(),
    );

class _LanguagePicker extends ConsumerWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(languageProvider);
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Choose a language', style: t.titleLarge),
              const SizedBox(height: 4),
              Text('Your progress in each language is kept separately.',
                  style: t.bodySmall),
              const SizedBox(height: 16),
              for (final l in languages.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LanguageCard(
                    lang: l.code,
                    selected: l.code == active,
                    onTap: () {
                      ref.read(languageProvider.notifier).select(l.code);
                      Navigator.pop(context);
                    },
                  ),
                ),
            ]),
      ),
    );
  }
}

class LanguageCard extends ConsumerWidget {
  final String lang;
  final bool selected;
  final VoidCallback onTap;
  const LanguageCard(
      {super.key,
      required this.lang,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(learnStateProvider(lang)).valueOrNull;
    final info = languages[lang]!;
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '${info.name}${selected ? ', selected' : ''}',
      child: Pressable(
        key: Key('pick-$lang'),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(SyllivoRadii.card),
            border: Border.all(
                color: selected ? cs.primary : cs.outlineVariant,
                width: selected ? 2 : 1),
          ),
          child: Row(children: [
            LanguageFlag(lang, size: 52),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                          child: Text(info.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleMedium)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(info.nativeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                        s == null
                            ? 'Loading…'
                            : 'Level ${s.currentLevel.code} · ${s.currentLevel.title}',
                        style: t.bodySmall),
                    const SizedBox(height: 8),
                    AnimatedBar(value: s?.overall ?? 0, height: 6),
                  ]),
            ),
            const SizedBox(width: 12),
            Text(s == null ? '' : '${(s.overall * 100).round()}%',
                style: t.titleMedium),
            if (selected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: cs.primary),
            ],
          ]),
        ),
      ),
    );
  }
}
