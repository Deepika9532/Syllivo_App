// Renders the Syllivo launcher icon from the companion painter.
//   flutter test tool/brand/icon_test.dart --update-goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/app/theme.dart';
import 'package:syllivo/core/widgets/companion.dart';

void main() {
  testWidgets('launcher icon', (tester) async {
    tester.view.physicalSize = const Size(1024, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [SyllivoColors.lavender, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          alignment: Alignment.center,
          child: CustomPaint(
              size: const Size.square(780),
              painter: SylliPainter(mood: SylliMood.happy)),
        ),
      ),
    ));
    await expectLater(find.byType(RepaintBoundary).first,
        matchesGoldenFile('../../assets/brand/icon.png'));
  });
}
