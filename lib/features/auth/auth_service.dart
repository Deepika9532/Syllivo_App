/// Authentication for Syllivo: Google (via Firebase Auth), email/password,
/// or guest. Tokens are handled by the Firebase / Google SDKs (secure
/// platform storage) and are never stored by the app.
library;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String provider; // google | password
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    this.name,
    this.email,
    this.photoUrl,
    required this.provider,
    this.createdAt,
  });
}

/// An error with a message that is safe to show to the user.
class AuthFailure implements Exception {
  final String message;
  final bool cancelled;
  const AuthFailure(this.message, {this.cancelled = false});
  @override
  String toString() => message;
}

abstract class AuthService {
  /// False when Firebase isn't configured for this build.
  bool get available;
  String? get unavailableReason;
  Stream<AppUser?> get userChanges;
  AppUser? get currentUser;

  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> registerWithEmail(String email, String password,
      {String? name});
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();

  /// Deletes the authentication account (not the on-device learning data).
  Future<void> deleteAccount();
}

const notConfiguredMessage =
    'Google and email sign-in aren’t set up in this build yet. You can keep '
    'learning as a guest — your progress is saved on this device.';

/// Used when Firebase could not be initialised (e.g. no google-services.json).
class UnavailableAuthService implements AuthService {
  @override
  final String? unavailableReason;
  UnavailableAuthService([this.unavailableReason]);

  @override
  bool get available => false;
  @override
  Stream<AppUser?> get userChanges => Stream.value(null);
  @override
  AppUser? get currentUser => null;

  Never _fail() => throw const AuthFailure(notConfiguredMessage);

  @override
  Future<AppUser> signInWithGoogle() async => _fail();
  @override
  Future<AppUser> signInWithEmail(String email, String password) async =>
      _fail();
  @override
  Future<AppUser> registerWithEmail(String email, String password,
          {String? name}) async =>
      _fail();
  @override
  Future<void> sendPasswordReset(String email) async => _fail();
  @override
  Future<void> signOut() async {}
  @override
  Future<void> deleteAccount() async => _fail();
}

class FirebaseAuthService implements AuthService {
  final fb.FirebaseAuth _auth;
  final GoogleSignIn _google;
  bool _googleReady = false;

  FirebaseAuthService({fb.FirebaseAuth? auth, GoogleSignIn? google})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _google = google ?? GoogleSignIn.instance;

  @override
  bool get available => true;
  @override
  String? get unavailableReason => null;

  @override
  Stream<AppUser?> get userChanges => _auth.userChanges().map(_map);

  @override
  AppUser? get currentUser => _map(_auth.currentUser);

  static AppUser? _map(fb.User? u) {
    if (u == null) return null;
    final google = u.providerData.any((p) => p.providerId == 'google.com');
    return AppUser(
      uid: u.uid,
      name: u.displayName,
      email: u.email,
      photoUrl: u.photoURL,
      provider: google ? 'google' : 'password',
      createdAt: u.metadata.creationTime,
    );
  }

  Future<void> _ensureGoogle() async {
    if (_googleReady) return;
    // On Android the server client id is read from google-services.json
    // (default_web_client_id) by the Google services plugin.
    await _google.initialize();
    _googleReady = true;
  }

  Future<fb.AuthCredential> _googleCredential() async {
    await _ensureGoogle();
    try {
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure(
            'Google didn’t return a sign-in token. Please try again.');
      }
      return fb.GoogleAuthProvider.credential(idToken: idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure('Sign-in cancelled.', cancelled: true);
      }
      throw AuthFailure(_googleMessage(e));
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final credential = await _googleCredential();
    try {
      final result = await _auth.signInWithCredential(credential);
      return _map(result.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(firebaseMessage(e.code));
    }
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final r = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return _map(r.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(firebaseMessage(e.code));
    }
  }

  @override
  Future<AppUser> registerWithEmail(String email, String password,
      {String? name}) async {
    try {
      final r = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      if (name != null && name.trim().isNotEmpty) {
        await r.user!.updateDisplayName(name.trim());
        await r.user!.reload();
      }
      return _map(_auth.currentUser)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(firebaseMessage(e.code));
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(firebaseMessage(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleReady) {
      try {
        await _google.signOut();
      } catch (_) {/* already signed out of Google */}
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.delete();
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login' &&
          _map(user)?.provider == 'google') {
        // Re-authenticate with Google once, then retry.
        await user.reauthenticateWithCredential(await _googleCredential());
        await user.delete();
      } else {
        throw AuthFailure(firebaseMessage(e.code));
      }
    }
    await signOut();
  }

  static String _googleMessage(GoogleSignInException e) => switch (e.code) {
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          'Google sign-in isn’t configured correctly for this app (check the SHA-1 '
              'fingerprint and OAuth client in Firebase).',
        GoogleSignInExceptionCode.interrupted =>
          'Sign-in was interrupted. Please try again.',
        GoogleSignInExceptionCode.uiUnavailable =>
          'Google sign-in can’t open right now. Please try again.',
        _ => 'Google sign-in failed. Check your connection and try again.',
      };
}

/// User-facing text for Firebase Auth error codes.
String firebaseMessage(String code) => switch (code) {
      'invalid-email' => 'That email address doesn’t look right.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
        'Email or password is incorrect.',
      'email-already-in-use' =>
        'An account with this email already exists. Try signing in.',
      'weak-password' =>
        'Please choose a stronger password (at least 6 characters).',
      'network-request-failed' =>
        'No internet connection. Sign-in needs a connection; learning doesn’t.',
      'too-many-requests' =>
        'Too many attempts. Please wait a moment and try again.',
      'account-exists-with-different-credential' =>
        'This email is already registered with another sign-in method.',
      'requires-recent-login' =>
        'For security, please sign in again and then retry.',
      'operation-not-allowed' =>
        'This sign-in method isn’t enabled in the Firebase project.',
      _ => 'Something went wrong ($code). Please try again.',
    };
