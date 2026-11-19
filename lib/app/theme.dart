import 'package:flutter/material.dart';

/// Syllivo design tokens.
abstract final class SyllivoColors {
  static const navy = Color(0xFF172554);
  static const indigo = Color(0xFF4F46E5);
  static const lavender = Color(0xFFEEF2FF);
  static const teal = Color(0xFF14B8A6);
  static const coral = Color(0xFFFB7185);
  static const background = Color(0xFFF8FAFC);
  static const white = Color(0xFFFFFFFF);
  static const amber = Color(0xFFF59E0B);
  static const success = Color(0xFF16A34A);
  static const successSoft = Color(0xFFDCFCE7);
  static const error = Color(0xFFE11D48);
  static const errorSoft = Color(0xFFFFE4E6);
  static const slate = Color(0xFF64748B);

  /// Per-language accents so German and Korean feel distinct.
  static const german = [Color(0xFF4F46E5), Color(0xFF7C3AED)];
  static const korean = [Color(0xFF0EA5A4), Color(0xFF2563EB)];
  static List<Color> forLang(String lang) => lang == 'ko' ? korean : german;
}

abstract final class SyllivoRadii {
  static const card = 20.0;
  static const button = 16.0;
  static const chip = 12.0;
}

class SyllivoTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final dark = b == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: SyllivoColors.indigo,
      brightness: b,
      primary: dark ? const Color(0xFF818CF8) : SyllivoColors.indigo,
      secondary: SyllivoColors.teal,
      tertiary: SyllivoColors.coral,
      surface: dark ? const Color(0xFF0B1220) : SyllivoColors.background,
      error: SyllivoColors.error,
    ).copyWith(
      primaryContainer: dark ? const Color(0xFF312E81) : SyllivoColors.lavender,
      onPrimaryContainer: dark ? SyllivoColors.lavender : SyllivoColors.navy,
      surfaceContainerLow: dark ? const Color(0xFF111A2E) : SyllivoColors.white,
      surfaceContainerHighest:
          dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = base.textTheme.apply(
      bodyColor: dark ? const Color(0xFFE2E8F0) : SyllivoColors.navy,
      displayColor: dark ? Colors.white : SyllivoColors.navy,
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text.copyWith(
        headlineMedium:
            text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        headlineSmall:
            text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: SyllivoColors.navy.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SyllivoRadii.card),
          side: BorderSide(
              color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SyllivoRadii.button)),
          textStyle: text.labelLarge?.copyWith(
              fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SyllivoRadii.button)),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SyllivoRadii.chip)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
            text.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SyllivoRadii.button)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
      }),
    );
  }
}
