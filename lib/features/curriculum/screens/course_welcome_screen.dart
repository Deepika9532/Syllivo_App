import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/lang.dart';
import '../../../core/widgets/companion.dart';
import '../../../core/widgets/syllivo_widgets.dart';
import '../curriculum_providers.dart';

/// Shown after choosing a starting level: the first course the learner
/// will take, with a button straight into it.
class CourseWelcomeScreen extends ConsumerWidget {
  final String lang;
  const CourseWelcomeScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final info = languages[lang]!;
    final state = ref.watch(learnStateProvider(lang));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load the course: $e')),
          data: (s) {
            final next = s.nextLesson;
            final module =
                next == null ? null : s.curriculum.moduleOfLesson(next.id);
            final level = next == null
                ? s.currentLevel
                : s.curriculum.levelOfLesson(next.id)!;
            return ListView(padding: const EdgeInsets.all(24), children: [
              const SizedBox(height: 8),
              const Center(child: Sylli(size: 150, mood: SylliMood.cheer)),
              const SizedBox(height: 16),
              Text('Welcome to your course!',
                  style: t.titleMedium?.copyWith(color: SyllivoColors.indigo),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(next?.title ?? '${level.code} examination',
                  key: const Key('welcome-course-title'),
                  style: t.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                '${info.name} · ${level.code} ${level.title}'
                '${module == null ? '' : ' · ${module.type.label}'}',
                key: const Key('welcome-course-meta'),
                style: t.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(next?.summary ?? level.description,
                  style: t.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              AnimatedBar(value: s.progressOf(level), height: 8),
              const SizedBox(height: 6),
              Text(
                  '${(s.progressOf(level) * 100).round()}% of ${level.code} complete',
                  style: t.bodySmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 28),
              FilledButton.icon(
                key: const Key('welcome-continue'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56)),
                onPressed: () => context.pushReplacement(next == null
                    ? '/learn/$lang/exam/${level.id}'
                    : '/learn/$lang/lesson/${next.id}'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Continue learning'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go to Home'),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
