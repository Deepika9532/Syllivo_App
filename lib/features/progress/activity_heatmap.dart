import 'package:flutter/material.dart';

/// GitHub-style contribution grid: one column per week, Monday at the top.
class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> activity;
  final DateTime today;
  final int weeks;

  const ActivityHeatmap({
    super.key,
    required this.activity,
    required this.today,
    this.weeks = 18,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final day0 = DateTime(today.year, today.month, today.day);
    // Start on the Monday `weeks - 1` weeks before this week's Monday.
    final start = DateTime(
        day0.year, day0.month, day0.day - (day0.weekday - 1) - 7 * (weeks - 1));
    final maxCount = activity.values.fold<int>(1, (a, b) => a > b ? a : b);

    Color colorFor(int n) {
      if (n == 0) return cs.surfaceContainerHighest;
      final level = (n / maxCount * 4).ceil().clamp(1, 4);
      return Color.lerp(cs.primaryContainer, cs.primary, (level - 1) / 3)!;
    }

    final active = activity.values.where((n) => n > 0).length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Activity · $active active days', style: t.titleMedium),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (context, c) {
        final cell = ((c.maxWidth - 24) / weeks - 3).clamp(6.0, 16.0);
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              for (final l in const ['M', '', 'W', '', 'F', '', ''])
                SizedBox(
                  width: 20,
                  height: cell + 3,
                  child: Text(l, style: t.labelSmall),
                ),
            ],
          ),
          for (var w = 0; w < weeks; w++)
            Column(children: [
              for (var d = 0; d < 7; d++)
                Builder(builder: (_) {
                  final date =
                      DateTime(start.year, start.month, start.day + w * 7 + d);
                  final future = date.isAfter(day0);
                  final n = activity[date] ?? 0;
                  return Tooltip(
                    message: future ? '' : '${date.day}/${date.month}: $n',
                    child: Container(
                      width: cell,
                      height: cell,
                      margin: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: future ? Colors.transparent : colorFor(n),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
            ]),
        ]);
      }),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text('Less ', style: t.labelSmall),
        for (final n in [0, 1, maxCount ~/ 2 + 1, maxCount])
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
                color: colorFor(n), borderRadius: BorderRadius.circular(2)),
          ),
        Text(' More', style: t.labelSmall),
      ]),
    ]);
  }
}
