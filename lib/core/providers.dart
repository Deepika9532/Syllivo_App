import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/app_database.dart';
import 'speech/stt_service.dart';
import 'speech/tts_service.dart';
import 'srs/fsrs.dart';
import 'srs/sm2.dart';

// Overridden in main.dart.
final sharedPrefsProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());
final databaseProvider =
    Provider<AppDatabase>((ref) => throw UnimplementedError());

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Review algorithm, switchable in Settings. FSRS is the default.
class SchedulerNotifier extends Notifier<Scheduler> {
  static const _key = 'scheduler';

  @override
  Scheduler build() => ref.watch(sharedPrefsProvider).getString(_key) == 'sm2'
      ? Sm2Scheduler()
      : const FsrsScheduler();

  void use(String id) {
    ref.read(sharedPrefsProvider).setString(_key, id);
    state = id == 'sm2' ? Sm2Scheduler() : const FsrsScheduler();
  }
}

final schedulerProvider =
    NotifierProvider<SchedulerNotifier, Scheduler>(SchedulerNotifier.new);

/// Light / dark / system theme, saved in preferences.
class ThemeModeNotifier extends Notifier<String> {
  @override
  String build() =>
      ref.watch(sharedPrefsProvider).getString('theme') ?? 'system';

  void set(String mode) {
    ref.read(sharedPrefsProvider).setString('theme', mode);
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, String>(ThemeModeNotifier.new);

final ttsProvider = Provider<TtsService>((ref) {
  final tts = TtsService();
  ref.onDispose(tts.stop);
  return tts;
});
final sttProvider = Provider<SttService>((ref) => SttService());

class LanguageNotifier extends Notifier<String> {
  @override
  String build() => ref.watch(sharedPrefsProvider).getString('lang') ?? 'de';

  void select(String lang) {
    state = lang;
    ref.read(sharedPrefsProvider).setString('lang', lang);
  }
}

final languageProvider =
    NotifierProvider<LanguageNotifier, String>(LanguageNotifier.new);

final lessonsProvider = StreamProvider.autoDispose.family<List<Lesson>, String>(
    (ref, lang) => ref.watch(databaseProvider).watchLessons(lang));

final lessonProvider = FutureProvider.autoDispose.family<Lesson?, String>(
    (ref, id) => ref.watch(databaseProvider).getLesson(id));

final lessonCardsProvider = StreamProvider.autoDispose
    .family<List<FlashCard>, String>(
        (ref, id) => ref.watch(databaseProvider).watchLessonCards(id));

final queueCountsProvider = FutureProvider.autoDispose
    .family<({int due, int fresh}), String>((ref, lang) => ref
        .watch(databaseProvider)
        .queueCounts(lang, ref.read(clockProvider)()));

final statsProvider = FutureProvider.autoDispose.family<ProgressStats, String>(
    (ref, lang) =>
        ref.watch(databaseProvider).stats(lang, ref.read(clockProvider)()));
