import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';

class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;
  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId)).valueOrNull;
    final cards = ref.watch(lessonCardsProvider(lessonId));

    return Scaffold(
      appBar: AppBar(title: Text(lesson?.title ?? 'Lesson')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pronounce/$lessonId'),
        icon: const Icon(Icons.mic),
        label: const Text('Practise speaking'),
      ),
      body: cards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load cards: $e')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final c = list[i];
            return ListTile(
              title:
                  Text(c.front, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text([
                if (c.romanization != null) c.romanization!,
                c.back,
                if (c.example != null) '“${c.example}”',
              ].join('\n')),
              isThreeLine: c.example != null || c.romanization != null,
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: 'Listen',
                onPressed: lesson == null
                    ? null
                    : () => ref
                        .read(ttsProvider)
                        .speak(c.audioText, lesson.langCode),
              ),
            );
          },
        ),
      ),
    );
  }
}
