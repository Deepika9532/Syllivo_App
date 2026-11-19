import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../curriculum/curriculum_providers.dart';
import '../gamification/game_providers.dart';
import 'splash_screen.dart';

/// Welcome → language → current level → daily goal → placement or start.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  final _name = TextEditingController();
  int _step = 0;
  String _lang = 'de';
  String? _levelId; // null = not sure
  int _goal = 20;

  static const _steps = 5;

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    super.dispose();
  }

  void _go(int step) {
    setState(() => _step = step);
    _pages.animateToPage(step,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic);
  }

  Future<void> _finish({required bool placement}) async {
    final profile = ref.read(profileProvider.notifier);
    if (_name.text.trim().isNotEmpty) profile.setName(_name.text);
    profile.setDailyGoal(_goal);
    ref.read(languageProvider.notifier).select(_lang);
    final c = await ref.read(curriculumProvider(_lang).future);
    if (!placement && _levelId != null && _levelId != c.levels.first.id) {
      await ref
          .read(databaseProvider)
          .setStartLevel(_lang, _levelId!, ref.read(clockProvider)());
    }
    profile.completeOnboarding();
    if (!mounted) return;
    context.go('/home');
    context
        .push(placement ? '/learn/$_lang/placement' : '/learn/$_lang/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
            child: Row(children: [
              IconButton(
                tooltip: 'Back',
                onPressed: _step == 0 ? null : () => _go(_step - 1),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                  child: AnimatedBar(
                      value: (_step + 1) / _steps, color: SyllivoColors.teal)),
            ]),
          ),
          Expanded(
            child: PageView(
              controller: _pages,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _welcome(t),
                _language(t),
                _level(t),
                _goalPage(t),
                _start(t),
              ],
            ),
          ),
          if (_step < _steps - 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('onboard-next'),
                  onPressed: () => _go(_step + 1),
                  child: Text(_step == 0 ? 'Get started' : 'Continue'),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _page(
          {required String title,
          String? subtitle,
          SylliMood mood = SylliMood.happy,
          required List<Widget> children}) =>
      ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), children: [
        SylliSays(title, mood: mood, size: 72),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 4),
            child:
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ),
        const SizedBox(height: 20),
        ...children,
      ]);

  Widget _welcome(TextTheme t) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 24),
        const Center(child: Sylli(size: 170, mood: SylliMood.wave)),
        const SizedBox(height: 20),
        const Center(child: SyllivoLogo(size: 40, showMascot: false)),
        const SizedBox(height: 6),
        Text(syllivoTagline, textAlign: TextAlign.center, style: t.titleMedium),
        const SizedBox(height: 24),
        Text(
            'Hi, I’m Sylli! I’ll learn with you — German or Korean, one small step a day, '
            'fully offline.',
            textAlign: TextAlign.center,
            style: t.bodyLarge),
        const SizedBox(height: 24),
        TextField(
          key: const Key('name-field'),
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'What should I call you? (optional)',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
      ]);

  Widget _language(TextTheme t) => _page(
        title: 'Which language would you like to learn?',
        subtitle: 'You can learn both — switch any time from Home or Profile.',
        children: [
          for (final l in languages.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ChoiceCard(
                key: Key('lang-option-${l.code}'),
                selected: _lang == l.code,
                leading: _LangBadge(l.code),
                title: '${l.name} – ${l.nativeName}',
                subtitle: l.code == 'de'
                    ? 'CEFR A1 – C2 · from Beginner to Proficient'
                    : 'Levels 1 – 6 · TOPIK I & II aligned, with speaking practice',
                onTap: () => setState(() {
                  _lang = l.code;
                  _levelId = null;
                }),
              ),
            ),
        ],
      );

  Widget _level(TextTheme t) {
    final c = ref.watch(curriculumProvider(_lang));
    return _page(
      title: 'How much ${languages[_lang]!.name} do you know?',
      subtitle:
          'Choosing a level unlocks it and the levels before it. Not sure? Take the placement test at the end.',
      mood: SylliMood.think,
      children: c.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (e, _) => [Text('$e')],
        data: (cur) => [
          _ChoiceCard(
            key: const Key('level-option-unsure'),
            selected: _levelId == null,
            leading: const Icon(Icons.help_outline_rounded, size: 32),
            title: 'I’m not sure',
            subtitle:
                'Take the placement test at the end to get a recommended starting level',
            onTap: () => setState(() => _levelId = null),
          ),
          const SizedBox(height: 10),
          for (final l in cur.levels)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChoiceCard(
                key: Key('level-option-${l.id}'),
                selected: _levelId == l.id,
                leading: CircleAvatar(
                  backgroundColor: SyllivoColors.forLang(_lang).first,
                  foregroundColor: Colors.white,
                  child: Text(l.code),
                ),
                title: '${l.code} – ${l.title}',
                subtitle: l.description,
                onTap: () => setState(() => _levelId = l.id),
              ),
            ),
        ],
      ),
    );
  }

  Widget _goalPage(TextTheme t) => _page(
        title: 'Pick a daily goal',
        subtitle:
            'XP comes from lessons, reviews and exams. You can change this in Profile.',
        children: [
          for (final g in dailyGoalOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChoiceCard(
                key: Key('goal-${g.xp}'),
                selected: _goal == g.xp,
                leading: const Icon(Icons.bolt_rounded,
                    color: SyllivoColors.amber, size: 32),
                title: '${g.label} · ${g.xp} XP',
                subtitle: g.detail,
                onTap: () => setState(() => _goal = g.xp),
              ),
            ),
        ],
      );

  Widget _start(TextTheme t) {
    final c = ref.watch(curriculumProvider(_lang)).valueOrNull;
    final chosen = _levelId == null ? null : c?.level(_levelId!);
    return _page(
      title: 'Great! How would you like to start?',
      mood: SylliMood.cheer,
      children: [
        _ChoiceCard(
          key: const Key('start-placement-onboarding'),
          selected: false,
          leading: const Icon(Icons.explore_rounded,
              color: SyllivoColors.teal, size: 32),
          title: 'Take the placement test',
          subtitle:
              '3 questions per level · stops when it gets too hard · 2–10 minutes',
          onTap: () => _finish(placement: true),
        ),
        const SizedBox(height: 12),
        _ChoiceCard(
          key: const Key('start-beginner'),
          selected: false,
          leading: const Icon(Icons.play_circle_rounded,
              color: SyllivoColors.indigo, size: 32),
          title: chosen == null
              ? 'Start as a beginner'
              : 'Start at ${chosen.code} · ${chosen.title}',
          subtitle: chosen == null
              ? 'Begin with the very first lesson'
              : 'Earlier levels stay open for review',
          onTap: () => _finish(placement: false),
        ),
      ],
    );
  }
}

class _LangBadge extends StatelessWidget {
  final String lang;
  const _LangBadge(this.lang);

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: SyllivoColors.forLang(lang).first.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(languages[lang]!.flag,
            semanticsLabel: '${languages[lang]!.name} flag',
            style: const TextStyle(fontSize: 28)),
      );
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    super.key,
    required this.selected,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(SyllivoRadii.card),
            border: Border.all(
                color: selected ? SyllivoColors.indigo : cs.outlineVariant,
                width: selected ? 2 : 1),
          ),
          child: Row(children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: SyllivoColors.indigo),
          ]),
        ),
      ),
    );
  }
}
