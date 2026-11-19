import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/app/app.dart';
import 'package:syllivo/core/content/lesson_pack.dart';
import 'package:syllivo/core/db/app_database.dart';
import 'package:syllivo/core/providers.dart';
import 'package:syllivo/core/speech/stt_service.dart';
import 'package:syllivo/core/speech/tts_service.dart';
import 'package:syllivo/features/auth/auth_providers.dart';
import 'package:syllivo/features/auth/auth_service.dart';
import 'package:syllivo/features/curriculum/curriculum_providers.dart';
import 'package:syllivo/features/curriculum/curriculum_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final testNow = DateTime(2026, 11, 10, 9);

const testPack = LessonPack(
  id: 'de_test',
  lang: 'de',
  level: 'A1',
  title: 'Test Lesson',
  order: 1,
  version: 1,
  cards: [
    PackCard(id: 'c1', front: 'Hallo', back: 'Hello', audio: 'Hallo'),
    PackCard(id: 'c2', front: 'Danke', back: 'Thank you', audio: 'Danke'),
  ],
);

class FakeTts implements TtsService {
  final spoken = <String>[];

  @override
  Future<void> speak(String text, String lang, {double rate = 0.45}) async =>
      spoken.add(text);

  @override
  Future<bool> isAvailable(String lang) async => true;

  @override
  Future<void> stop() async {}
}

class TestApp {
  final AppDatabase db;
  final FakeTts tts;
  TestApp(this.db, this.tts);
}

/// Pumps the full app on an in-memory database with fixed time.
///
/// By default onboarding is already complete and the app starts on Home.
/// Pass [db] and [prefs] from an earlier run to simulate an app restart.
Future<TestApp> pumpLingo(WidgetTester tester,
    {bool seed = true,
    SttService? stt,
    bool onboarded = true,
    String? authChoice = 'guest',
    AuthService? auth,
    AppDatabase? db,
    Map<String, Object>? prefs,
    Future<void> Function(AppDatabase db)? prepare}) async {
  // Reduce motion: the companion's idle animation would never settle.
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);

  if (prefs == null) {
    SharedPreferences.setMockInitialValues({
      'lang': 'de',
      'onboarded': onboarded,
      if (authChoice != null) 'authChoice': authChoice,
    });
  }
  final sp = await SharedPreferences.getInstance();
  final database = db ?? AppDatabase(NativeDatabase.memory());
  final tts = FakeTts();
  if (seed && db == null) await database.upsertPack(testPack, testNow);
  if (prepare != null) await prepare(database);

  await tester.pumpWidget(ProviderScope(
    key: UniqueKey(),
    overrides: [
      databaseProvider.overrideWithValue(database),
      sharedPrefsProvider.overrideWithValue(sp),
      clockProvider.overrideWithValue(() => testNow),
      ttsProvider.overrideWithValue(tts),
      sttProvider.overrideWithValue(stt ?? FakeStt()),
      authServiceProvider.overrideWithValue(auth ?? UnavailableAuthService()),
      curriculumRepositoryProvider
          .overrideWithValue(CurriculumRepository(DiskBundle())),
    ],
    child: const LingoApp(),
  ));
  // Splash screen → onboarding or home.
  await tester.pump(const Duration(milliseconds: 1500));
  await settle(tester);
  return TestApp(database, tts);
}

/// Lets real database futures complete, then settles animations.
Future<void> settle(WidgetTester tester) async {
  // Real DB work runs outside the fake clock; keep yielding until no
  // loading spinners remain (bounded so a stuck test fails instead of hanging).
  for (var i = 0; i < 100; i++) {
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
    await tester.pump(const Duration(milliseconds: 50));
    if (i >= 3 && !_loading()) break;
  }
  await tester.pumpAndSettle(const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate, const Duration(seconds: 10));
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await settle(tester);
}

Finder textContaining(String s) =>
    find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains(s));

/// Unmounts the app so stream subscriptions cancel, then closes the DB.
/// Call at the end of every widget test.
Future<void> finish(WidgetTester tester, TestApp app,
    {bool closeDb = true}) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
  if (closeDb) await tester.runAsync(app.db.close);
}

/// Taps a bottom-navigation tab by its label.
Future<void> tapTab(WidgetTester tester, String label) async {
  await tester.tap(find.descendant(
      of: find.byType(NavigationBar), matching: find.text(label)));
  await settle(tester);
}

/// Navigates with the app's router (screens can be reached from several
/// places, so tests jump straight to the route under test).
Future<void> goTo(WidgetTester tester, String path) async {
  final container =
      ProviderScope.containerOf(tester.element(find.byType(LingoApp)));
  container.read(routerProvider).push(path);
  await settle(tester);
}

ProviderContainer containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(LingoApp)));

/// Speech recognition stand-in. [available] = false simulates a device
/// without a recognizer or language pack.
class FakeStt implements SttService {
  final bool available;
  final String heard;
  FakeStt({this.available = true, this.heard = ''});

  @override
  final ValueNotifier<bool> listening = ValueNotifier(false);
  @override
  String? lastError;

  @override
  Future<bool> init() async => available;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<bool> supportsLocale(String locale) async => available;

  @override
  Future<void> listen(
      {required String locale,
      required void Function(String text, bool isFinal) onResult}) async {
    if (!available) {
      throw const SpeechUnavailableException(speechUnavailableHelp);
    }
    onResult(heard, true);
  }

  @override
  Future<void> stop() async {}
}

bool _loading() =>
    find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
    find.text('Loading…').evaluate().isNotEmpty ||
    find
        .byWidgetPredicate(
            (w) => w is LinearProgressIndicator && w.value == null)
        .evaluate()
        .isNotEmpty;

/// Reads bundled assets straight from the project folder — no network, no
/// platform channels — which also proves the content is fully offline.
class DiskBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      File(key).readAsString(encoding: utf8);
}

/// In-memory stand-in for Firebase/Google auth with controllable outcomes.
class FakeAuthService implements AuthService {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;
  AuthFailure? nextError;
  bool deleted = false;
  final AppUser googleUser = AppUser(
    uid: 'google-uid-123',
    name: 'Priya Sharma',
    email: 'priya@gmail.com',
    provider: 'google',
    createdAt: DateTime(2026, 1, 5),
  );

  @override
  bool get available => true;
  @override
  String? get unavailableReason => null;
  @override
  Stream<AppUser?> get userChanges => _controller.stream;
  @override
  AppUser? get currentUser => _user;

  AppUser _signIn(AppUser u) {
    final e = nextError;
    if (e != null) {
      nextError = null;
      throw e;
    }
    _user = u;
    _controller.add(u);
    return u;
  }

  @override
  Future<AppUser> signInWithGoogle() async => _signIn(googleUser);
  @override
  Future<AppUser> signInWithEmail(String email, String password) async =>
      _signIn(AppUser(uid: 'email-uid', email: email, provider: 'password'));
  @override
  Future<AppUser> registerWithEmail(String email, String password,
          {String? name}) async =>
      _signIn(AppUser(
          uid: 'email-uid', email: email, name: name, provider: 'password'));
  @override
  Future<void> sendPasswordReset(String email) async {}
  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    deleted = true;
    await signOut();
  }
}

Future<AppDatabase> openTestDb() async => AppDatabase(NativeDatabase.memory());
