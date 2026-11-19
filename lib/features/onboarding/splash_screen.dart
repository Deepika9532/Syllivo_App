import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../auth/auth_providers.dart';
import '../gamification/game_providers.dart';

const syllivoTagline = 'Learn Languages. Unlock Opportunities.';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      context.go(startRoute(
        authChoice: ref.read(authChoiceProvider),
        onboarded: ref.read(profileProvider).onboarded,
      ));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [SyllivoColors.navy, SyllivoColors.indigo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(children: [
              const Spacer(flex: 3),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: const Sylli(size: 160, mood: SylliMood.wave),
              ),
              const SizedBox(height: 24),
              const SyllivoLogo(
                  size: 44, showMascot: false, color: Colors.white),
              const SizedBox(height: 8),
              Text(syllivoTagline,
                  key: const Key('tagline'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              const Spacer(flex: 2),
              const SizedBox(
                width: 140,
                child: LinearProgressIndicator(
                  value: null,
                  color: SyllivoColors.teal,
                  backgroundColor: Colors.white24,
                  minHeight: 6,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
              const SizedBox(height: 48),
            ]),
          ),
        ),
      );
}
