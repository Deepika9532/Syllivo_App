import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Sylli — Syllivo's original companion: a round speech-bubble creature with
/// a sprout. Drawn entirely in code (no image assets).
enum SylliMood { happy, cheer, think, sad, wave }

class Sylli extends StatefulWidget {
  final double size;
  final SylliMood mood;
  final bool animate;

  const Sylli(
      {super.key,
      this.size = 96,
      this.mood = SylliMood.happy,
      this.animate = true});

  @override
  State<Sylli> createState() => _SylliState();
}

class _SylliState extends State<Sylli> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2200));

  // Respects the system "remove animations" accessibility setting.
  bool get _shouldAnimate =>
      widget.animate &&
      !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(Sylli old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (_shouldAnimate && !_c.isAnimating) _c.repeat();
    if (!_shouldAnimate && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Sylli, your learning companion',
      image: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => CustomPaint(
            size: Size.square(widget.size),
            painter: SylliPainter(
                mood: widget.mood, t: _shouldAnimate ? _c.value : 0),
          ),
        ),
      ),
    );
  }
}

class SylliPainter extends CustomPainter {
  final SylliMood mood;
  final double t; // 0..1 animation phase

  SylliPainter({required this.mood, this.t = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final bounce = mood == SylliMood.cheer
        ? sin(t * 2 * pi * 2).abs() * 0.06
        : sin(t * 2 * pi) * 0.02;
    canvas.save();
    canvas.translate(0, -bounce * s);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.95 + bounce * s),
          width: s * (0.55 - bounce),
          height: s * 0.07),
      Paint()..color = SyllivoColors.navy.withValues(alpha: 0.12),
    );

    // Body: rounded speech bubble with a tail.
    final body = Rect.fromLTWH(s * 0.12, s * 0.24, s * 0.76, s * 0.62);
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [SyllivoColors.indigo, Color(0xFF6366F1), SyllivoColors.teal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(body);
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(s * 0.3)))
      ..moveTo(s * 0.26, s * 0.78)
      ..quadraticBezierTo(s * 0.18, s * 0.95, s * 0.08, s * 0.96)
      ..quadraticBezierTo(s * 0.3, s * 0.94, s * 0.4, s * 0.82)
      ..close();
    canvas.drawPath(path, bodyPaint);

    // Sprout
    final stem = Paint()
      ..color = SyllivoColors.teal
      ..strokeWidth = s * 0.035
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final sway = sin(t * 2 * pi) * s * 0.02;
    canvas.drawPath(
        Path()
          ..moveTo(s * 0.5, s * 0.25)
          ..quadraticBezierTo(s * 0.5, s * 0.16, s * 0.5 + sway, s * 0.1),
        stem);
    final leaf = Paint()..color = const Color(0xFF2DD4BF);
    canvas.drawPath(
        Path()
          ..moveTo(s * 0.5 + sway, s * 0.12)
          ..quadraticBezierTo(
              s * 0.62 + sway, s * 0.02, s * 0.72 + sway, s * 0.1)
          ..quadraticBezierTo(
              s * 0.62 + sway, s * 0.18, s * 0.5 + sway, s * 0.12),
        leaf);
    canvas.drawPath(
        Path()
          ..moveTo(s * 0.5 + sway, s * 0.14)
          ..quadraticBezierTo(
              s * 0.4 + sway, s * 0.06, s * 0.32 + sway, s * 0.12)
          ..quadraticBezierTo(
              s * 0.4 + sway, s * 0.19, s * 0.5 + sway, s * 0.14),
        leaf..color = const Color(0xFF5EEAD4));

    // Face plate
    final face = Paint()..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawOval(Rect.fromLTWH(s * 0.22, s * 0.36, s * 0.56, s * 0.4), face);

    // Eyes
    final blink = (t > 0.92 && t < 0.96) ? 0.15 : 1.0;
    final eyeWhite = Paint()..color = Colors.white;
    final pupil = Paint()..color = SyllivoColors.navy;
    for (final x in [0.38, 0.62]) {
      final c = Offset(s * x, s * 0.5);
      if (mood == SylliMood.cheer || mood == SylliMood.happy && blink < 1) {
        // closed happy eyes: arcs
        canvas.drawArc(
            Rect.fromCenter(center: c, width: s * 0.13, height: s * 0.1),
            pi,
            pi,
            false,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = s * 0.03
              ..strokeCap = StrokeCap.round);
      } else {
        canvas.drawOval(
            Rect.fromCenter(
                center: c, width: s * 0.13, height: s * 0.15 * blink),
            eyeWhite);
        final look =
            mood == SylliMood.think ? Offset(s * 0.02, -s * 0.02) : Offset.zero;
        canvas.drawCircle(c + look, s * 0.035 * (blink < 1 ? 0.4 : 1), pupil);
        canvas.drawCircle(
            c + look + Offset(s * 0.012, -s * 0.012), s * 0.01, eyeWhite);
      }
    }

    // Cheeks
    final cheek = Paint()..color = SyllivoColors.coral.withValues(alpha: 0.75);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(s * 0.29, s * 0.6),
            width: s * 0.08,
            height: s * 0.045),
        cheek);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(s * 0.71, s * 0.6),
            width: s * 0.08,
            height: s * 0.045),
        cheek);

    // Mouth
    final mouth = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.028
      ..strokeCap = StrokeCap.round;
    final mc = Offset(s * 0.5, s * 0.63);
    switch (mood) {
      case SylliMood.happy:
      case SylliMood.wave:
        canvas.drawArc(
            Rect.fromCenter(center: mc, width: s * 0.14, height: s * 0.1),
            0.15 * pi,
            0.7 * pi,
            false,
            mouth);
      case SylliMood.cheer:
        canvas.drawPath(
            Path()
              ..moveTo(mc.dx - s * 0.08, mc.dy - s * 0.02)
              ..quadraticBezierTo(
                  mc.dx, mc.dy + s * 0.11, mc.dx + s * 0.08, mc.dy - s * 0.02)
              ..close(),
            Paint()..color = SyllivoColors.coral);
      case SylliMood.think:
        canvas.drawLine(
            mc + Offset(-s * 0.04, 0), mc + Offset(s * 0.04, s * 0.01), mouth);
      case SylliMood.sad:
        canvas.drawArc(
            Rect.fromCenter(
                center: mc + Offset(0, s * 0.04),
                width: s * 0.12,
                height: s * 0.08),
            1.15 * pi,
            0.7 * pi,
            false,
            mouth);
    }

    // Arms for cheer / wave
    final arm = Paint()
      ..color = const Color(0xFF6366F1)
      ..strokeWidth = s * 0.05
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (mood == SylliMood.cheer) {
      canvas.drawLine(
          Offset(s * 0.16, s * 0.48), Offset(s * 0.04, s * 0.3), arm);
      canvas.drawLine(Offset(s * 0.84, s * 0.48), Offset(s * 0.96, s * 0.3),
          arm..color = SyllivoColors.teal);
    } else if (mood == SylliMood.wave) {
      final w = sin(t * 2 * pi * 2) * s * 0.05;
      canvas.drawLine(Offset(s * 0.84, s * 0.5), Offset(s * 0.97 + w, s * 0.32),
          arm..color = SyllivoColors.teal);
    }

    // Thinking dots
    if (mood == SylliMood.think) {
      final dot = Paint()..color = SyllivoColors.slate.withValues(alpha: 0.6);
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(Offset(s * (0.82 + i * 0.06), s * (0.2 - i * 0.05)),
            s * (0.018 + i * 0.008), dot);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(SylliPainter old) => old.t != t || old.mood != mood;
}

/// Sylli with a short speech bubble.
class SylliSays extends StatelessWidget {
  final String text;
  final SylliMood mood;
  final double size;

  const SylliSays(this.text,
      {super.key, this.mood = SylliMood.happy, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Sylli(size: size, mood: mood),
      const SizedBox(width: 8),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    ]);
  }
}
