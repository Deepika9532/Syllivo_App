/// Pure grading, scoring and progression rules (no Flutter, no DB), so they
/// can be unit-tested exhaustively.
library;

import '../../core/speech/pronunciation_scorer.dart';
import '../../core/utils/text_normalizer.dart';
import 'models.dart';

const defaultPassPercent = 80;
const speechPassScore = 70;

class AnswerResult {
  final bool correct;
  final String expected; // shown as the correct answer
  final String given;
  final bool skipped; // e.g. speech recognition unavailable
  final bool selfAssessed;
  final int? score; // pronunciation score 0..100

  const AnswerResult({
    required this.correct,
    required this.expected,
    this.given = '',
    this.skipped = false,
    this.selfAssessed = false,
    this.score,
  });

  const AnswerResult.skipped(this.expected)
      : correct = false,
        given = '',
        skipped = true,
        selfAssessed = false,
        score = null;
}

bool textMatches(String input, List<String> accepted, String lang) {
  final given = normalizeForCompare(input, lang);
  if (given.isEmpty) return false;
  return accepted.any((a) => normalizeForCompare(a, lang) == given);
}

AnswerResult gradeChoice(Question q, int? choice) => AnswerResult(
      correct: choice != null && choice == q.answer,
      expected: q.options[q.answer!],
      given: choice == null ? '' : q.options[choice],
    );

AnswerResult gradeText(Question q, String input, String lang) => AnswerResult(
      correct: textMatches(input, q.answers, lang),
      expected: q.answers.first,
      given: input,
    );

AnswerResult gradeOrder(Question q, List<String> arranged, String lang) {
  final expected = q.words.join(' ');
  return AnswerResult(
    correct: textMatches(arranged.join(' '), [expected], lang),
    expected: expected,
    given: arranged.join(' '),
  );
}

/// [mapping] maps left index → chosen right index (right side in the
/// original pair order).
AnswerResult gradeMatch(Question q, Map<int, int> mapping) {
  final correct = mapping.length == q.pairs.length &&
      mapping.entries.every((e) => e.key == e.value);
  return AnswerResult(
    correct: correct,
    expected: q.pairs.map((p) => '${p[0]} = ${p[1]}').join(', '),
  );
}

AnswerResult gradeSpeech(Question q, String heard, String lang) {
  final r = PronunciationScorer.score(
      expected: q.audio ?? q.prompt, heard: heard, lang: lang);
  return AnswerResult(
    correct: r.score >= speechPassScore,
    expected: q.audio ?? q.prompt,
    given: heard,
    score: r.score,
  );
}

class WritingCheck {
  final int wordCount;
  final int minWords;
  final List<String> missingKeywords;
  const WritingCheck(this.wordCount, this.minWords, this.missingKeywords);
  bool get passed => wordCount >= minWords && missingKeywords.isEmpty;
}

/// Automatic writing check: length and required words/structures. This is
/// a guide, not a teacher's assessment; the model answer is always shown.
WritingCheck checkWriting(Question q, String text, String lang) {
  final words = text
      .split(RegExp(r'\s+'))
      .where((w) => RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(w))
      .length;
  final norm = normalizeForCompare(text, lang);
  final missing = [
    for (final k in q.keywords)
      if (!k
          .split('|')
          .any((alt) => norm.contains(normalizeForCompare(alt, lang))))
        k.split('|').first,
  ];
  return WritingCheck(words, q.minWords, missing);
}

AnswerResult gradeWriting(Question q, String text, String lang) {
  final c = checkWriting(q, text, lang);
  return AnswerResult(
    correct: c.passed,
    expected: q.sample ?? '',
    given: text,
  );
}

class ScoreSummary {
  final int correct;
  final int answered; // excludes skipped
  final int skipped;
  final Map<String, ({int correct, int total})> bySkill;

  const ScoreSummary({
    required this.correct,
    required this.answered,
    required this.skipped,
    this.bySkill = const {},
  });

  double get percent => answered == 0 ? 0 : correct * 100 / answered;
  bool passed(int threshold) => answered > 0 && percent >= threshold;
}

ScoreSummary summarize(List<(Question, AnswerResult)> results) {
  var correct = 0, answered = 0, skipped = 0;
  final skills = <String, ({int correct, int total})>{};
  for (final (q, r) in results) {
    if (r.skipped) {
      skipped++;
      continue;
    }
    answered++;
    if (r.correct) correct++;
    final s = q.skill ?? q.type;
    final prev = skills[s] ?? (correct: 0, total: 0);
    skills[s] = (
      correct: prev.correct + (r.correct ? 1 : 0),
      total: prev.total + 1,
    );
  }
  return ScoreSummary(
      correct: correct, answered: answered, skipped: skipped, bySkill: skills);
}

// ---------------- Progression ----------------

/// A level is unlocked if it is at or below the learner's chosen/placed
/// starting level, or directly after the highest level whose exam passed.
Set<String> unlockedLevels(
  List<Level> levels, {
  String? startLevelId,
  required Set<String> passedExams,
}) {
  var limit = 0;
  for (var i = 0; i < levels.length; i++) {
    if (levels[i].id == startLevelId && i > limit) limit = i;
    if (passedExams.contains(levels[i].id) && i + 1 > limit) limit = i + 1;
  }
  return {
    for (var i = 0; i <= limit && i < levels.length; i++) levels[i].id,
  };
}

/// Completion needs every lesson in every module passed AND the level
/// examination passed. Flashcard reviews alone never complete a level.
bool levelCompleted(
        Level level, Set<String> completedLessons, Set<String> passedExams) =>
    passedExams.contains(level.id) &&
    level.lessons.every((l) => completedLessons.contains(l.id));

double levelProgress(
    Level level, Set<String> completedLessons, Set<String> passedExams) {
  final lessons = level.lessons.toList();
  final units = lessons.length + 1; // + exam
  final done = lessons.where((l) => completedLessons.contains(l.id)).length +
      (passedExams.contains(level.id) ? 1 : 0);
  return done / units;
}

// ---------------- Placement ----------------

const placementPerLevel = 3;

List<Question> placementQuestionsFor(Level level) =>
    level.exam.where((q) => q.autoGradable).take(placementPerLevel).toList();

/// Walks levels in order; the recommendation is the first level where the
/// learner answered fewer than 2 of 3 correctly (or the last level).
String recommendLevel(
    List<Level> levels, Map<String, ({int correct, int total})> results) {
  for (final l in levels) {
    final r = results[l.id];
    if (r == null) return l.id;
    if (r.total == 0 || r.correct * 3 < r.total * 2) return l.id;
  }
  return levels.last.id;
}
