import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/lang.dart';
import '../../core/providers.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final lessons = ref.watch(lessonsProvider(lang));

    return Scaffold(
      appBar: AppBar(title: Text('${languages[lang]!.name} lessons')),
      body: lessons.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load lessons: $e')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final l = list[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(l.title),
                subtitle: Text(l.level),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/lesson/${l.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
