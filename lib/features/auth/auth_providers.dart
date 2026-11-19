import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/providers.dart';
import '../gamification/game_providers.dart';
import 'auth_service.dart';

/// Overridden in main.dart with the initialised service.
final authServiceProvider =
    Provider<AuthService>((ref) => UnavailableAuthService());

final authUserProvider = StreamProvider<AppUser?>(
    (ref) => ref.watch(authServiceProvider).userChanges);

/// The account linked to this device's learning data (null = guest).
final accountProvider = StreamProvider<AccountRow?>(
    (ref) => ref.watch(databaseProvider).watchAccount());

/// Whether the learner has made a sign-in choice: 'account', 'guest' or null
/// (show the login screen).
class AuthChoiceNotifier extends Notifier<String?> {
  @override
  String? build() => ref.watch(sharedPrefsProvider).getString('authChoice');

  void set(String? v) {
    final p = ref.read(sharedPrefsProvider);
    v == null ? p.remove('authChoice') : p.setString('authChoice', v);
    state = v;
  }
}

final authChoiceProvider =
    NotifierProvider<AuthChoiceNotifier, String?>(AuthChoiceNotifier.new);

/// Sign-in flows. On success the account is linked to the existing local
/// learning data — guest progress (XP, streaks, lessons, history) is kept.
class AuthController {
  final Ref ref;
  AuthController(this.ref);

  AuthService get _auth => ref.read(authServiceProvider);
  AppDatabase get _db => ref.read(databaseProvider);

  Future<AppUser> signInWithGoogle() => _complete(_auth.signInWithGoogle());

  Future<AppUser> signInWithEmail(String email, String password) =>
      _complete(_auth.signInWithEmail(email, password));

  Future<AppUser> register(String email, String password, String name) =>
      _complete(_auth.registerWithEmail(email, password, name: name));

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordReset(email);

  Future<AppUser> _complete(Future<AppUser> signIn) async {
    final user = await signIn;
    await _db.linkAccount(
      uid: user.uid,
      provider: user.provider,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      now: ref.read(clockProvider)(),
    );
    final profile = ref.read(profileProvider);
    if (profile.name.isEmpty && (user.name ?? '').isNotEmpty) {
      ref.read(profileProvider.notifier).setName(user.name!.split(' ').first);
    }
    ref.read(authChoiceProvider.notifier).set('account');
    return user;
  }

  void continueAsGuest() => ref.read(authChoiceProvider.notifier).set('guest');

  /// Signs out. Learning data stays on this device (usable as a guest or
  /// after signing in again).
  Future<void> signOut() async {
    await _auth.signOut();
    await _db.unlinkAccount();
    ref.read(authChoiceProvider.notifier).set(null);
  }

  /// Deletes the sign-in account; optionally erases on-device progress too.
  Future<void> deleteAccount({required bool eraseLocalData}) async {
    await _auth.deleteAccount();
    await _db.unlinkAccount();
    if (eraseLocalData) {
      await _db.eraseLearningData(ref.read(clockProvider)());
      ref.read(profileProvider.notifier).resetAll();
    }
    ref.read(authChoiceProvider.notifier).set(null);
  }
}

final authControllerProvider =
    Provider<AuthController>((ref) => AuthController(ref));

/// Where the app should start after the splash screen.
String startRoute({required String? authChoice, required bool onboarded}) {
  if (authChoice == null) return '/login';
  if (!onboarded) return '/onboarding';
  return '/home';
}
