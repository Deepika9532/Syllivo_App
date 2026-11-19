/// Curriculum content models, loaded from versioned JSON in
/// assets/curriculum/<lang>/<level>.json. All IDs are stable: progress is
/// keyed by them, so content updates never reset a learner's progress.
library;

import 'package:flutter/material.dart';

enum ModuleType {
  vocabulary('Vocabulary', Icons.style),
  grammar('Grammar', Icons.account_tree),
  reading('Reading', Icons.chrome_reader_mode),
  writing('Writing', Icons.edit_note),
  listening('Listening', Icons.headphones),
  speaking('Speaking', Icons.record_voice_over),
  pronunciation('Pronunciation', Icons.graphic_eq),
  conversation('Conversation', Icons.forum),
  exercises('Exercises', Icons.fitness_center),
  quiz('Quiz', Icons.quiz);

  final String label;
  final IconData icon;
  const ModuleType(this.label, this.icon);

  static ModuleType parse(String s) =>
      ModuleType.values.firstWhere((m) => m.name == s,
          orElse: () => throw FormatException('Unknown module type "$s"'));
}

/// One learning block shown before practice (explanation, example, table…).
class ContentBlock {
  final String
      type; // text | tip | example | table | dialogue | vocab | passage
  final Map<String, dynamic> data;
  const ContentBlock(this.type, this.data);

  factory ContentBlock.fromJson(Map<String, dynamic> j) =>
      ContentBlock(j['type'] as String, j);

  String? str(String key) => data[key] as String?;
  List<dynamic> list(String key) => (data[key] as List?) ?? const [];
}

class Question {
  final String id;
  final String type;
  final String prompt;
  final String? skill;
  final String? audio; // spoken by TTS (listening) or target text (speak)
  final String? explanation;
  final String? translation;
  final String? sample; // model answer for writing
  final List<String> options;
  final int? answer; // index into options
  final List<String> answers; // accepted text answers
  final List<List<String>> pairs; // matching
  final List<String> words; // ordering: correct order
  final int minWords;
  final List<String> keywords; // writing: each entry may be "a|b"
  final List<String> images; // picture questions: illustration ids per option

  const Question({
    required this.id,
    required this.type,
    required this.prompt,
    this.skill,
    this.audio,
    this.explanation,
    this.translation,
    this.sample,
    this.options = const [],
    this.answer,
    this.answers = const [],
    this.pairs = const [],
    this.words = const [],
    this.minWords = 0,
    this.keywords = const [],
    this.images = const [],
  });

  static const types = {
    'mcq', 'fill', 'match', 'order', 'translate', 'listening', 'correction', //
    'speak', 'pronounce', 'write', 'image',
  };

  /// Speaking and writing need a microphone or open answers, so they are
  /// practised in lessons but never used in examinations.
  bool get autoGradable => !{'speak', 'pronounce', 'write'}.contains(type);
  bool get isSpeech => type == 'speak' || type == 'pronounce';

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as String,
        type: j['type'] as String,
        prompt: (j['prompt'] ?? '') as String,
        skill: j['skill'] as String?,
        audio: j['audio'] as String?,
        explanation: j['explanation'] as String?,
        translation: j['translation'] as String?,
        sample: j['sample'] as String?,
        options: _strings(j['options']),
        answer: j['answer'] as int?,
        answers: _strings(j['answers']),
        pairs: ((j['pairs'] as List?) ?? const [])
            .map((p) => _strings(p))
            .toList(),
        words: _strings(j['words']),
        minWords: (j['minWords'] ?? 0) as int,
        keywords: _strings(j['keywords']),
        images: _strings(j['images']),
      );

  static List<String> _strings(dynamic v) =>
      ((v as List?) ?? const []).map((e) => e.toString()).toList();
}

class Lesson {
  final String id;
  final String title;
  final String? summary;
  final List<ContentBlock> blocks;
  final List<Question> questions;

  const Lesson({
    required this.id,
    required this.title,
    this.summary,
    required this.blocks,
    required this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> j) => Lesson(
        id: j['id'] as String,
        title: j['title'] as String,
        summary: j['summary'] as String?,
        blocks: ((j['blocks'] as List?) ?? const [])
            .map((b) => ContentBlock.fromJson(b as Map<String, dynamic>))
            .toList(),
        questions: ((j['questions'] as List?) ?? const [])
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

class CurriculumModule {
  final String id;
  final ModuleType type;
  final String title;
  final List<Lesson> lessons;

  const CurriculumModule({
    required this.id,
    required this.type,
    required this.title,
    required this.lessons,
  });

  factory CurriculumModule.fromJson(Map<String, dynamic> j) => CurriculumModule(
        id: j['id'] as String,
        type: ModuleType.parse(j['type'] as String),
        title: j['title'] as String,
        lessons: (j['lessons'] as List)
            .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
            .toList(),
      );
}

class Level {
  final String id;
  final String lang;
  final String code; // A1 … C2, or L1 … L6
  final String title;
  final String description;
  final String? alignment; // e.g. "Aligned with TOPIK I (levels 1–2)"
  final int order;
  final int version;
  final List<String> topics;
  final List<CurriculumModule> modules;
  final List<Question> exam;

  const Level({
    required this.id,
    required this.lang,
    required this.code,
    required this.title,
    required this.description,
    this.alignment,
    required this.order,
    required this.version,
    required this.topics,
    required this.modules,
    required this.exam,
  });

  Iterable<Lesson> get lessons => modules.expand((m) => m.lessons);

  factory Level.fromJson(Map<String, dynamic> j) => Level(
        id: j['id'] as String,
        lang: j['lang'] as String,
        code: j['code'] as String,
        title: j['title'] as String,
        description: j['description'] as String,
        alignment: j['alignment'] as String?,
        order: j['order'] as int,
        version: (j['version'] ?? 1) as int,
        topics: ((j['topics'] as List?) ?? const []).cast<String>(),
        modules: (j['modules'] as List)
            .map((m) => CurriculumModule.fromJson(m as Map<String, dynamic>))
            .toList(),
        exam: ((j['exam'] as List?) ?? const [])
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

class Curriculum {
  final String lang;
  final List<Level> levels; // sorted by order

  Curriculum(this.lang, List<Level> levels)
      : levels = [...levels]..sort((a, b) => a.order.compareTo(b.order));

  late final Map<String, Lesson> _lessons = {
    for (final l in levels)
      for (final lesson in l.lessons) lesson.id: lesson,
  };

  late final Map<String, ({Level level, CurriculumModule module})> _owner = {
    for (final l in levels)
      for (final m in l.modules)
        for (final lesson in m.lessons) lesson.id: (level: l, module: m),
  };

  Lesson? lesson(String id) => _lessons[id];
  Level? levelOfLesson(String id) => _owner[id]?.level;
  CurriculumModule? moduleOfLesson(String id) => _owner[id]?.module;
  Level? level(String id) {
    for (final l in levels) {
      if (l.id == id) return l;
    }
    return null;
  }

  int get totalLessons => _lessons.length;
}
