import 'package:drift_flutter/drift_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/db/app_database.dart';
import 'core/db/seed.dart';
import 'core/providers.dart';
import 'firebase_options.dart';
import 'features/auth/auth_providers.dart';
import 'features/auth/auth_service.dart';
import 'features/curriculum/curriculum_providers.dart';
import 'features/curriculum/curriculum_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase(driftDatabase(name: 'lingo'));
  final curriculum = CurriculumRepository(rootBundle);
  await seedContent(db, curriculum: curriculum);
  final prefs = await SharedPreferences.getInstance();
  final auth = await initAuth();

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPrefsProvider.overrideWithValue(prefs),
      curriculumRepositoryProvider.overrideWithValue(curriculum),
      authServiceProvider.overrideWithValue(auth),
    ],
    child: const LingoApp(),
  ));
}

/// Firebase is optional: without android/app/google-services.json the app
/// runs in guest-only mode instead of crashing.
Future<AuthService> initAuth() async {
  try {
    await Firebase.initializeApp();
    return FirebaseAuthService();
  } catch (e) {
    debugPrint('Firebase not configured — sign-in disabled: $e');
    return UnavailableAuthService('$e');
  }
}
