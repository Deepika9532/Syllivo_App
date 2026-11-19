/// Lesson content as shipped in assets/content/<lang>/*.json.
class PackCard {
  final String id;
  final String front; // target-language text
  final String back; // English meaning
  final String audio; // text spoken by TTS / expected from STT
  final String? romanization;
  final String? example;

  const PackCard({
    required this.id,
    required this.front,
    required this.back,
    required this.audio,
    this.romanization,
    this.example,
  });

  factory PackCard.fromJson(Map<String, dynamic> j) => PackCard(
        id: j['id'] as String,
        front: j['front'] as String,
        back: j['back'] as String,
        audio: (j['audio'] ?? j['front']) as String,
        romanization: j['romanization'] as String?,
        example: j['example'] as String?,
      );
}

class LessonPack {
  final String id;
  final String lang;
  final String level;
  final String title;
  final int order;
  final int version;
  final List<PackCard> cards;

  const LessonPack({
    required this.id,
    required this.lang,
    required this.level,
    required this.title,
    required this.order,
    required this.version,
    required this.cards,
  });

  factory LessonPack.fromJson(Map<String, dynamic> j) => LessonPack(
        id: j['id'] as String,
        lang: j['lang'] as String,
        level: j['level'] as String,
        title: j['title'] as String,
        order: j['order'] as int,
        version: (j['version'] ?? 1) as int,
        cards: (j['cards'] as List)
            .map((c) => PackCard.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}
