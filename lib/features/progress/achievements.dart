import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int Function(ProgressStats s) current;
  final int target;

  const Achievement(this.id, this.title, this.description, this.icon,
      this.current, this.target);

  bool unlocked(ProgressStats s) => current(s) >= target;
  double progress(ProgressStats s) =>
      (current(s) / target).clamp(0, 1).toDouble();
}

final achievements = <Achievement>[
  Achievement('first', 'First Steps', 'Complete your first review', Icons.flag,
      (s) => s.totalReviews, 1),
  Achievement('words10', 'Word Collector', 'Learn 10 words', Icons.style,
      (s) => s.learnedCards, 10),
  Achievement('words50', 'Vocabulary Builder', 'Learn 50 words',
      Icons.auto_stories, (s) => s.learnedCards, 50),
  Achievement('words150', 'Polyglot in Training', 'Learn 150 words',
      Icons.school, (s) => s.learnedCards, 150),
  Achievement('streak3', 'On a Roll', 'Practise 3 days in a row',
      Icons.local_fire_department, (s) => s.longestStreakDays, 3),
  Achievement('streak7', 'Week Warrior', 'Practise 7 days in a row',
      Icons.whatshot, (s) => s.longestStreakDays, 7),
  Achievement('streak30', 'Unstoppable', 'Practise 30 days in a row',
      Icons.emoji_events, (s) => s.longestStreakDays, 30),
  Achievement('reviews100', 'Centurion', 'Do 100 reviews', Icons.repeat,
      (s) => s.totalReviews, 100),
  Achievement('voice1', 'Clear Voice', 'Score 90+ on a pronunciation',
      Icons.record_voice_over, (s) => s.perfectPronunciations, 1),
  Achievement('voice25', 'Native-like', 'Score 90+ on 25 pronunciations',
      Icons.mic, (s) => s.perfectPronunciations, 25),
];

class AchievementsGrid extends StatelessWidget {
  final ProgressStats stats;
  const AchievementsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final unlocked = achievements.where((a) => a.unlocked(stats)).length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Achievements · $unlocked / ${achievements.length}',
          style: t.titleMedium),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.9,
        children: [
          for (final a in achievements)
            Container(
              key: Key('achievement-${a.id}'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: a.unlocked(stats)
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(a.unlocked(stats) ? a.icon : Icons.lock_outline,
                          size: 20,
                          color: a.unlocked(stats) ? cs.primary : cs.outline),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(a.title,
                            style: t.labelLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(a.description,
                          style: t.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    LinearProgressIndicator(
                      value: a.progress(stats),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ]),
            ),
        ],
      ),
    ]);
  }
}
