import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('shows "all caught up" when nothing is due', (tester) async {
    final app = await pumpLingo(tester, seed: false);
    await goTo(tester, '/review');
    expect(find.text('All caught up!'), findsOneWidget);
    await finish(tester, app);
  });

  testWidgets('card flips, speaks and advances on rating', (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/review');

    expect(find.text('Hallo'), findsOneWidget);
    expect(find.text('Hello'), findsNothing);

    await tester.tap(find.byIcon(Icons.volume_up));
    await tester.pump();
    expect(app.tts.spoken, ['Hallo']);

    await tapText(tester, 'Show answer');
    expect(find.text('Hello'), findsOneWidget);
    for (final label in ['Again', 'Hard', 'Good', 'Easy']) {
      expect(find.text(label), findsOneWidget);
    }

    await tapText(tester, 'Good');
    expect(find.text('Danke'), findsOneWidget);
    expect(find.text('Show answer'), findsOneWidget);

    final row = await tester.runAsync(() => app.db.getReviewRow('c1'));
    expect(row!.repetitions, 1);
    expect(row.stability, greaterThan(0)); // FSRS is the default
    await finish(tester, app);
  });

  testWidgets('"Again" repeats the card at the end of the session',
      (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/review');

    await tapText(tester, 'Show answer');
    await tapText(tester, 'Again'); // Hallo goes to the back of the queue
    expect(find.text('Danke'), findsOneWidget);

    await tapText(tester, 'Show answer');
    await tapText(tester, 'Good');
    expect(find.text('Hallo'), findsOneWidget);

    await tapText(tester, 'Show answer');
    await tapText(tester, 'Good');
    expect(find.text('Session complete'), findsOneWidget);
    expect(textContaining('3 cards'), findsOneWidget);
    await finish(tester, app);
  });
}
