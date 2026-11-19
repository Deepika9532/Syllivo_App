import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/auth/legal_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/curriculum/screens/course_welcome_screen.dart';
import '../features/curriculum/screens/curriculum_screen.dart';
import '../features/curriculum/screens/dashboard_screen.dart';
import '../features/curriculum/screens/exam_screen.dart';
import '../features/curriculum/screens/lesson_screen.dart';
import '../features/curriculum/screens/level_complete_screen.dart';
import '../features/curriculum/screens/placement_screen.dart';
import '../features/flashcards/review_screen.dart';
import '../features/home/home_screen.dart';
import '../features/journey/journey_screen.dart';
import '../features/lessons/lesson_detail_screen.dart';
import '../features/lessons/lessons_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/practice/practice_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/pronunciation/pronunciation_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/stats/stats_screen.dart';
import 'shell.dart';
import 'theme.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(
            path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(
          path: '/legal/:doc',
          builder: (_, s) => LegalScreen(doc: s.pathParameters['doc']!),
        ),
        StatefulShellRoute.indexedStack(
          builder: (_, __, shell) => SyllivoShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/journey', builder: (_, __) => const JourneyScreen())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/practice', builder: (_, __) => const PracticeScreen())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/stats', builder: (_, __) => const StatsScreen())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/profile', builder: (_, __) => const ProfileScreen())
            ]),
          ],
        ),
        // Full-screen routes (existing features keep their paths).
        GoRoute(path: '/lessons', builder: (_, __) => const LessonsScreen()),
        GoRoute(
          path: '/lesson/:id',
          builder: (_, s) =>
              LessonDetailScreen(lessonId: s.pathParameters['id']!),
        ),
        GoRoute(path: '/review', builder: (_, __) => const ReviewScreen()),
        GoRoute(
          path: '/pronounce/:id',
          builder: (_, s) =>
              PronunciationScreen(lessonId: s.pathParameters['id']!),
        ),
        GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(
          path: '/learn/:lang',
          builder: (_, s) => CurriculumScreen(lang: s.pathParameters['lang']!),
          routes: [
            GoRoute(
              path: 'lesson/:id',
              builder: (_, s) => LessonScreen(
                  lang: s.pathParameters['lang']!,
                  lessonId: s.pathParameters['id']!),
            ),
            GoRoute(
              path: 'exam/:level',
              builder: (_, s) => ExamScreen(
                  lang: s.pathParameters['lang']!,
                  levelId: s.pathParameters['level']!),
            ),
            GoRoute(
              path: 'complete/:level',
              builder: (_, s) => LevelCompleteScreen(
                  lang: s.pathParameters['lang']!,
                  levelId: s.pathParameters['level']!),
            ),
            GoRoute(
              path: 'placement',
              builder: (_, s) =>
                  PlacementScreen(lang: s.pathParameters['lang']!),
            ),
            GoRoute(
              path: 'welcome',
              builder: (_, s) =>
                  CourseWelcomeScreen(lang: s.pathParameters['lang']!),
            ),
            GoRoute(
              path: 'dashboard',
              builder: (_, s) =>
                  DashboardScreen(lang: s.pathParameters['lang']!),
            ),
          ],
        ),
      ],
    ));

class LingoApp extends ConsumerWidget {
  const LingoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = switch (ref.watch(themeModeProvider)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return MaterialApp.router(
      title: 'Syllivo',
      debugShowCheckedModeBanner: false,
      theme: SyllivoTheme.light(),
      darkTheme: SyllivoTheme.dark(),
      themeMode: mode,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
