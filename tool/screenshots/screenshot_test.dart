// Renders screenshots of the main screens with real fonts on a phone-sized
// screen, for visual QA and the README.
//
//   flutter test tool/screenshots/screenshot_test.dart --update-goldens
//
// Output: docs/screenshots/*.png. Not part of the regular test suite.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syllivo/features/curriculum/grading.dart';
import 'package:syllivo/features/curriculum/models.dart';

import '../../test/curriculum_utils.dart';
import '../../test/helpers.dart';

Future<void> _font(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    if (File(p).existsSync()) {
      loader.addFont(Future.value(
          ByteData.view(Uint8List.fromList(File(p).readAsBytesSync()).buffer)));
    }
  }
  await loader.load();
}

void main() {
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ?? '/opt/sdk/flutter';
  late Curriculum de, ko;

  setUpAll(() async {
    de = await loadCurriculum('de');
    ko = await loadCurriculum('ko');
    // Noto Sans CJK covers Latin and Hangul, so one family renders both.
    await _font(
        'Roboto', ['/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc']);
    await _font('MaterialIcons', [
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf'
    ]);
  });

  Future<void> shot(WidgetTester tester, String name) async {
    await settle(tester);
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('../../docs/screenshots/$name.png'));
  }

  Future<void> openLesson(WidgetTester tester, String lang, String id) async {
    await goTo(tester, '/learn/$lang/lesson/$id');
    await startPractice(tester);
  }

  testWidgets('screenshots', (tester) async {
    final app = await pumpLingo(tester, onboarded: false, authChoice: null,
        prepare: (db) async {
      for (final lesson in de.levels.first.lessons.take(4)) {
        await db.finishLessonRun(
            lang: 'de',
            levelId: 'de_a1',
            moduleType: de.moduleOfLesson(lesson.id)!.type.name,
            lessonId: lesson.id,
            percent: 90,
            passed: true,
            now: testNow);
        await db.addXp('de', 10,
            'lesson:${de.moduleOfLesson(lesson.id)!.type.name}', testNow);
      }
      await db.addXp(
          'de', 8, 'review', testNow.subtract(const Duration(days: 1)));
      await db.addXp('de', 14, 'lesson:grammar',
          testNow.subtract(const Duration(days: 3)));
      await db.addStudyTime('de', 26 * 60000, testNow);
    });
    await shot(tester, '00_login');
    await tester.tap(find.byKey(const Key('continue-guest')));
    await settle(tester);
    await shot(tester, '01_onboarding');
    await tester.enterText(find.byKey(const Key('name-field')), 'Ravi');
    await tapText(tester, 'Get started');
    await shot(tester, '02_onboarding_language');
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('onboard-next')));
      await settle(tester);
    }
    await tester.tap(find.byKey(const Key('start-beginner')));
    await settle(tester);
    await tapText(tester, 'Go to Home');
    await shot(tester, '03_home');

    await tapTab(tester, 'Learn');
    await shot(tester, '04_journey');

    // Translation with tiles (A1 exercises, question 2), mid-answer.
    final ex = de.lesson('de_a1_exercises_1')!;
    await openLesson(tester, 'de', ex.id);
    await answerQuestion(tester, ex.questions[0], correct: true);
    await tapContinue(tester);
    await tester.tap(find.byKey(const Key('tile-0')));
    await tester.pump();
    await shot(tester, '05_translate_tiles');
    await tester.tap(find.byTooltip('Leave lesson (progress is saved)'));
    await settle(tester);

    // Picture question (Korean) answered correctly → feedback panel.
    final kv = ko.lesson('ko_l1_vocabulary_1')!;
    await openLesson(tester, 'ko', kv.id);
    for (final q in kv.questions) {
      if (q.type == 'image') {
        await tester.tap(find.byKey(Key('image-option-${q.answer}')));
        await tester.pump();
        await shot(tester, '06_picture_question');
        await tester.tap(find.byKey(const Key('check-answer')));
        await settle(tester);
        await shot(tester, '07_feedback_correct');
        break;
      }
      await answerQuestion(tester, q, correct: true);
      await tapContinue(tester);
    }
    await tester.tap(find.byTooltip('Leave lesson (progress is saved)'));
    await settle(tester);

    // Wrong answer feedback (A1 quiz).
    final quiz = de.lesson('de_a1_quiz_1')!;
    await openLesson(tester, 'de', quiz.id);
    await answerQuestion(tester, quiz.questions[0], correct: false);
    await shot(tester, '08_feedback_wrong');
    await tapContinue(tester);
    for (var i = 1; i < quiz.questions.length; i++) {
      await answerQuestion(tester, quiz.questions[i], correct: true);
      await tapContinue(tester);
    }
    await shot(tester, '09_lesson_complete');
    await tapText(tester, 'Back to journey');

    // Listening question (A1 listening) and speaking.
    final li = de.lesson('de_a1_listening_1')!;
    await openLesson(tester, 'de', li.id);
    await shot(tester, '10_listening');
    await tester.tap(find.byTooltip('Leave lesson (progress is saved)'));
    await settle(tester);
    await openLesson(tester, 'de', 'de_a1_speaking_1');
    await shot(tester, '11_speaking');
    await tester.tap(find.byTooltip('Leave lesson (progress is saved)'));
    await settle(tester);

    await tapTab(tester, 'Practice');
    await shot(tester, '12_practice');
    await tapTab(tester, 'Progress');
    await shot(tester, '13_progress');
    await tapTab(tester, 'Profile');
    await shot(tester, '14_profile');
    await tapTab(tester, 'Home');
    await tester.tap(find.byKey(const Key('language-chip')));
    await settle(tester);
    await shot(tester, '15_language_picker');
    Navigator.of(tester.element(find.text('Choose a language'))).pop();
    await settle(tester);

    await finish(tester, app);
  });

  testWidgets('placement flow screenshots', (tester) async {
    final app = await pumpLingo(tester);
    await goTo(tester, '/learn/de/placement');
    await shot(tester, '16_placement_intro');
    await tester.tap(find.byKey(const Key('start-placement')));
    await settle(tester);
    await shot(tester, '17_placement_question');
    for (final level in de.levels.take(2)) {
      for (final q in placementQuestionsFor(level)) {
        await answerQuestion(tester, q, correct: level.code == 'A1');
        await tapContinue(tester);
      }
    }
    await shot(tester, '18_placement_result');
    await tester.tap(find.byKey(const Key('accept-placement')));
    await settle(tester);
    await shot(tester, '19_course_welcome');
    await finish(tester, app);
  });
}
