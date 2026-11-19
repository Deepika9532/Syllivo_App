import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/lang.dart';
import '../../core/providers.dart';
import 'achievements.dart';
import 'activity_heatmap.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final stats = ref.watch(statsProvider(lang));

    return Scaffold(
      appBar: AppBar(title: Text('Progress · ${languages[lang]!.name}')),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load stats: $e')),
        data: (s) => ListView(padding: const EdgeInsets.all(16), children: [
          Row(children: [
            _StatTile(label: 'Day streak', value: '🔥 ${s.streak}'),
            _StatTile(label: 'Learned', value: '${s.learnedCards}'),
            _StatTile(label: 'Total cards', value: '${s.totalCards}'),
          ]),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                            'Today: ${s.reviewedToday} / ${s.dailyGoal} reviews',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      IconButton(
                        tooltip: 'Change daily goal',
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _editGoal(context, ref, lang, s.dailyGoal),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: min(1, s.reviewedToday / max(1, s.dailyGoal)),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last 7 days',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _WeekChart(days: s.last7Days),
                  ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ActivityHeatmap(
                  activity: s.activity, today: ref.read(clockProvider)()),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AchievementsGrid(stats: s),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.record_voice_over),
              title: const Text('Average pronunciation score'),
              trailing: Text(
                s.avgPronunciation == null
                    ? '—'
                    : s.avgPronunciation!.round().toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _editGoal(
      BuildContext context, WidgetRef ref, String lang, int current) async {
    var value = current.toDouble();
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Daily review goal'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${value.round()} reviews per day'),
            Slider(
              value: value,
              min: 10,
              max: 100,
              divisions: 9,
              onChanged: (v) => setState(() => value = v),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, value.round()),
                child: const Text('Save')),
          ],
        ),
      ),
    );
    if (result != null) {
      await ref.read(databaseProvider).setDailyGoal(result);
      ref.invalidate(statsProvider(lang));
    }
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ),
      );
}

class _WeekChart extends StatelessWidget {
  final List<({DateTime day, int count})> days;
  const _WeekChart({required this.days});

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxCount = max(1, days.map((d) => d.count).fold(0, max));
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days
            .map((d) => Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${d.count}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Container(
                          height: max(4, 100 * d.count / maxCount),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: d.count == 0
                                ? color.withValues(alpha: 0.2)
                                : color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(labels[d.day.weekday - 1]),
                      ]),
                ))
            .toList(),
      ),
    );
  }
}
