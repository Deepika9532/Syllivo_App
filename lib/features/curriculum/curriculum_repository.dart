import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/content/lesson_pack.dart';
import '../../core/widgets/illustrations.dart';
import 'models.dart';

const curriculumIndexPath = 'assets/curriculum/index.json';

/// Loads bundled curriculum JSON (fully offline) and validates it, so a
/// broken content file fails loudly in tests instead of silently in the UI.
class CurriculumRepository {
  final AssetBundle bundle;
  final _cache = <String, Future<Curriculum>>{};

  CurriculumRepository(this.bundle);

  Future<Map<String, List<String>>> index() async {
    final raw = jsonDecode(await bundle.loadString(curriculumIndexPath))
        as Map<String, dynamic>;
    return raw.map((k, v) => MapEntry(k, (v as List).cast<String>()));
  }

  Future<Curriculum> load(String lang) => _cache[lang] ??= _load(lang);

  Future<Curriculum> _load(String lang) async {
    final files = (await index())[lang] ?? const [];
    final levels = <Level>[];
    for (final path in files) {
      final json =
          jsonDecode(await bundle.loadString(path)) as Map<String, dynamic>;
      levels.add(Level.fromJson(json));
    }
    final errors = validateCurriculum(lang, levels);
    if (errors.isNotEmpty) {
      throw FormatException(
          'Invalid curriculum "$lang":\n${errors.join('\n')}');
    }
    return Curriculum(lang, levels);
  }
}

/// Structural and content checks for every level, module, lesson and
/// question. Returns human-readable errors (empty = valid).
List<String> validateCurriculum(String lang, List<Level> levels) {
  final errors = <String>[];
  final ids = <String>{};
  void id(String v) {
    if (!ids.add(v)) errors.add('Duplicate id: $v');
  }

  final orders = levels.map((l) => l.order).toList();
  if (orders.toSet().length != orders.length) {
    errors.add('Duplicate level order');
  }

  for (final level in levels) {
    id(level.id);
    final where = level.id;
    if (level.lang != lang) errors.add('$where: lang ${level.lang} != $lang');
    for (final type in ModuleType.values) {
      if (!level.modules.any((m) => m.type == type)) {
        errors.add('$where: missing ${type.name} module');
      }
    }
    for (final m in level.modules) {
      id(m.id);
      if (m.lessons.isEmpty) errors.add('${m.id}: no lessons');
      for (final lesson in m.lessons) {
        id(lesson.id);
        if (lesson.blocks.isEmpty) errors.add('${lesson.id}: no content');
        if (lesson.questions.length < 3) {
          errors.add('${lesson.id}: needs at least 3 questions');
        }
        if (!lesson.questions.any((q) => q.autoGradable)) {
          errors.add('${lesson.id}: needs an auto-graded question so it can be '
              'completed without a microphone');
        }
        for (final q in lesson.questions) {
          id(q.id);
          errors.addAll(validateQuestion(q));
        }
      }
    }
    if (level.exam.length < 10) errors.add('$where: exam needs 10+ questions');
    for (final q in level.exam) {
      id(q.id);
      errors.addAll(validateQuestion(q));
      if (!q.autoGradable) {
        errors.add('${q.id}: exam questions must be auto-graded');
      }
      if (q.skill == null) errors.add('${q.id}: exam question needs a skill');
    }
  }
  return errors;
}

List<String> validateQuestion(Question q) {
  final e = <String>[];
  void need(bool ok, String msg) {
    if (!ok) e.add('${q.id}: $msg');
  }

  need(Question.types.contains(q.type), 'unknown type ${q.type}');
  switch (q.type) {
    case 'image':
      need(q.options.length >= 2 && q.images.length == q.options.length,
          'needs one illustration per option');
      need(q.answer != null && q.answer! >= 0 && q.answer! < q.options.length,
          'answer index out of range');
      for (final id in q.images) {
        need(illustrations.containsKey(id), 'unknown illustration "$id"');
      }
    case 'mcq':
    case 'listening':
      need(q.options.length >= 2, 'needs 2+ options');
      need(q.answer != null && q.answer! >= 0 && q.answer! < q.options.length,
          'answer index out of range');
      need(q.options.toSet().length == q.options.length, 'duplicate options');
      if (q.type == 'listening') {
        need((q.audio ?? '').isNotEmpty, 'needs audio');
      }
    case 'fill':
    case 'translate':
    case 'correction':
      need(q.answers.isNotEmpty, 'needs accepted answers');
    case 'match':
      need(q.pairs.length >= 2 && q.pairs.every((p) => p.length == 2),
          'needs 2+ pairs');
    case 'order':
      need(q.words.length >= 2, 'needs 2+ words');
    case 'speak':
    case 'pronounce':
      need((q.audio ?? '').isNotEmpty, 'needs target text');
    case 'write':
      need(q.minWords > 0, 'needs minWords');
      need((q.sample ?? '').isNotEmpty, 'needs a model answer');
  }
  if (q.type == 'order') {
    need(q.prompt.isNotEmpty || (q.translation ?? '').isNotEmpty,
        'needs a prompt or translation');
  } else if (q.type != 'speak' && q.type != 'pronounce' && q.type != 'match') {
    need(q.prompt.isNotEmpty, 'needs a prompt');
  }
  return e;
}

/// Turns a level's vocabulary into a flashcard deck so curriculum words
/// join the existing FSRS review queue.
LessonPack vocabDeckFor(Level level) {
  final cards = <PackCard>[];
  final seen = <String>{};
  for (final m in level.modules.where((m) => m.type == ModuleType.vocabulary)) {
    for (final lesson in m.lessons) {
      for (final b in lesson.blocks.where((b) => b.type == 'vocab')) {
        for (final item in b.list('items')) {
          final i = item as Map<String, dynamic>;
          final target = i['target'] as String;
          final id = '${level.id}_v_${_slug(target)}';
          if (!seen.add(id)) continue;
          cards.add(PackCard(
            id: id,
            front: target,
            back: i['en'] as String,
            audio: (i['audio'] ?? target) as String,
            romanization: level.lang == 'ko' ? i['pron'] as String? : null,
            example: i['example'] as String?,
          ));
        }
      }
    }
  }
  return LessonPack(
    id: '${level.id}_vocab',
    lang: level.lang,
    level: level.code,
    title: '${level.code} · Curriculum vocabulary',
    order: 100 + level.order,
    version: level.version,
    cards: cards,
  );
}

String _slug(String s) => s.runes
    .map((r) => (r >= 0x30 && r <= 0x39) ||
            (r >= 0x61 && r <= 0x7a) ||
            (r >= 0x41 && r <= 0x5a)
        ? String.fromCharCode(r).toLowerCase()
        : (r > 0x7f ? r.toRadixString(16) : '_'))
    .join();
