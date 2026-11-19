import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'companion.dart';

/// Wordmark: Sylli + "Syllivo".
class SyllivoLogo extends StatelessWidget {
  final double size;
  final bool showMascot;
  final Color? color;
  const SyllivoLogo(
      {super.key, this.size = 32, this.showMascot = true, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (showMascot) Sylli(size: size * 1.3, animate: false),
      if (showMascot) SizedBox(width: size * 0.2),
      Text.rich(
        TextSpan(children: [
          TextSpan(text: 'Sylli', style: TextStyle(color: c)),
          const TextSpan(
              text: 'vo', style: TextStyle(color: SyllivoColors.teal)),
        ]),
        style: TextStyle(
            fontSize: size, fontWeight: FontWeight.w900, letterSpacing: -0.5),
      ),
    ]);
  }
}

/// Slight scale-down while pressed, plus a light haptic tick.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool haptic;
  const Pressable(
      {super.key, required this.child, this.onTap, this.haptic = true});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown:
            widget.onTap == null ? null : (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.haptic) HapticFeedback.selectionClick();
                widget.onTap!();
              },
        child: AnimatedScale(
          scale: _down ? 0.96 : 1,
          duration: const Duration(milliseconds: 90),
          child: widget.child,
        ),
      );
}

/// Progress bar that animates between values.
class AnimatedBar extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  const AnimatedBar(
      {super.key, required this.value, this.color, this.height = 12});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: cs.surfaceContainerHighest,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1).toDouble()),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (_, v, __) => FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: v,
            child: Container(
              decoration: BoxDecoration(
                color: color ?? cs.primary,
                borderRadius: BorderRadius.circular(height),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      height / 2, height * 0.2, height / 2, 0),
                  height: height * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular progress ring with a centre label.
class ProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final Widget center;
  final Color? color;
  const ProgressRing(
      {super.key,
      required this.value,
      this.size = 72,
      required this.center,
      this.color});

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1).toDouble()),
          duration: const Duration(milliseconds: 600),
          builder: (_, v, __) => CustomPaint(
            painter: _RingPainter(
                v,
                color ?? Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.surfaceContainerHighest),
            child: Center(child: center),
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  final double v;
  final Color color, track;
  _RingPainter(this.v, this.color, this.track);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.11;
    final rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * pi, false, p..color = track);
    if (v > 0) {
      canvas.drawArc(rect, -pi / 2, 2 * pi * v, false, p..color = color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.v != v || o.color != color;
}

/// Compact stat pill for headers: streak, XP, hearts.
class StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final String semantics;
  const StatPill(
      {super.key,
      required this.icon,
      required this.value,
      required this.color,
      required this.semantics});

  @override
  Widget build(BuildContext context) => Semantics(
        label: semantics,
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(value,
                style: TextStyle(fontWeight: FontWeight.w800, color: color)),
          ]),
        ),
      );
}

/// Section title with optional action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
        child: Row(children: [
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ]),
      );
}

/// Lightweight confetti burst for celebrations (one-shot, ~1.2 s).
class ConfettiBurst extends StatefulWidget {
  final Widget child;
  const ConfettiBurst({super.key, required this.child});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.value = 1;
    } else if (_c.value == 0) {
      _c.forward();
    }
  }

  final _rng = Random(7);
  late final List<(double, double, Color, double)> _pieces = [
    for (var i = 0; i < 42; i++)
      (
        _rng.nextDouble() * 2 * pi,
        0.5 + _rng.nextDouble() * 0.6,
        [
          SyllivoColors.indigo,
          SyllivoColors.teal,
          SyllivoColors.coral,
          SyllivoColors.amber
        ][i % 4],
        _rng.nextDouble() * pi,
      ),
  ];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => _c.isCompleted
                ? const SizedBox.shrink()
                : CustomPaint(
                    size: const Size(260, 260),
                    painter: _ConfettiPainter(_c.value, _pieces)),
          ),
        ),
      ]);
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  final List<(double, double, Color, double)> pieces;
  _ConfettiPainter(this.t, this.pieces);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    for (final (angle, speed, color, rot) in pieces) {
      final d = Curves.easeOut.transform(t) * size.width * 0.5 * speed;
      final p = c + Offset(cos(angle) * d, sin(angle) * d + t * t * 60);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(rot + t * 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-4, -2, 8, 4), const Radius.circular(1)),
        Paint()..color = color.withValues(alpha: 1 - t),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter o) => o.t != t;
}
