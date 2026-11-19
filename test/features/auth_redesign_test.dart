import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/auth/auth_providers.dart';
import 'package:syllivo/features/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

Future<void> scrollTo(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(f, 200,
      scrollable: find.byType(Scrollable).first);
  await settle(tester);
}

void main() {
  test('startRoute gates on auth choice and onboarding', () {
    expect(startRoute(authChoice: null, onboarded: false), '/login');
    expect(startRoute(authChoice: null, onboarded: true), '/login');
    expect(startRoute(authChoice: 'guest', onboarded: false), '/onboarding');
    expect(startRoute(authChoice: 'account', onboarded: true), '/home');
  });

  testWidgets('login screen shows every entry point', (tester) async {
    final app = await pumpLingo(tester, authChoice: null);
    expect(find.byKey(const Key('login-title')), findsOneWidget);
    expect(find.text('Your Language Journey Starts Here.'), findsOneWidget);
    expect(find.byKey(const Key('google-sign-in')), findsOneWidget);
    expect(find.byKey(const Key('email-sign-in')), findsOneWidget);
    expect(find.byKey(const Key('continue-guest')), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Terms of Service'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('without Firebase, Google sign-in explains and guest works',
      (tester) async {
    final app = await pumpLingo(tester, authChoice: null);
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await settle(tester);
    expect(find.byKey(const Key('auth-error')), findsOneWidget);
    expect(find.textContaining('aren’t set up'), findsOneWidget);
    ScaffoldMessenger.of(tester.element(find.byKey(const Key('login-title'))))
        .removeCurrentSnackBar();
    await settle(tester);
    await tester.tap(find.byKey(const Key('continue-guest')));
    await settle(tester);
    expect(find.byKey(const Key('continue-learning-home')), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('authChoice'), 'guest');
    await finish(tester, app);
  });

  testWidgets('privacy policy opens from the login screen', (tester) async {
    final app = await pumpLingo(tester, authChoice: null);
    await tapText(tester, 'Privacy Policy');
    expect(find.textContaining('device'), findsWidgets);
    await finish(tester, app);
  });

  testWidgets('Google sign-in links the account and keeps guest XP',
      (tester) async {
    final auth = FakeAuthService();
    final app = await pumpLingo(tester,
        authChoice: null,
        auth: auth,
        prepare: (db) => db.addXp('de', 120, 'lesson', testNow));
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await settle(tester);
    expect(find.byKey(const Key('continue-learning-home')), findsOneWidget);

    final account = await tester.runAsync(() => app.db.getAccount());
    expect(account!.uid, 'google-uid-123');
    expect(account.email, 'priya@gmail.com');
    final xp = await tester.runAsync(() => app.db.watchTotalXp().first);
    expect(xp, greaterThanOrEqualTo(120)); // nothing reset
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('authChoice'), 'account');

    await tapTab(tester, 'Profile');
    expect(find.text('priya@gmail.com'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('profile-name'))).data,
        'Priya');
    await finish(tester, app);
  });

  testWidgets('cancelled Google sign-in stays on login silently',
      (tester) async {
    final auth = FakeAuthService()
      ..nextError = const AuthFailure('Sign-in cancelled.', cancelled: true);
    final app = await pumpLingo(tester, authChoice: null, auth: auth);
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await settle(tester);
    expect(find.byKey(const Key('login-title')), findsOneWidget);
    expect(find.byKey(const Key('auth-error')), findsNothing);
    await finish(tester, app);
  });

  testWidgets('email sign-in validates input then signs in', (tester) async {
    final auth = FakeAuthService();
    final app = await pumpLingo(tester, authChoice: null, auth: auth);
    await tester.tap(find.byKey(const Key('email-sign-in')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('email-field')), 'nope');
    await tester.enterText(find.byKey(const Key('password-field')), '123456');
    await tester.tap(find.byKey(const Key('email-submit')));
    await settle(tester);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('email-field')), 'ravi@example.com');
    await tester.tap(find.byKey(const Key('email-submit')));
    await settle(tester);
    expect(find.byKey(const Key('continue-learning-home')), findsOneWidget);
    final account = await tester.runAsync(() => app.db.getAccount());
    expect(account!.email, 'ravi@example.com');
    await finish(tester, app);
  });

  testWidgets('sign out asks first, keeps progress and returns to login',
      (tester) async {
    final auth = FakeAuthService();
    final app = await pumpLingo(tester,
        authChoice: null,
        auth: auth,
        prepare: (db) => db.addXp('de', 50, 'lesson', testNow));
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await settle(tester);
    await tapTab(tester, 'Profile');
    await scrollTo(tester, find.byKey(const Key('sign-out')));
    await tester.tap(find.byKey(const Key('sign-out')));
    await settle(tester);
    await tapText(tester, 'Cancel');
    expect(find.byKey(const Key('sign-out')), findsOneWidget);
    await tester.tap(find.byKey(const Key('sign-out')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('confirm-sign-out')));
    await settle(tester);
    expect(find.byKey(const Key('login-title')), findsOneWidget);
    expect(await tester.runAsync(() => app.db.getAccount()), isNull);
    expect(await tester.runAsync(() => app.db.watchTotalXp().first),
        greaterThanOrEqualTo(50));
    await finish(tester, app);
  });

  testWidgets('delete account with erase removes local progress',
      (tester) async {
    final auth = FakeAuthService();
    final app = await pumpLingo(tester,
        authChoice: null,
        auth: auth,
        prepare: (db) => db.addXp('de', 50, 'lesson', testNow));
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await settle(tester);
    await tapTab(tester, 'Profile');
    await scrollTo(tester, find.byKey(const Key('delete-account')));
    await tester.tap(find.byKey(const Key('delete-account')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('erase-local')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await settle(tester);
    expect(auth.deleted, isTrue);
    expect(await tester.runAsync(() => app.db.watchTotalXp().first), 0);
    expect(await tester.runAsync(() => app.db.getAccount()), isNull);
    await finish(tester, app);
  });

  testWidgets('guest profile offers Google linking', (tester) async {
    final app = await pumpLingo(tester);
    await tapTab(tester, 'Profile');
    expect(find.textContaining('Guest'), findsWidgets);
    await scrollTo(tester, find.byKey(const Key('link-google')));
    expect(find.byKey(const Key('link-google')), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('language chip opens the picker and switches language',
      (tester) async {
    final app = await pumpLingo(tester);
    await tester.tap(find.byKey(const Key('language-chip')));
    await settle(tester);
    expect(find.text('Choose a language'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pick-ko')).last);
    await settle(tester);
    expect(find.byKey(const Key('course-ko')), findsOneWidget);
    await finish(tester, app);
  });

  test('bookmarks toggle on and off', () async {
    final db = await openTestDb();
    expect(
        await db.toggleBookmark(
            lang: 'de', target: 'Hallo', en: 'hello', now: testNow),
        isTrue);
    expect((await db.watchBookmarks('de').first).single.target, 'Hallo');
    expect(
        await db.toggleBookmark(
            lang: 'de', target: 'Hallo', en: 'hello', now: testNow),
        isFalse);
    expect(await db.watchBookmarks('de').first, isEmpty);
    await db.close();
  });

  test('linkAccount keeps linkedAt for the same user', () async {
    final db = await openTestDb();
    await db.linkAccount(
        uid: 'u1', provider: 'google', email: 'a@b.c', now: testNow);
    await db.linkAccount(
        uid: 'u1',
        provider: 'google',
        email: 'a@b.c',
        now: testNow.add(const Duration(days: 3)));
    expect((await db.getAccount())!.linkedAt, testNow);
    await db.close();
  });
}
