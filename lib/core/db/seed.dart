import 'dart:convert';

import 'package:flutter/services.dart';

import '../../features/curriculum/curriculum_repository.dart';
import '../content/lesson_pack.dart';
import 'app_database.dart';

/// Bundled lesson packs. Add a file here and in assets/ to ship new content.
const contentPacks = [
  'assets/content/de/greetings.json',
  'assets/content/de/numbers.json',
  'assets/content/de/food.json',
  'assets/content/de/family.json',
  'assets/content/de/travel.json',
  'assets/content/de/days.json',
  'assets/content/ko/hangul_vowels.json',
  'assets/content/ko/hangul_consonants.json',
  'assets/content/ko/greetings.json',
  'assets/content/ko/numbers.json',
  'assets/content/ko/food.json',
  'assets/content/ko/family.json',
  'assets/content/ko/travel.json',
];

/// Seeds (or upgrades) bundled content into the local DB. Runs on every
/// launch; unchanged packs are skipped by version, so it is cheap.
Future<void> seedContent(AppDatabase db,
    {AssetBundle? bundle, CurriculumRepository? curriculum}) async {
  final assets = bundle ?? rootBundle;
  final now = DateTime.now();
  for (final path in contentPacks) {
    final json =
        jsonDecode(await assets.loadString(path)) as Map<String, dynamic>;
    await db.upsertPack(LessonPack.fromJson(json), now);
  }
  // Curriculum vocabulary joins the spaced-repetition queue as decks.
  final repo = curriculum ?? CurriculumRepository(assets);
  for (final lang in (await repo.index()).keys) {
    final c = await repo.load(lang);
    for (final level in c.levels) {
      await db.upsertPack(vocabDeckFor(level), now);
    }
  }
}
