import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Existing features (reviews, stats, achievements, settings, decks) still
/// work end-to-end inside the Syllivo shell.
void main() {
  testWidgets('flashcard review from Home earns XP and shows in progress',
      (tester) async {
    final app = await pumpLingo(tester);
    expect(find.byKey(const Key('course-de')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('review-counts')), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('0 due · 2 new words'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('review-now')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('review-now')));
    await settle(tester);
    for (var i = 0; i < 2; i++) {
      await tapText(tester, 'Show answer');
      await tapText(tester, 'Good');
    }
    expect(find.text('Session complete'), findsOneWidget);
    await tapText(tester, 'Done');

    // 2 reviews = 2 XP.
    final xp = await tester.runAsync(() => app.db.watchTotalXp().first);
    expect(xp, greaterThanOrEqualTo(2));

    // Original activity & achievements screen still works.
    await goTo(tester, '/progress');
    expect(find.text('🔥 1'), findsOneWidget);
    expect(textContaining('Today: 2 / 20'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.byKey(const Key('achievement-first')), 200,
        scrollable: find.byType(Scrollable).last);
    expect(textContaining('Achievements · 1 /'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);

    // Settings is reachable from Profile.
    await tapTab(tester, 'Profile');
    await tester.scrollUntilVisible(find.byKey(const Key('open-settings')), 300,
        scrollable: find.byType(Scrollable).last);
    await tester.pump();
    await tester.tap(find.byKey(const Key('open-settings')));
    await settle(tester);
    await tapText(tester, 'SM-2 (classic)');
    final group = tester
        .widget<RadioGroup<String>>(find.byKey(const Key('algorithm-group')));
    expect(group.groupValue, 'sm2');
    await finish(tester, app);
  });

  testWidgets('switching the active language switches word decks',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/lessons');
    expect(find.text('Test Lesson'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);

    await tester.tap(find.byKey(const Key('switch-ko')));
    await settle(tester);
    await tapTab(tester, 'Home');
    expect(find.byKey(const Key('course-ko')), findsOneWidget);
    await goTo(tester, '/lessons');
    expect(find.text('Test Lesson'), findsNothing);
    expect(find.text('Korean lessons'), findsOneWidget);
    await finish(tester, app);
  });
}
