import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'game.dart';
import 'game_providers.dart';

/// Original avatar set: gradient discs with a glyph.
const avatarStyles = <(List<Color>, IconData)>[
  ([SyllivoColors.indigo, Color(0xFF7C3AED)], Icons.auto_awesome_rounded),
  ([SyllivoColors.teal, Color(0xFF0EA5E9)], Icons.spa_rounded),
  (
    [SyllivoColors.coral, Color(0xFFF97316)],
    Icons.local_fire_department_rounded
  ),
  ([Color(0xFF16A34A), SyllivoColors.teal], Icons.forest_rounded),
  ([SyllivoColors.navy, SyllivoColors.indigo], Icons.nightlight_round),
  ([SyllivoColors.amber, SyllivoColors.coral], Icons.wb_sunny_rounded),
];

class ProfileAvatar extends StatelessWidget {
  final int style;
  final String name;
  final double size;
  const ProfileAvatar(
      {super.key, required this.style, required this.name, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final (colors, icon) = avatarStyles[style % avatarStyles.length];
    return Semantics(
      label: 'Profile avatar',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          border: Border.all(color: Colors.white, width: size * 0.05),
          boxShadow: [
            BoxShadow(
                color: colors.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: name.trim().isNotEmpty
            ? Text(name.trim().characters.first.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: size * 0.42))
            : Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}

class MissionTile extends StatelessWidget {
  final MissionStatus status;
  const MissionTile(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final m = status.mission;
    final done = status.done;
    return Padding(
      key: Key('mission-${m.id}'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (done ? SyllivoColors.success : SyllivoColors.indigo)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(done ? Icons.check_rounded : m.icon,
              color: done ? SyllivoColors.success : SyllivoColors.indigo),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.title, style: t.titleSmall),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: _MiniBar(
                    value: status.fraction,
                    color: done ? SyllivoColors.success : SyllivoColors.amber),
              ),
              const SizedBox(width: 8),
              Text('${status.progress.clamp(0, m.target)} / ${m.target}',
                  style: t.labelMedium),
            ]),
          ]),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SyllivoColors.amber.withValues(alpha: done ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(done ? '✓ ${m.xp} XP' : '+${m.xp} XP',
              style: t.labelMedium?.copyWith(
                  color: const Color(0xFFB45309), fontWeight: FontWeight.w800)),
        ),
      ]),
    );
  }
}

class _MiniBar extends StatelessWidget {
  final double value;
  final Color color;
  const _MiniBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child:
            LinearProgressIndicator(value: value, minHeight: 8, color: color),
      );
}

class BadgeMedal extends StatelessWidget {
  final BadgeState badge;
  final double size;
  const BadgeMedal(this.badge, {super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final d = badge.def;
    final earned = badge.earned;
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: '${d.title}${earned ? ', earned' : ', locked'}',
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Stack(alignment: Alignment.center, children: [
          SizedBox.square(
            dimension: size,
            child: CircularProgressIndicator(
              value: earned ? 1 : badge.progress,
              strokeWidth: 4,
              color: earned ? d.color : d.color.withValues(alpha: 0.6),
              backgroundColor: cs.surfaceContainerHighest,
            ),
          ),
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: earned ? d.color : cs.surfaceContainerHighest,
            ),
            child: Icon(earned ? d.icon : Icons.lock_rounded,
                color: earned ? Colors.white : cs.outline, size: size * 0.38),
          ),
        ]),
        const SizedBox(height: 6),
        SizedBox(
          width: size + 24,
          child: Text(d.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium),
        ),
      ]),
    );
  }
}
