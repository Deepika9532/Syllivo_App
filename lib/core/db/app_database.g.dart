// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, langCode, level, title, sortOrder, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<Lesson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final String id;
  final String langCode;
  final String level;
  final String title;
  final int sortOrder;
  final int version;
  const Lesson(
      {required this.id,
      required this.langCode,
      required this.level,
      required this.title,
      required this.sortOrder,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang_code'] = Variable<String>(langCode);
    map['level'] = Variable<String>(level);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      langCode: Value(langCode),
      level: Value(level),
      title: Value(title),
      sortOrder: Value(sortOrder),
      version: Value(version),
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<String>(json['id']),
      langCode: serializer.fromJson<String>(json['langCode']),
      level: serializer.fromJson<String>(json['level']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'langCode': serializer.toJson<String>(langCode),
      'level': serializer.toJson<String>(level),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
    };
  }

  Lesson copyWith(
          {String? id,
          String? langCode,
          String? level,
          String? title,
          int? sortOrder,
          int? version}) =>
      Lesson(
        id: id ?? this.id,
        langCode: langCode ?? this.langCode,
        level: level ?? this.level,
        title: title ?? this.title,
        sortOrder: sortOrder ?? this.sortOrder,
        version: version ?? this.version,
      );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      level: data.level.present ? data.level.value : this.level,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, langCode, level, title, sortOrder, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.langCode == this.langCode &&
          other.level == this.level &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<String> id;
  final Value<String> langCode;
  final Value<String> level;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.langCode = const Value.absent(),
    this.level = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String langCode,
    required String level,
    required String title,
    required int sortOrder,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        langCode = Value(langCode),
        level = Value(level),
        title = Value(title),
        sortOrder = Value(sortOrder);
  static Insertable<Lesson> custom({
    Expression<String>? id,
    Expression<String>? langCode,
    Expression<String>? level,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langCode != null) 'lang_code': langCode,
      if (level != null) 'level': level,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? langCode,
      Value<String>? level,
      Value<String>? title,
      Value<int>? sortOrder,
      Value<int>? version,
      Value<int>? rowid}) {
    return LessonsCompanion(
      id: id ?? this.id,
      langCode: langCode ?? this.langCode,
      level: level ?? this.level,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, FlashCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
      'front', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
      'back', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _romanizationMeta =
      const VerificationMeta('romanization');
  @override
  late final GeneratedColumn<String> romanization = GeneratedColumn<String>(
      'romanization', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioTextMeta =
      const VerificationMeta('audioText');
  @override
  late final GeneratedColumn<String> audioText = GeneratedColumn<String>(
      'audio_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleMeta =
      const VerificationMeta('example');
  @override
  late final GeneratedColumn<String> example = GeneratedColumn<String>(
      'example', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, position, front, back, romanization, audioText, example];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<FlashCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
          _frontMeta, front.isAcceptableOrUnknown(data['front']!, _frontMeta));
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
          _backMeta, back.isAcceptableOrUnknown(data['back']!, _backMeta));
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('romanization')) {
      context.handle(
          _romanizationMeta,
          romanization.isAcceptableOrUnknown(
              data['romanization']!, _romanizationMeta));
    }
    if (data.containsKey('audio_text')) {
      context.handle(_audioTextMeta,
          audioText.isAcceptableOrUnknown(data['audio_text']!, _audioTextMeta));
    } else if (isInserting) {
      context.missing(_audioTextMeta);
    }
    if (data.containsKey('example')) {
      context.handle(_exampleMeta,
          example.isAcceptableOrUnknown(data['example']!, _exampleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      front: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}front'])!,
      back: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}back'])!,
      romanization: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}romanization']),
      audioText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_text'])!,
      example: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example']),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class FlashCard extends DataClass implements Insertable<FlashCard> {
  final String id;
  final String lessonId;
  final int position;
  final String front;
  final String back;
  final String? romanization;
  final String audioText;
  final String? example;
  const FlashCard(
      {required this.id,
      required this.lessonId,
      required this.position,
      required this.front,
      required this.back,
      this.romanization,
      required this.audioText,
      this.example});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    if (!nullToAbsent || romanization != null) {
      map['romanization'] = Variable<String>(romanization);
    }
    map['audio_text'] = Variable<String>(audioText);
    if (!nullToAbsent || example != null) {
      map['example'] = Variable<String>(example);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      position: Value(position),
      front: Value(front),
      back: Value(back),
      romanization: romanization == null && nullToAbsent
          ? const Value.absent()
          : Value(romanization),
      audioText: Value(audioText),
      example: example == null && nullToAbsent
          ? const Value.absent()
          : Value(example),
    );
  }

  factory FlashCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashCard(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      romanization: serializer.fromJson<String?>(json['romanization']),
      audioText: serializer.fromJson<String>(json['audioText']),
      example: serializer.fromJson<String?>(json['example']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'romanization': serializer.toJson<String?>(romanization),
      'audioText': serializer.toJson<String>(audioText),
      'example': serializer.toJson<String?>(example),
    };
  }

  FlashCard copyWith(
          {String? id,
          String? lessonId,
          int? position,
          String? front,
          String? back,
          Value<String?> romanization = const Value.absent(),
          String? audioText,
          Value<String?> example = const Value.absent()}) =>
      FlashCard(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        position: position ?? this.position,
        front: front ?? this.front,
        back: back ?? this.back,
        romanization:
            romanization.present ? romanization.value : this.romanization,
        audioText: audioText ?? this.audioText,
        example: example.present ? example.value : this.example,
      );
  FlashCard copyWithCompanion(CardsCompanion data) {
    return FlashCard(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      romanization: data.romanization.present
          ? data.romanization.value
          : this.romanization,
      audioText: data.audioText.present ? data.audioText.value : this.audioText,
      example: data.example.present ? data.example.value : this.example,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashCard(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('romanization: $romanization, ')
          ..write('audioText: $audioText, ')
          ..write('example: $example')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, lessonId, position, front, back, romanization, audioText, example);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashCard &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.front == this.front &&
          other.back == this.back &&
          other.romanization == this.romanization &&
          other.audioText == this.audioText &&
          other.example == this.example);
}

class CardsCompanion extends UpdateCompanion<FlashCard> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> front;
  final Value<String> back;
  final Value<String?> romanization;
  final Value<String> audioText;
  final Value<String?> example;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.romanization = const Value.absent(),
    this.audioText = const Value.absent(),
    this.example = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String lessonId,
    required int position,
    required String front,
    required String back,
    this.romanization = const Value.absent(),
    required String audioText,
    this.example = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        position = Value(position),
        front = Value(front),
        back = Value(back),
        audioText = Value(audioText);
  static Insertable<FlashCard> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? romanization,
    Expression<String>? audioText,
    Expression<String>? example,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (romanization != null) 'romanization': romanization,
      if (audioText != null) 'audio_text': audioText,
      if (example != null) 'example': example,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<int>? position,
      Value<String>? front,
      Value<String>? back,
      Value<String?>? romanization,
      Value<String>? audioText,
      Value<String?>? example,
      Value<int>? rowid}) {
    return CardsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      front: front ?? this.front,
      back: back ?? this.back,
      romanization: romanization ?? this.romanization,
      audioText: audioText ?? this.audioText,
      example: example ?? this.example,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (romanization.present) {
      map['romanization'] = Variable<String>(romanization.value);
    }
    if (audioText.present) {
      map['audio_text'] = Variable<String>(audioText.value);
    }
    if (example.present) {
      map['example'] = Variable<String>(example.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('romanization: $romanization, ')
          ..write('audioText: $audioText, ')
          ..write('example: $example, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewStatesTable extends ReviewStates
    with TableInfo<$ReviewStatesTable, ReviewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _stabilityMeta =
      const VerificationMeta('stability');
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
      'stability', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cardId,
        easeFactor,
        intervalDays,
        repetitions,
        lapses,
        dueAt,
        stability,
        difficulty,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_states';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(_stabilityMeta,
          stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  ReviewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewRow(
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      lapses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      stability: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stability'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $ReviewStatesTable createAlias(String alias) {
    return $ReviewStatesTable(attachedDatabase, alias);
  }
}

class ReviewRow extends DataClass implements Insertable<ReviewRow> {
  final String cardId;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final DateTime dueAt;
  final double stability;
  final double difficulty;
  final DateTime? lastReviewedAt;
  const ReviewRow(
      {required this.cardId,
      required this.easeFactor,
      required this.intervalDays,
      required this.repetitions,
      required this.lapses,
      required this.dueAt,
      required this.stability,
      required this.difficulty,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  ReviewStatesCompanion toCompanion(bool nullToAbsent) {
    return ReviewStatesCompanion(
      cardId: Value(cardId),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      stability: Value(stability),
      difficulty: Value(difficulty),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory ReviewRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewRow(
      cardId: serializer.fromJson<String>(json['cardId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  ReviewRow copyWith(
          {String? cardId,
          double? easeFactor,
          int? intervalDays,
          int? repetitions,
          int? lapses,
          DateTime? dueAt,
          double? stability,
          double? difficulty,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      ReviewRow(
        cardId: cardId ?? this.cardId,
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        repetitions: repetitions ?? this.repetitions,
        lapses: lapses ?? this.lapses,
        dueAt: dueAt ?? this.dueAt,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  ReviewRow copyWithCompanion(ReviewStatesCompanion data) {
    return ReviewRow(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRow(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, easeFactor, intervalDays, repetitions,
      lapses, dueAt, stability, difficulty, lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewRow &&
          other.cardId == this.cardId &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.dueAt == this.dueAt &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class ReviewStatesCompanion extends UpdateCompanion<ReviewRow> {
  final Value<String> cardId;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<DateTime> dueAt;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const ReviewStatesCompanion({
    this.cardId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewStatesCompanion.insert({
    required String cardId,
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    required DateTime dueAt,
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : cardId = Value(cardId),
        dueAt = Value(dueAt);
  static Insertable<ReviewRow> custom({
    Expression<String>? cardId,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<DateTime>? dueAt,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (dueAt != null) 'due_at': dueAt,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewStatesCompanion copyWith(
      {Value<String>? cardId,
      Value<double>? easeFactor,
      Value<int>? intervalDays,
      Value<int>? repetitions,
      Value<int>? lapses,
      Value<DateTime>? dueAt,
      Value<double>? stability,
      Value<double>? difficulty,
      Value<DateTime?>? lastReviewedAt,
      Value<int>? rowid}) {
    return ReviewStatesCompanion(
      cardId: cardId ?? this.cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewStatesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _elapsedMsMeta =
      const VerificationMeta('elapsedMs');
  @override
  late final GeneratedColumn<int> elapsedMs = GeneratedColumn<int>(
      'elapsed_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, cardId, rating, reviewedAt, elapsedMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('elapsed_ms')) {
      context.handle(_elapsedMsMeta,
          elapsedMs.isAcceptableOrUnknown(data['elapsed_ms']!, _elapsedMsMeta));
    } else if (isInserting) {
      context.missing(_elapsedMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at'])!,
      elapsedMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}elapsed_ms'])!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final String cardId;
  final int rating;
  final DateTime reviewedAt;
  final int elapsedMs;
  const ReviewLog(
      {required this.id,
      required this.cardId,
      required this.rating,
      required this.reviewedAt,
      required this.elapsedMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['rating'] = Variable<int>(rating);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['elapsed_ms'] = Variable<int>(elapsedMs);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      elapsedMs: Value(elapsedMs),
    );
  }

  factory ReviewLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      rating: serializer.fromJson<int>(json['rating']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      elapsedMs: serializer.fromJson<int>(json['elapsedMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'rating': serializer.toJson<int>(rating),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'elapsedMs': serializer.toJson<int>(elapsedMs),
    };
  }

  ReviewLog copyWith(
          {int? id,
          String? cardId,
          int? rating,
          DateTime? reviewedAt,
          int? elapsedMs}) =>
      ReviewLog(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        rating: rating ?? this.rating,
        reviewedAt: reviewedAt ?? this.reviewedAt,
        elapsedMs: elapsedMs ?? this.elapsedMs,
      );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
      elapsedMs: data.elapsedMs.present ? data.elapsedMs.value : this.elapsedMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('elapsedMs: $elapsedMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, rating, reviewedAt, elapsedMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.elapsedMs == this.elapsedMs);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<int> rating;
  final Value<DateTime> reviewedAt;
  final Value<int> elapsedMs;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.elapsedMs = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required int rating,
    required DateTime reviewedAt,
    required int elapsedMs,
  })  : cardId = Value(cardId),
        rating = Value(rating),
        reviewedAt = Value(reviewedAt),
        elapsedMs = Value(elapsedMs);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<int>? rating,
    Expression<DateTime>? reviewedAt,
    Expression<int>? elapsedMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (elapsedMs != null) 'elapsed_ms': elapsedMs,
    });
  }

  ReviewLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? cardId,
      Value<int>? rating,
      Value<DateTime>? reviewedAt,
      Value<int>? elapsedMs}) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      elapsedMs: elapsedMs ?? this.elapsedMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (elapsedMs.present) {
      map['elapsed_ms'] = Variable<int>(elapsedMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('elapsedMs: $elapsedMs')
          ..write(')'))
        .toString();
  }
}

class $PronunciationAttemptsTable extends PronunciationAttempts
    with TableInfo<$PronunciationAttemptsTable, PronunciationAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PronunciationAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recognizedMeta =
      const VerificationMeta('recognized');
  @override
  late final GeneratedColumn<String> recognized = GeneratedColumn<String>(
      'recognized', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, cardId, recognized, score, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pronunciation_attempts';
  @override
  VerificationContext validateIntegrity(
      Insertable<PronunciationAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('recognized')) {
      context.handle(
          _recognizedMeta,
          recognized.isAcceptableOrUnknown(
              data['recognized']!, _recognizedMeta));
    } else if (isInserting) {
      context.missing(_recognizedMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PronunciationAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PronunciationAttempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      recognized: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recognized'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
    );
  }

  @override
  $PronunciationAttemptsTable createAlias(String alias) {
    return $PronunciationAttemptsTable(attachedDatabase, alias);
  }
}

class PronunciationAttempt extends DataClass
    implements Insertable<PronunciationAttempt> {
  final int id;
  final String cardId;
  final String recognized;
  final int score;
  final DateTime at;
  const PronunciationAttempt(
      {required this.id,
      required this.cardId,
      required this.recognized,
      required this.score,
      required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['recognized'] = Variable<String>(recognized);
    map['score'] = Variable<int>(score);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  PronunciationAttemptsCompanion toCompanion(bool nullToAbsent) {
    return PronunciationAttemptsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      recognized: Value(recognized),
      score: Value(score),
      at: Value(at),
    );
  }

  factory PronunciationAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PronunciationAttempt(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      recognized: serializer.fromJson<String>(json['recognized']),
      score: serializer.fromJson<int>(json['score']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'recognized': serializer.toJson<String>(recognized),
      'score': serializer.toJson<int>(score),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  PronunciationAttempt copyWith(
          {int? id,
          String? cardId,
          String? recognized,
          int? score,
          DateTime? at}) =>
      PronunciationAttempt(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        recognized: recognized ?? this.recognized,
        score: score ?? this.score,
        at: at ?? this.at,
      );
  PronunciationAttempt copyWithCompanion(PronunciationAttemptsCompanion data) {
    return PronunciationAttempt(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      recognized:
          data.recognized.present ? data.recognized.value : this.recognized,
      score: data.score.present ? data.score.value : this.score,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PronunciationAttempt(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('recognized: $recognized, ')
          ..write('score: $score, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, recognized, score, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PronunciationAttempt &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.recognized == this.recognized &&
          other.score == this.score &&
          other.at == this.at);
}

class PronunciationAttemptsCompanion
    extends UpdateCompanion<PronunciationAttempt> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<String> recognized;
  final Value<int> score;
  final Value<DateTime> at;
  const PronunciationAttemptsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.recognized = const Value.absent(),
    this.score = const Value.absent(),
    this.at = const Value.absent(),
  });
  PronunciationAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required String recognized,
    required int score,
    required DateTime at,
  })  : cardId = Value(cardId),
        recognized = Value(recognized),
        score = Value(score),
        at = Value(at);
  static Insertable<PronunciationAttempt> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<String>? recognized,
    Expression<int>? score,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (recognized != null) 'recognized': recognized,
      if (score != null) 'score': score,
      if (at != null) 'at': at,
    });
  }

  PronunciationAttemptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? cardId,
      Value<String>? recognized,
      Value<int>? score,
      Value<DateTime>? at}) {
    return PronunciationAttemptsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      recognized: recognized ?? this.recognized,
      score: score ?? this.score,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (recognized.present) {
      map['recognized'] = Variable<String>(recognized.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PronunciationAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('recognized: $recognized, ')
          ..write('score: $score, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, ProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastActiveDateMeta =
      const VerificationMeta('lastActiveDate');
  @override
  late final GeneratedColumn<DateTime> lastActiveDate =
      GeneratedColumn<DateTime>('last_active_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dailyGoalMeta =
      const VerificationMeta('dailyGoal');
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
      'daily_goal', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(20));
  @override
  List<GeneratedColumn> get $columns => [id, streak, lastActiveDate, dailyGoal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('last_active_date')) {
      context.handle(
          _lastActiveDateMeta,
          lastActiveDate.isAcceptableOrUnknown(
              data['last_active_date']!, _lastActiveDateMeta));
    }
    if (data.containsKey('daily_goal')) {
      context.handle(_dailyGoalMeta,
          dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      lastActiveDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_active_date']),
      dailyGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_goal'])!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class ProgressRow extends DataClass implements Insertable<ProgressRow> {
  final int id;
  final int streak;
  final DateTime? lastActiveDate;
  final int dailyGoal;
  const ProgressRow(
      {required this.id,
      required this.streak,
      this.lastActiveDate,
      required this.dailyGoal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak'] = Variable<int>(streak);
    if (!nullToAbsent || lastActiveDate != null) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate);
    }
    map['daily_goal'] = Variable<int>(dailyGoal);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      streak: Value(streak),
      lastActiveDate: lastActiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDate),
      dailyGoal: Value(dailyGoal),
    );
  }

  factory ProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressRow(
      id: serializer.fromJson<int>(json['id']),
      streak: serializer.fromJson<int>(json['streak']),
      lastActiveDate: serializer.fromJson<DateTime?>(json['lastActiveDate']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streak': serializer.toJson<int>(streak),
      'lastActiveDate': serializer.toJson<DateTime?>(lastActiveDate),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
    };
  }

  ProgressRow copyWith(
          {int? id,
          int? streak,
          Value<DateTime?> lastActiveDate = const Value.absent(),
          int? dailyGoal}) =>
      ProgressRow(
        id: id ?? this.id,
        streak: streak ?? this.streak,
        lastActiveDate:
            lastActiveDate.present ? lastActiveDate.value : this.lastActiveDate,
        dailyGoal: dailyGoal ?? this.dailyGoal,
      );
  ProgressRow copyWithCompanion(UserProgressCompanion data) {
    return ProgressRow(
      id: data.id.present ? data.id.value : this.id,
      streak: data.streak.present ? data.streak.value : this.streak,
      lastActiveDate: data.lastActiveDate.present
          ? data.lastActiveDate.value
          : this.lastActiveDate,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressRow(')
          ..write('id: $id, ')
          ..write('streak: $streak, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('dailyGoal: $dailyGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, streak, lastActiveDate, dailyGoal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressRow &&
          other.id == this.id &&
          other.streak == this.streak &&
          other.lastActiveDate == this.lastActiveDate &&
          other.dailyGoal == this.dailyGoal);
}

class UserProgressCompanion extends UpdateCompanion<ProgressRow> {
  final Value<int> id;
  final Value<int> streak;
  final Value<DateTime?> lastActiveDate;
  final Value<int> dailyGoal;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    this.dailyGoal = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    this.dailyGoal = const Value.absent(),
  });
  static Insertable<ProgressRow> custom({
    Expression<int>? id,
    Expression<int>? streak,
    Expression<DateTime>? lastActiveDate,
    Expression<int>? dailyGoal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streak != null) 'streak': streak,
      if (lastActiveDate != null) 'last_active_date': lastActiveDate,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
    });
  }

  UserProgressCompanion copyWith(
      {Value<int>? id,
      Value<int>? streak,
      Value<DateTime?>? lastActiveDate,
      Value<int>? dailyGoal}) {
    return UserProgressCompanion(
      id: id ?? this.id,
      streak: streak ?? this.streak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (lastActiveDate.present) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('streak: $streak, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('dailyGoal: $dailyGoal')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
      'level_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleTypeMeta =
      const VerificationMeta('moduleType');
  @override
  late final GeneratedColumn<String> moduleType = GeneratedColumn<String>(
      'module_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bestScoreMeta =
      const VerificationMeta('bestScore');
  @override
  late final GeneratedColumn<double> bestScore = GeneratedColumn<double>(
      'best_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runIndexMeta =
      const VerificationMeta('runIndex');
  @override
  late final GeneratedColumn<int> runIndex = GeneratedColumn<int>(
      'run_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runCorrectMeta =
      const VerificationMeta('runCorrect');
  @override
  late final GeneratedColumn<int> runCorrect = GeneratedColumn<int>(
      'run_correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runAnsweredMeta =
      const VerificationMeta('runAnswered');
  @override
  late final GeneratedColumn<int> runAnswered = GeneratedColumn<int>(
      'run_answered', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runSkippedMeta =
      const VerificationMeta('runSkipped');
  @override
  late final GeneratedColumn<int> runSkipped = GeneratedColumn<int>(
      'run_skipped', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        lessonId,
        langCode,
        levelId,
        moduleType,
        status,
        bestScore,
        attempts,
        runIndex,
        runCorrect,
        runAnswered,
        runSkipped,
        updatedAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(Insertable<LessonProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('module_type')) {
      context.handle(
          _moduleTypeMeta,
          moduleType.isAcceptableOrUnknown(
              data['module_type']!, _moduleTypeMeta));
    } else if (isInserting) {
      context.missing(_moduleTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('best_score')) {
      context.handle(_bestScoreMeta,
          bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('run_index')) {
      context.handle(_runIndexMeta,
          runIndex.isAcceptableOrUnknown(data['run_index']!, _runIndexMeta));
    }
    if (data.containsKey('run_correct')) {
      context.handle(
          _runCorrectMeta,
          runCorrect.isAcceptableOrUnknown(
              data['run_correct']!, _runCorrectMeta));
    }
    if (data.containsKey('run_answered')) {
      context.handle(
          _runAnsweredMeta,
          runAnswered.isAcceptableOrUnknown(
              data['run_answered']!, _runAnsweredMeta));
    }
    if (data.containsKey('run_skipped')) {
      context.handle(
          _runSkippedMeta,
          runSkipped.isAcceptableOrUnknown(
              data['run_skipped']!, _runSkippedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LessonProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressRow(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_id'])!,
      moduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      bestScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}best_score'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      runIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}run_index'])!,
      runCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}run_correct'])!,
      runAnswered: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}run_answered'])!,
      runSkipped: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}run_skipped'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressRow extends DataClass
    implements Insertable<LessonProgressRow> {
  final String lessonId;
  final String langCode;
  final String levelId;
  final String moduleType;
  final int status;
  final double bestScore;
  final int attempts;
  final int runIndex;
  final int runCorrect;
  final int runAnswered;
  final int runSkipped;
  final DateTime updatedAt;
  final DateTime? completedAt;
  const LessonProgressRow(
      {required this.lessonId,
      required this.langCode,
      required this.levelId,
      required this.moduleType,
      required this.status,
      required this.bestScore,
      required this.attempts,
      required this.runIndex,
      required this.runCorrect,
      required this.runAnswered,
      required this.runSkipped,
      required this.updatedAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['lang_code'] = Variable<String>(langCode);
    map['level_id'] = Variable<String>(levelId);
    map['module_type'] = Variable<String>(moduleType);
    map['status'] = Variable<int>(status);
    map['best_score'] = Variable<double>(bestScore);
    map['attempts'] = Variable<int>(attempts);
    map['run_index'] = Variable<int>(runIndex);
    map['run_correct'] = Variable<int>(runCorrect);
    map['run_answered'] = Variable<int>(runAnswered);
    map['run_skipped'] = Variable<int>(runSkipped);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      lessonId: Value(lessonId),
      langCode: Value(langCode),
      levelId: Value(levelId),
      moduleType: Value(moduleType),
      status: Value(status),
      bestScore: Value(bestScore),
      attempts: Value(attempts),
      runIndex: Value(runIndex),
      runCorrect: Value(runCorrect),
      runAnswered: Value(runAnswered),
      runSkipped: Value(runSkipped),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory LessonProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      langCode: serializer.fromJson<String>(json['langCode']),
      levelId: serializer.fromJson<String>(json['levelId']),
      moduleType: serializer.fromJson<String>(json['moduleType']),
      status: serializer.fromJson<int>(json['status']),
      bestScore: serializer.fromJson<double>(json['bestScore']),
      attempts: serializer.fromJson<int>(json['attempts']),
      runIndex: serializer.fromJson<int>(json['runIndex']),
      runCorrect: serializer.fromJson<int>(json['runCorrect']),
      runAnswered: serializer.fromJson<int>(json['runAnswered']),
      runSkipped: serializer.fromJson<int>(json['runSkipped']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'langCode': serializer.toJson<String>(langCode),
      'levelId': serializer.toJson<String>(levelId),
      'moduleType': serializer.toJson<String>(moduleType),
      'status': serializer.toJson<int>(status),
      'bestScore': serializer.toJson<double>(bestScore),
      'attempts': serializer.toJson<int>(attempts),
      'runIndex': serializer.toJson<int>(runIndex),
      'runCorrect': serializer.toJson<int>(runCorrect),
      'runAnswered': serializer.toJson<int>(runAnswered),
      'runSkipped': serializer.toJson<int>(runSkipped),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  LessonProgressRow copyWith(
          {String? lessonId,
          String? langCode,
          String? levelId,
          String? moduleType,
          int? status,
          double? bestScore,
          int? attempts,
          int? runIndex,
          int? runCorrect,
          int? runAnswered,
          int? runSkipped,
          DateTime? updatedAt,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      LessonProgressRow(
        lessonId: lessonId ?? this.lessonId,
        langCode: langCode ?? this.langCode,
        levelId: levelId ?? this.levelId,
        moduleType: moduleType ?? this.moduleType,
        status: status ?? this.status,
        bestScore: bestScore ?? this.bestScore,
        attempts: attempts ?? this.attempts,
        runIndex: runIndex ?? this.runIndex,
        runCorrect: runCorrect ?? this.runCorrect,
        runAnswered: runAnswered ?? this.runAnswered,
        runSkipped: runSkipped ?? this.runSkipped,
        updatedAt: updatedAt ?? this.updatedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  LessonProgressRow copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      moduleType:
          data.moduleType.present ? data.moduleType.value : this.moduleType,
      status: data.status.present ? data.status.value : this.status,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      runIndex: data.runIndex.present ? data.runIndex.value : this.runIndex,
      runCorrect:
          data.runCorrect.present ? data.runCorrect.value : this.runCorrect,
      runAnswered:
          data.runAnswered.present ? data.runAnswered.value : this.runAnswered,
      runSkipped:
          data.runSkipped.present ? data.runSkipped.value : this.runSkipped,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRow(')
          ..write('lessonId: $lessonId, ')
          ..write('langCode: $langCode, ')
          ..write('levelId: $levelId, ')
          ..write('moduleType: $moduleType, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('attempts: $attempts, ')
          ..write('runIndex: $runIndex, ')
          ..write('runCorrect: $runCorrect, ')
          ..write('runAnswered: $runAnswered, ')
          ..write('runSkipped: $runSkipped, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lessonId,
      langCode,
      levelId,
      moduleType,
      status,
      bestScore,
      attempts,
      runIndex,
      runCorrect,
      runAnswered,
      runSkipped,
      updatedAt,
      completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressRow &&
          other.lessonId == this.lessonId &&
          other.langCode == this.langCode &&
          other.levelId == this.levelId &&
          other.moduleType == this.moduleType &&
          other.status == this.status &&
          other.bestScore == this.bestScore &&
          other.attempts == this.attempts &&
          other.runIndex == this.runIndex &&
          other.runCorrect == this.runCorrect &&
          other.runAnswered == this.runAnswered &&
          other.runSkipped == this.runSkipped &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressRow> {
  final Value<String> lessonId;
  final Value<String> langCode;
  final Value<String> levelId;
  final Value<String> moduleType;
  final Value<int> status;
  final Value<double> bestScore;
  final Value<int> attempts;
  final Value<int> runIndex;
  final Value<int> runCorrect;
  final Value<int> runAnswered;
  final Value<int> runSkipped;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const LessonProgressCompanion({
    this.lessonId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.levelId = const Value.absent(),
    this.moduleType = const Value.absent(),
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.attempts = const Value.absent(),
    this.runIndex = const Value.absent(),
    this.runCorrect = const Value.absent(),
    this.runAnswered = const Value.absent(),
    this.runSkipped = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    required String lessonId,
    required String langCode,
    required String levelId,
    required String moduleType,
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.attempts = const Value.absent(),
    this.runIndex = const Value.absent(),
    this.runCorrect = const Value.absent(),
    this.runAnswered = const Value.absent(),
    this.runSkipped = const Value.absent(),
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : lessonId = Value(lessonId),
        langCode = Value(langCode),
        levelId = Value(levelId),
        moduleType = Value(moduleType),
        updatedAt = Value(updatedAt);
  static Insertable<LessonProgressRow> custom({
    Expression<String>? lessonId,
    Expression<String>? langCode,
    Expression<String>? levelId,
    Expression<String>? moduleType,
    Expression<int>? status,
    Expression<double>? bestScore,
    Expression<int>? attempts,
    Expression<int>? runIndex,
    Expression<int>? runCorrect,
    Expression<int>? runAnswered,
    Expression<int>? runSkipped,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (langCode != null) 'lang_code': langCode,
      if (levelId != null) 'level_id': levelId,
      if (moduleType != null) 'module_type': moduleType,
      if (status != null) 'status': status,
      if (bestScore != null) 'best_score': bestScore,
      if (attempts != null) 'attempts': attempts,
      if (runIndex != null) 'run_index': runIndex,
      if (runCorrect != null) 'run_correct': runCorrect,
      if (runAnswered != null) 'run_answered': runAnswered,
      if (runSkipped != null) 'run_skipped': runSkipped,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressCompanion copyWith(
      {Value<String>? lessonId,
      Value<String>? langCode,
      Value<String>? levelId,
      Value<String>? moduleType,
      Value<int>? status,
      Value<double>? bestScore,
      Value<int>? attempts,
      Value<int>? runIndex,
      Value<int>? runCorrect,
      Value<int>? runAnswered,
      Value<int>? runSkipped,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return LessonProgressCompanion(
      lessonId: lessonId ?? this.lessonId,
      langCode: langCode ?? this.langCode,
      levelId: levelId ?? this.levelId,
      moduleType: moduleType ?? this.moduleType,
      status: status ?? this.status,
      bestScore: bestScore ?? this.bestScore,
      attempts: attempts ?? this.attempts,
      runIndex: runIndex ?? this.runIndex,
      runCorrect: runCorrect ?? this.runCorrect,
      runAnswered: runAnswered ?? this.runAnswered,
      runSkipped: runSkipped ?? this.runSkipped,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (moduleType.present) {
      map['module_type'] = Variable<String>(moduleType.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<double>(bestScore.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (runIndex.present) {
      map['run_index'] = Variable<int>(runIndex.value);
    }
    if (runCorrect.present) {
      map['run_correct'] = Variable<int>(runCorrect.value);
    }
    if (runAnswered.present) {
      map['run_answered'] = Variable<int>(runAnswered.value);
    }
    if (runSkipped.present) {
      map['run_skipped'] = Variable<int>(runSkipped.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('langCode: $langCode, ')
          ..write('levelId: $levelId, ')
          ..write('moduleType: $moduleType, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('attempts: $attempts, ')
          ..write('runIndex: $runIndex, ')
          ..write('runCorrect: $runCorrect, ')
          ..write('runAnswered: $runAnswered, ')
          ..write('runSkipped: $runSkipped, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseAttemptsTable extends ExerciseAttempts
    with TableInfo<$ExerciseAttemptsTable, ExerciseAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionTypeMeta =
      const VerificationMeta('questionType');
  @override
  late final GeneratedColumn<String> questionType = GeneratedColumn<String>(
      'question_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
      'correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("correct" IN (0, 1))'));
  static const VerificationMeta _skippedMeta =
      const VerificationMeta('skipped');
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
      'skipped', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("skipped" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        langCode,
        lessonId,
        questionId,
        questionType,
        correct,
        skipped,
        answer,
        score,
        at
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('question_type')) {
      context.handle(
          _questionTypeMeta,
          questionType.isAcceptableOrUnknown(
              data['question_type']!, _questionTypeMeta));
    } else if (isInserting) {
      context.missing(_questionTypeMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('skipped')) {
      context.handle(_skippedMeta,
          skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseAttempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      questionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_type'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}correct'])!,
      skipped: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}skipped'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score']),
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
    );
  }

  @override
  $ExerciseAttemptsTable createAlias(String alias) {
    return $ExerciseAttemptsTable(attachedDatabase, alias);
  }
}

class ExerciseAttempt extends DataClass implements Insertable<ExerciseAttempt> {
  final int id;
  final String langCode;
  final String lessonId;
  final String questionId;
  final String questionType;
  final bool correct;
  final bool skipped;
  final String answer;
  final int? score;
  final DateTime at;
  const ExerciseAttempt(
      {required this.id,
      required this.langCode,
      required this.lessonId,
      required this.questionId,
      required this.questionType,
      required this.correct,
      required this.skipped,
      required this.answer,
      this.score,
      required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_code'] = Variable<String>(langCode);
    map['lesson_id'] = Variable<String>(lessonId);
    map['question_id'] = Variable<String>(questionId);
    map['question_type'] = Variable<String>(questionType);
    map['correct'] = Variable<bool>(correct);
    map['skipped'] = Variable<bool>(skipped);
    map['answer'] = Variable<String>(answer);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  ExerciseAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseAttemptsCompanion(
      id: Value(id),
      langCode: Value(langCode),
      lessonId: Value(lessonId),
      questionId: Value(questionId),
      questionType: Value(questionType),
      correct: Value(correct),
      skipped: Value(skipped),
      answer: Value(answer),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      at: Value(at),
    );
  }

  factory ExerciseAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseAttempt(
      id: serializer.fromJson<int>(json['id']),
      langCode: serializer.fromJson<String>(json['langCode']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      questionType: serializer.fromJson<String>(json['questionType']),
      correct: serializer.fromJson<bool>(json['correct']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      answer: serializer.fromJson<String>(json['answer']),
      score: serializer.fromJson<int?>(json['score']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langCode': serializer.toJson<String>(langCode),
      'lessonId': serializer.toJson<String>(lessonId),
      'questionId': serializer.toJson<String>(questionId),
      'questionType': serializer.toJson<String>(questionType),
      'correct': serializer.toJson<bool>(correct),
      'skipped': serializer.toJson<bool>(skipped),
      'answer': serializer.toJson<String>(answer),
      'score': serializer.toJson<int?>(score),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  ExerciseAttempt copyWith(
          {int? id,
          String? langCode,
          String? lessonId,
          String? questionId,
          String? questionType,
          bool? correct,
          bool? skipped,
          String? answer,
          Value<int?> score = const Value.absent(),
          DateTime? at}) =>
      ExerciseAttempt(
        id: id ?? this.id,
        langCode: langCode ?? this.langCode,
        lessonId: lessonId ?? this.lessonId,
        questionId: questionId ?? this.questionId,
        questionType: questionType ?? this.questionType,
        correct: correct ?? this.correct,
        skipped: skipped ?? this.skipped,
        answer: answer ?? this.answer,
        score: score.present ? score.value : this.score,
        at: at ?? this.at,
      );
  ExerciseAttempt copyWithCompanion(ExerciseAttemptsCompanion data) {
    return ExerciseAttempt(
      id: data.id.present ? data.id.value : this.id,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      questionType: data.questionType.present
          ? data.questionType.value
          : this.questionType,
      correct: data.correct.present ? data.correct.value : this.correct,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      answer: data.answer.present ? data.answer.value : this.answer,
      score: data.score.present ? data.score.value : this.score,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseAttempt(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionId: $questionId, ')
          ..write('questionType: $questionType, ')
          ..write('correct: $correct, ')
          ..write('skipped: $skipped, ')
          ..write('answer: $answer, ')
          ..write('score: $score, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, langCode, lessonId, questionId,
      questionType, correct, skipped, answer, score, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseAttempt &&
          other.id == this.id &&
          other.langCode == this.langCode &&
          other.lessonId == this.lessonId &&
          other.questionId == this.questionId &&
          other.questionType == this.questionType &&
          other.correct == this.correct &&
          other.skipped == this.skipped &&
          other.answer == this.answer &&
          other.score == this.score &&
          other.at == this.at);
}

class ExerciseAttemptsCompanion extends UpdateCompanion<ExerciseAttempt> {
  final Value<int> id;
  final Value<String> langCode;
  final Value<String> lessonId;
  final Value<String> questionId;
  final Value<String> questionType;
  final Value<bool> correct;
  final Value<bool> skipped;
  final Value<String> answer;
  final Value<int?> score;
  final Value<DateTime> at;
  const ExerciseAttemptsCompanion({
    this.id = const Value.absent(),
    this.langCode = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.questionType = const Value.absent(),
    this.correct = const Value.absent(),
    this.skipped = const Value.absent(),
    this.answer = const Value.absent(),
    this.score = const Value.absent(),
    this.at = const Value.absent(),
  });
  ExerciseAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String langCode,
    required String lessonId,
    required String questionId,
    required String questionType,
    required bool correct,
    this.skipped = const Value.absent(),
    this.answer = const Value.absent(),
    this.score = const Value.absent(),
    required DateTime at,
  })  : langCode = Value(langCode),
        lessonId = Value(lessonId),
        questionId = Value(questionId),
        questionType = Value(questionType),
        correct = Value(correct),
        at = Value(at);
  static Insertable<ExerciseAttempt> custom({
    Expression<int>? id,
    Expression<String>? langCode,
    Expression<String>? lessonId,
    Expression<String>? questionId,
    Expression<String>? questionType,
    Expression<bool>? correct,
    Expression<bool>? skipped,
    Expression<String>? answer,
    Expression<int>? score,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langCode != null) 'lang_code': langCode,
      if (lessonId != null) 'lesson_id': lessonId,
      if (questionId != null) 'question_id': questionId,
      if (questionType != null) 'question_type': questionType,
      if (correct != null) 'correct': correct,
      if (skipped != null) 'skipped': skipped,
      if (answer != null) 'answer': answer,
      if (score != null) 'score': score,
      if (at != null) 'at': at,
    });
  }

  ExerciseAttemptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? langCode,
      Value<String>? lessonId,
      Value<String>? questionId,
      Value<String>? questionType,
      Value<bool>? correct,
      Value<bool>? skipped,
      Value<String>? answer,
      Value<int?>? score,
      Value<DateTime>? at}) {
    return ExerciseAttemptsCompanion(
      id: id ?? this.id,
      langCode: langCode ?? this.langCode,
      lessonId: lessonId ?? this.lessonId,
      questionId: questionId ?? this.questionId,
      questionType: questionType ?? this.questionType,
      correct: correct ?? this.correct,
      skipped: skipped ?? this.skipped,
      answer: answer ?? this.answer,
      score: score ?? this.score,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (questionType.present) {
      map['question_type'] = Variable<String>(questionType.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionId: $questionId, ')
          ..write('questionType: $questionType, ')
          ..write('correct: $correct, ')
          ..write('skipped: $skipped, ')
          ..write('answer: $answer, ')
          ..write('score: $score, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $ExamAttemptsTable extends ExamAttempts
    with TableInfo<$ExamAttemptsTable, ExamAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
      'level_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('exam'));
  static const VerificationMeta _percentMeta =
      const VerificationMeta('percent');
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
      'percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
      'passed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("passed" IN (0, 1))'));
  static const VerificationMeta _thresholdMeta =
      const VerificationMeta('threshold');
  @override
  late final GeneratedColumn<int> threshold = GeneratedColumn<int>(
      'threshold', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _detailJsonMeta =
      const VerificationMeta('detailJson');
  @override
  late final GeneratedColumn<String> detailJson = GeneratedColumn<String>(
      'detail_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        langCode,
        levelId,
        kind,
        percent,
        passed,
        threshold,
        detailJson,
        startedAt,
        finishedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<ExamAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('percent')) {
      context.handle(_percentMeta,
          percent.isAcceptableOrUnknown(data['percent']!, _percentMeta));
    } else if (isInserting) {
      context.missing(_percentMeta);
    }
    if (data.containsKey('passed')) {
      context.handle(_passedMeta,
          passed.isAcceptableOrUnknown(data['passed']!, _passedMeta));
    } else if (isInserting) {
      context.missing(_passedMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(_thresholdMeta,
          threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta));
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('detail_json')) {
      context.handle(
          _detailJsonMeta,
          detailJson.isAcceptableOrUnknown(
              data['detail_json']!, _detailJsonMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamAttempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      percent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent'])!,
      passed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}passed'])!,
      threshold: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}threshold'])!,
      detailJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail_json'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at'])!,
    );
  }

  @override
  $ExamAttemptsTable createAlias(String alias) {
    return $ExamAttemptsTable(attachedDatabase, alias);
  }
}

class ExamAttempt extends DataClass implements Insertable<ExamAttempt> {
  final int id;
  final String langCode;
  final String levelId;
  final String kind;
  final double percent;
  final bool passed;
  final int threshold;
  final String detailJson;
  final DateTime startedAt;
  final DateTime finishedAt;
  const ExamAttempt(
      {required this.id,
      required this.langCode,
      required this.levelId,
      required this.kind,
      required this.percent,
      required this.passed,
      required this.threshold,
      required this.detailJson,
      required this.startedAt,
      required this.finishedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_code'] = Variable<String>(langCode);
    map['level_id'] = Variable<String>(levelId);
    map['kind'] = Variable<String>(kind);
    map['percent'] = Variable<double>(percent);
    map['passed'] = Variable<bool>(passed);
    map['threshold'] = Variable<int>(threshold);
    map['detail_json'] = Variable<String>(detailJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    return map;
  }

  ExamAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ExamAttemptsCompanion(
      id: Value(id),
      langCode: Value(langCode),
      levelId: Value(levelId),
      kind: Value(kind),
      percent: Value(percent),
      passed: Value(passed),
      threshold: Value(threshold),
      detailJson: Value(detailJson),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
    );
  }

  factory ExamAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamAttempt(
      id: serializer.fromJson<int>(json['id']),
      langCode: serializer.fromJson<String>(json['langCode']),
      levelId: serializer.fromJson<String>(json['levelId']),
      kind: serializer.fromJson<String>(json['kind']),
      percent: serializer.fromJson<double>(json['percent']),
      passed: serializer.fromJson<bool>(json['passed']),
      threshold: serializer.fromJson<int>(json['threshold']),
      detailJson: serializer.fromJson<String>(json['detailJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langCode': serializer.toJson<String>(langCode),
      'levelId': serializer.toJson<String>(levelId),
      'kind': serializer.toJson<String>(kind),
      'percent': serializer.toJson<double>(percent),
      'passed': serializer.toJson<bool>(passed),
      'threshold': serializer.toJson<int>(threshold),
      'detailJson': serializer.toJson<String>(detailJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
    };
  }

  ExamAttempt copyWith(
          {int? id,
          String? langCode,
          String? levelId,
          String? kind,
          double? percent,
          bool? passed,
          int? threshold,
          String? detailJson,
          DateTime? startedAt,
          DateTime? finishedAt}) =>
      ExamAttempt(
        id: id ?? this.id,
        langCode: langCode ?? this.langCode,
        levelId: levelId ?? this.levelId,
        kind: kind ?? this.kind,
        percent: percent ?? this.percent,
        passed: passed ?? this.passed,
        threshold: threshold ?? this.threshold,
        detailJson: detailJson ?? this.detailJson,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt ?? this.finishedAt,
      );
  ExamAttempt copyWithCompanion(ExamAttemptsCompanion data) {
    return ExamAttempt(
      id: data.id.present ? data.id.value : this.id,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      kind: data.kind.present ? data.kind.value : this.kind,
      percent: data.percent.present ? data.percent.value : this.percent,
      passed: data.passed.present ? data.passed.value : this.passed,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      detailJson:
          data.detailJson.present ? data.detailJson.value : this.detailJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttempt(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('levelId: $levelId, ')
          ..write('kind: $kind, ')
          ..write('percent: $percent, ')
          ..write('passed: $passed, ')
          ..write('threshold: $threshold, ')
          ..write('detailJson: $detailJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, langCode, levelId, kind, percent, passed,
      threshold, detailJson, startedAt, finishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamAttempt &&
          other.id == this.id &&
          other.langCode == this.langCode &&
          other.levelId == this.levelId &&
          other.kind == this.kind &&
          other.percent == this.percent &&
          other.passed == this.passed &&
          other.threshold == this.threshold &&
          other.detailJson == this.detailJson &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class ExamAttemptsCompanion extends UpdateCompanion<ExamAttempt> {
  final Value<int> id;
  final Value<String> langCode;
  final Value<String> levelId;
  final Value<String> kind;
  final Value<double> percent;
  final Value<bool> passed;
  final Value<int> threshold;
  final Value<String> detailJson;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  const ExamAttemptsCompanion({
    this.id = const Value.absent(),
    this.langCode = const Value.absent(),
    this.levelId = const Value.absent(),
    this.kind = const Value.absent(),
    this.percent = const Value.absent(),
    this.passed = const Value.absent(),
    this.threshold = const Value.absent(),
    this.detailJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
  });
  ExamAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String langCode,
    required String levelId,
    this.kind = const Value.absent(),
    required double percent,
    required bool passed,
    required int threshold,
    this.detailJson = const Value.absent(),
    required DateTime startedAt,
    required DateTime finishedAt,
  })  : langCode = Value(langCode),
        levelId = Value(levelId),
        percent = Value(percent),
        passed = Value(passed),
        threshold = Value(threshold),
        startedAt = Value(startedAt),
        finishedAt = Value(finishedAt);
  static Insertable<ExamAttempt> custom({
    Expression<int>? id,
    Expression<String>? langCode,
    Expression<String>? levelId,
    Expression<String>? kind,
    Expression<double>? percent,
    Expression<bool>? passed,
    Expression<int>? threshold,
    Expression<String>? detailJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langCode != null) 'lang_code': langCode,
      if (levelId != null) 'level_id': levelId,
      if (kind != null) 'kind': kind,
      if (percent != null) 'percent': percent,
      if (passed != null) 'passed': passed,
      if (threshold != null) 'threshold': threshold,
      if (detailJson != null) 'detail_json': detailJson,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
    });
  }

  ExamAttemptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? langCode,
      Value<String>? levelId,
      Value<String>? kind,
      Value<double>? percent,
      Value<bool>? passed,
      Value<int>? threshold,
      Value<String>? detailJson,
      Value<DateTime>? startedAt,
      Value<DateTime>? finishedAt}) {
    return ExamAttemptsCompanion(
      id: id ?? this.id,
      langCode: langCode ?? this.langCode,
      levelId: levelId ?? this.levelId,
      kind: kind ?? this.kind,
      percent: percent ?? this.percent,
      passed: passed ?? this.passed,
      threshold: threshold ?? this.threshold,
      detailJson: detailJson ?? this.detailJson,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<int>(threshold.value);
    }
    if (detailJson.present) {
      map['detail_json'] = Variable<String>(detailJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('levelId: $levelId, ')
          ..write('kind: $kind, ')
          ..write('percent: $percent, ')
          ..write('passed: $passed, ')
          ..write('threshold: $threshold, ')
          ..write('detailJson: $detailJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }
}

class $LanguageProgressTable extends LanguageProgress
    with TableInfo<$LanguageProgressTable, LanguageProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguageProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startLevelIdMeta =
      const VerificationMeta('startLevelId');
  @override
  late final GeneratedColumn<String> startLevelId = GeneratedColumn<String>(
      'start_level_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _placementLevelIdMeta =
      const VerificationMeta('placementLevelId');
  @override
  late final GeneratedColumn<String> placementLevelId = GeneratedColumn<String>(
      'placement_level_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastLessonIdMeta =
      const VerificationMeta('lastLessonId');
  @override
  late final GeneratedColumn<String> lastLessonId = GeneratedColumn<String>(
      'last_lesson_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [langCode, startLevelId, placementLevelId, lastLessonId, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'language_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<LanguageProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('start_level_id')) {
      context.handle(
          _startLevelIdMeta,
          startLevelId.isAcceptableOrUnknown(
              data['start_level_id']!, _startLevelIdMeta));
    }
    if (data.containsKey('placement_level_id')) {
      context.handle(
          _placementLevelIdMeta,
          placementLevelId.isAcceptableOrUnknown(
              data['placement_level_id']!, _placementLevelIdMeta));
    }
    if (data.containsKey('last_lesson_id')) {
      context.handle(
          _lastLessonIdMeta,
          lastLessonId.isAcceptableOrUnknown(
              data['last_lesson_id']!, _lastLessonIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {langCode};
  @override
  LanguageProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LanguageProgressRow(
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      startLevelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_level_id']),
      placementLevelId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}placement_level_id']),
      lastLessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_lesson_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LanguageProgressTable createAlias(String alias) {
    return $LanguageProgressTable(attachedDatabase, alias);
  }
}

class LanguageProgressRow extends DataClass
    implements Insertable<LanguageProgressRow> {
  final String langCode;
  final String? startLevelId;
  final String? placementLevelId;
  final String? lastLessonId;
  final DateTime updatedAt;
  const LanguageProgressRow(
      {required this.langCode,
      this.startLevelId,
      this.placementLevelId,
      this.lastLessonId,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lang_code'] = Variable<String>(langCode);
    if (!nullToAbsent || startLevelId != null) {
      map['start_level_id'] = Variable<String>(startLevelId);
    }
    if (!nullToAbsent || placementLevelId != null) {
      map['placement_level_id'] = Variable<String>(placementLevelId);
    }
    if (!nullToAbsent || lastLessonId != null) {
      map['last_lesson_id'] = Variable<String>(lastLessonId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LanguageProgressCompanion toCompanion(bool nullToAbsent) {
    return LanguageProgressCompanion(
      langCode: Value(langCode),
      startLevelId: startLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(startLevelId),
      placementLevelId: placementLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(placementLevelId),
      lastLessonId: lastLessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLessonId),
      updatedAt: Value(updatedAt),
    );
  }

  factory LanguageProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LanguageProgressRow(
      langCode: serializer.fromJson<String>(json['langCode']),
      startLevelId: serializer.fromJson<String?>(json['startLevelId']),
      placementLevelId: serializer.fromJson<String?>(json['placementLevelId']),
      lastLessonId: serializer.fromJson<String?>(json['lastLessonId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'langCode': serializer.toJson<String>(langCode),
      'startLevelId': serializer.toJson<String?>(startLevelId),
      'placementLevelId': serializer.toJson<String?>(placementLevelId),
      'lastLessonId': serializer.toJson<String?>(lastLessonId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LanguageProgressRow copyWith(
          {String? langCode,
          Value<String?> startLevelId = const Value.absent(),
          Value<String?> placementLevelId = const Value.absent(),
          Value<String?> lastLessonId = const Value.absent(),
          DateTime? updatedAt}) =>
      LanguageProgressRow(
        langCode: langCode ?? this.langCode,
        startLevelId:
            startLevelId.present ? startLevelId.value : this.startLevelId,
        placementLevelId: placementLevelId.present
            ? placementLevelId.value
            : this.placementLevelId,
        lastLessonId:
            lastLessonId.present ? lastLessonId.value : this.lastLessonId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LanguageProgressRow copyWithCompanion(LanguageProgressCompanion data) {
    return LanguageProgressRow(
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      startLevelId: data.startLevelId.present
          ? data.startLevelId.value
          : this.startLevelId,
      placementLevelId: data.placementLevelId.present
          ? data.placementLevelId.value
          : this.placementLevelId,
      lastLessonId: data.lastLessonId.present
          ? data.lastLessonId.value
          : this.lastLessonId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LanguageProgressRow(')
          ..write('langCode: $langCode, ')
          ..write('startLevelId: $startLevelId, ')
          ..write('placementLevelId: $placementLevelId, ')
          ..write('lastLessonId: $lastLessonId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      langCode, startLevelId, placementLevelId, lastLessonId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LanguageProgressRow &&
          other.langCode == this.langCode &&
          other.startLevelId == this.startLevelId &&
          other.placementLevelId == this.placementLevelId &&
          other.lastLessonId == this.lastLessonId &&
          other.updatedAt == this.updatedAt);
}

class LanguageProgressCompanion extends UpdateCompanion<LanguageProgressRow> {
  final Value<String> langCode;
  final Value<String?> startLevelId;
  final Value<String?> placementLevelId;
  final Value<String?> lastLessonId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LanguageProgressCompanion({
    this.langCode = const Value.absent(),
    this.startLevelId = const Value.absent(),
    this.placementLevelId = const Value.absent(),
    this.lastLessonId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LanguageProgressCompanion.insert({
    required String langCode,
    this.startLevelId = const Value.absent(),
    this.placementLevelId = const Value.absent(),
    this.lastLessonId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : langCode = Value(langCode),
        updatedAt = Value(updatedAt);
  static Insertable<LanguageProgressRow> custom({
    Expression<String>? langCode,
    Expression<String>? startLevelId,
    Expression<String>? placementLevelId,
    Expression<String>? lastLessonId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (langCode != null) 'lang_code': langCode,
      if (startLevelId != null) 'start_level_id': startLevelId,
      if (placementLevelId != null) 'placement_level_id': placementLevelId,
      if (lastLessonId != null) 'last_lesson_id': lastLessonId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LanguageProgressCompanion copyWith(
      {Value<String>? langCode,
      Value<String?>? startLevelId,
      Value<String?>? placementLevelId,
      Value<String?>? lastLessonId,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LanguageProgressCompanion(
      langCode: langCode ?? this.langCode,
      startLevelId: startLevelId ?? this.startLevelId,
      placementLevelId: placementLevelId ?? this.placementLevelId,
      lastLessonId: lastLessonId ?? this.lastLessonId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (startLevelId.present) {
      map['start_level_id'] = Variable<String>(startLevelId.value);
    }
    if (placementLevelId.present) {
      map['placement_level_id'] = Variable<String>(placementLevelId.value);
    }
    if (lastLessonId.present) {
      map['last_lesson_id'] = Variable<String>(lastLessonId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguageProgressCompanion(')
          ..write('langCode: $langCode, ')
          ..write('startLevelId: $startLevelId, ')
          ..write('placementLevelId: $placementLevelId, ')
          ..write('lastLessonId: $lastLessonId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyTimeTable extends StudyTime
    with TableInfo<$StudyTimeTable, StudyTimeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyTimeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
      'day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _msMeta = const VerificationMeta('ms');
  @override
  late final GeneratedColumn<int> ms = GeneratedColumn<int>(
      'ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [langCode, day, ms];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_time';
  @override
  VerificationContext validateIntegrity(Insertable<StudyTimeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('ms')) {
      context.handle(_msMeta, ms.isAcceptableOrUnknown(data['ms']!, _msMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {langCode, day};
  @override
  StudyTimeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyTimeRow(
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}day'])!,
      ms: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ms'])!,
    );
  }

  @override
  $StudyTimeTable createAlias(String alias) {
    return $StudyTimeTable(attachedDatabase, alias);
  }
}

class StudyTimeRow extends DataClass implements Insertable<StudyTimeRow> {
  final String langCode;
  final DateTime day;
  final int ms;
  const StudyTimeRow(
      {required this.langCode, required this.day, required this.ms});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lang_code'] = Variable<String>(langCode);
    map['day'] = Variable<DateTime>(day);
    map['ms'] = Variable<int>(ms);
    return map;
  }

  StudyTimeCompanion toCompanion(bool nullToAbsent) {
    return StudyTimeCompanion(
      langCode: Value(langCode),
      day: Value(day),
      ms: Value(ms),
    );
  }

  factory StudyTimeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyTimeRow(
      langCode: serializer.fromJson<String>(json['langCode']),
      day: serializer.fromJson<DateTime>(json['day']),
      ms: serializer.fromJson<int>(json['ms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'langCode': serializer.toJson<String>(langCode),
      'day': serializer.toJson<DateTime>(day),
      'ms': serializer.toJson<int>(ms),
    };
  }

  StudyTimeRow copyWith({String? langCode, DateTime? day, int? ms}) =>
      StudyTimeRow(
        langCode: langCode ?? this.langCode,
        day: day ?? this.day,
        ms: ms ?? this.ms,
      );
  StudyTimeRow copyWithCompanion(StudyTimeCompanion data) {
    return StudyTimeRow(
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      day: data.day.present ? data.day.value : this.day,
      ms: data.ms.present ? data.ms.value : this.ms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyTimeRow(')
          ..write('langCode: $langCode, ')
          ..write('day: $day, ')
          ..write('ms: $ms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(langCode, day, ms);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyTimeRow &&
          other.langCode == this.langCode &&
          other.day == this.day &&
          other.ms == this.ms);
}

class StudyTimeCompanion extends UpdateCompanion<StudyTimeRow> {
  final Value<String> langCode;
  final Value<DateTime> day;
  final Value<int> ms;
  final Value<int> rowid;
  const StudyTimeCompanion({
    this.langCode = const Value.absent(),
    this.day = const Value.absent(),
    this.ms = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyTimeCompanion.insert({
    required String langCode,
    required DateTime day,
    this.ms = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : langCode = Value(langCode),
        day = Value(day);
  static Insertable<StudyTimeRow> custom({
    Expression<String>? langCode,
    Expression<DateTime>? day,
    Expression<int>? ms,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (langCode != null) 'lang_code': langCode,
      if (day != null) 'day': day,
      if (ms != null) 'ms': ms,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyTimeCompanion copyWith(
      {Value<String>? langCode,
      Value<DateTime>? day,
      Value<int>? ms,
      Value<int>? rowid}) {
    return StudyTimeCompanion(
      langCode: langCode ?? this.langCode,
      day: day ?? this.day,
      ms: ms ?? this.ms,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (ms.present) {
      map['ms'] = Variable<int>(ms.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyTimeCompanion(')
          ..write('langCode: $langCode, ')
          ..write('day: $day, ')
          ..write('ms: $ms, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTable extends XpEvents with TableInfo<$XpEventsTable, XpEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, langCode, amount, reason, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(Insertable<XpEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
    );
  }

  @override
  $XpEventsTable createAlias(String alias) {
    return $XpEventsTable(attachedDatabase, alias);
  }
}

class XpEvent extends DataClass implements Insertable<XpEvent> {
  final int id;
  final String langCode;
  final int amount;
  final String reason;
  final DateTime at;
  const XpEvent(
      {required this.id,
      required this.langCode,
      required this.amount,
      required this.reason,
      required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_code'] = Variable<String>(langCode);
    map['amount'] = Variable<int>(amount);
    map['reason'] = Variable<String>(reason);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  XpEventsCompanion toCompanion(bool nullToAbsent) {
    return XpEventsCompanion(
      id: Value(id),
      langCode: Value(langCode),
      amount: Value(amount),
      reason: Value(reason),
      at: Value(at),
    );
  }

  factory XpEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEvent(
      id: serializer.fromJson<int>(json['id']),
      langCode: serializer.fromJson<String>(json['langCode']),
      amount: serializer.fromJson<int>(json['amount']),
      reason: serializer.fromJson<String>(json['reason']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langCode': serializer.toJson<String>(langCode),
      'amount': serializer.toJson<int>(amount),
      'reason': serializer.toJson<String>(reason),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  XpEvent copyWith(
          {int? id,
          String? langCode,
          int? amount,
          String? reason,
          DateTime? at}) =>
      XpEvent(
        id: id ?? this.id,
        langCode: langCode ?? this.langCode,
        amount: amount ?? this.amount,
        reason: reason ?? this.reason,
        at: at ?? this.at,
      );
  XpEvent copyWithCompanion(XpEventsCompanion data) {
    return XpEvent(
      id: data.id.present ? data.id.value : this.id,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEvent(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, langCode, amount, reason, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEvent &&
          other.id == this.id &&
          other.langCode == this.langCode &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.at == this.at);
}

class XpEventsCompanion extends UpdateCompanion<XpEvent> {
  final Value<int> id;
  final Value<String> langCode;
  final Value<int> amount;
  final Value<String> reason;
  final Value<DateTime> at;
  const XpEventsCompanion({
    this.id = const Value.absent(),
    this.langCode = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.at = const Value.absent(),
  });
  XpEventsCompanion.insert({
    this.id = const Value.absent(),
    required String langCode,
    required int amount,
    required String reason,
    required DateTime at,
  })  : langCode = Value(langCode),
        amount = Value(amount),
        reason = Value(reason),
        at = Value(at);
  static Insertable<XpEvent> custom({
    Expression<int>? id,
    Expression<String>? langCode,
    Expression<int>? amount,
    Expression<String>? reason,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langCode != null) 'lang_code': langCode,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (at != null) 'at': at,
    });
  }

  XpEventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? langCode,
      Value<int>? amount,
      Value<String>? reason,
      Value<DateTime>? at}) {
    return XpEventsCompanion(
      id: id ?? this.id,
      langCode: langCode ?? this.langCode,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsCompanion(')
          ..write('id: $id, ')
          ..write('langCode: $langCode, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $MissionClaimsTable extends MissionClaims
    with TableInfo<$MissionClaimsTable, MissionClaim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodKeyMeta =
      const VerificationMeta('periodKey');
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
      'period_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _missionIdMeta =
      const VerificationMeta('missionId');
  @override
  late final GeneratedColumn<String> missionId = GeneratedColumn<String>(
      'mission_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _claimedAtMeta =
      const VerificationMeta('claimedAt');
  @override
  late final GeneratedColumn<DateTime> claimedAt = GeneratedColumn<DateTime>(
      'claimed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [periodKey, missionId, xp, claimedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_claims';
  @override
  VerificationContext validateIntegrity(Insertable<MissionClaim> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period_key')) {
      context.handle(_periodKeyMeta,
          periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta));
    } else if (isInserting) {
      context.missing(_periodKeyMeta);
    }
    if (data.containsKey('mission_id')) {
      context.handle(_missionIdMeta,
          missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta));
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('claimed_at')) {
      context.handle(_claimedAtMeta,
          claimedAt.isAcceptableOrUnknown(data['claimed_at']!, _claimedAtMeta));
    } else if (isInserting) {
      context.missing(_claimedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {periodKey, missionId};
  @override
  MissionClaim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionClaim(
      periodKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period_key'])!,
      missionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mission_id'])!,
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      claimedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}claimed_at'])!,
    );
  }

  @override
  $MissionClaimsTable createAlias(String alias) {
    return $MissionClaimsTable(attachedDatabase, alias);
  }
}

class MissionClaim extends DataClass implements Insertable<MissionClaim> {
  final String periodKey;
  final String missionId;
  final int xp;
  final DateTime claimedAt;
  const MissionClaim(
      {required this.periodKey,
      required this.missionId,
      required this.xp,
      required this.claimedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period_key'] = Variable<String>(periodKey);
    map['mission_id'] = Variable<String>(missionId);
    map['xp'] = Variable<int>(xp);
    map['claimed_at'] = Variable<DateTime>(claimedAt);
    return map;
  }

  MissionClaimsCompanion toCompanion(bool nullToAbsent) {
    return MissionClaimsCompanion(
      periodKey: Value(periodKey),
      missionId: Value(missionId),
      xp: Value(xp),
      claimedAt: Value(claimedAt),
    );
  }

  factory MissionClaim.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionClaim(
      periodKey: serializer.fromJson<String>(json['periodKey']),
      missionId: serializer.fromJson<String>(json['missionId']),
      xp: serializer.fromJson<int>(json['xp']),
      claimedAt: serializer.fromJson<DateTime>(json['claimedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'periodKey': serializer.toJson<String>(periodKey),
      'missionId': serializer.toJson<String>(missionId),
      'xp': serializer.toJson<int>(xp),
      'claimedAt': serializer.toJson<DateTime>(claimedAt),
    };
  }

  MissionClaim copyWith(
          {String? periodKey,
          String? missionId,
          int? xp,
          DateTime? claimedAt}) =>
      MissionClaim(
        periodKey: periodKey ?? this.periodKey,
        missionId: missionId ?? this.missionId,
        xp: xp ?? this.xp,
        claimedAt: claimedAt ?? this.claimedAt,
      );
  MissionClaim copyWithCompanion(MissionClaimsCompanion data) {
    return MissionClaim(
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      xp: data.xp.present ? data.xp.value : this.xp,
      claimedAt: data.claimedAt.present ? data.claimedAt.value : this.claimedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionClaim(')
          ..write('periodKey: $periodKey, ')
          ..write('missionId: $missionId, ')
          ..write('xp: $xp, ')
          ..write('claimedAt: $claimedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(periodKey, missionId, xp, claimedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionClaim &&
          other.periodKey == this.periodKey &&
          other.missionId == this.missionId &&
          other.xp == this.xp &&
          other.claimedAt == this.claimedAt);
}

class MissionClaimsCompanion extends UpdateCompanion<MissionClaim> {
  final Value<String> periodKey;
  final Value<String> missionId;
  final Value<int> xp;
  final Value<DateTime> claimedAt;
  final Value<int> rowid;
  const MissionClaimsCompanion({
    this.periodKey = const Value.absent(),
    this.missionId = const Value.absent(),
    this.xp = const Value.absent(),
    this.claimedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionClaimsCompanion.insert({
    required String periodKey,
    required String missionId,
    required int xp,
    required DateTime claimedAt,
    this.rowid = const Value.absent(),
  })  : periodKey = Value(periodKey),
        missionId = Value(missionId),
        xp = Value(xp),
        claimedAt = Value(claimedAt);
  static Insertable<MissionClaim> custom({
    Expression<String>? periodKey,
    Expression<String>? missionId,
    Expression<int>? xp,
    Expression<DateTime>? claimedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (periodKey != null) 'period_key': periodKey,
      if (missionId != null) 'mission_id': missionId,
      if (xp != null) 'xp': xp,
      if (claimedAt != null) 'claimed_at': claimedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionClaimsCompanion copyWith(
      {Value<String>? periodKey,
      Value<String>? missionId,
      Value<int>? xp,
      Value<DateTime>? claimedAt,
      Value<int>? rowid}) {
    return MissionClaimsCompanion(
      periodKey: periodKey ?? this.periodKey,
      missionId: missionId ?? this.missionId,
      xp: xp ?? this.xp,
      claimedAt: claimedAt ?? this.claimedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<String>(missionId.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (claimedAt.present) {
      map['claimed_at'] = Variable<DateTime>(claimedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionClaimsCompanion(')
          ..write('periodKey: $periodKey, ')
          ..write('missionId: $missionId, ')
          ..write('xp: $xp, ')
          ..write('claimedAt: $claimedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgeUnlocksTable extends BadgeUnlocks
    with TableInfo<$BadgeUnlocksTable, BadgeUnlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgeUnlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _badgeIdMeta =
      const VerificationMeta('badgeId');
  @override
  late final GeneratedColumn<String> badgeId = GeneratedColumn<String>(
      'badge_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [badgeId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badge_unlocks';
  @override
  VerificationContext validateIntegrity(Insertable<BadgeUnlock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('badge_id')) {
      context.handle(_badgeIdMeta,
          badgeId.isAcceptableOrUnknown(data['badge_id']!, _badgeIdMeta));
    } else if (isInserting) {
      context.missing(_badgeIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {badgeId};
  @override
  BadgeUnlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeUnlock(
      badgeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}badge_id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $BadgeUnlocksTable createAlias(String alias) {
    return $BadgeUnlocksTable(attachedDatabase, alias);
  }
}

class BadgeUnlock extends DataClass implements Insertable<BadgeUnlock> {
  final String badgeId;
  final DateTime unlockedAt;
  const BadgeUnlock({required this.badgeId, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['badge_id'] = Variable<String>(badgeId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  BadgeUnlocksCompanion toCompanion(bool nullToAbsent) {
    return BadgeUnlocksCompanion(
      badgeId: Value(badgeId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory BadgeUnlock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeUnlock(
      badgeId: serializer.fromJson<String>(json['badgeId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'badgeId': serializer.toJson<String>(badgeId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  BadgeUnlock copyWith({String? badgeId, DateTime? unlockedAt}) => BadgeUnlock(
        badgeId: badgeId ?? this.badgeId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  BadgeUnlock copyWithCompanion(BadgeUnlocksCompanion data) {
    return BadgeUnlock(
      badgeId: data.badgeId.present ? data.badgeId.value : this.badgeId,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeUnlock(')
          ..write('badgeId: $badgeId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(badgeId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeUnlock &&
          other.badgeId == this.badgeId &&
          other.unlockedAt == this.unlockedAt);
}

class BadgeUnlocksCompanion extends UpdateCompanion<BadgeUnlock> {
  final Value<String> badgeId;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const BadgeUnlocksCompanion({
    this.badgeId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgeUnlocksCompanion.insert({
    required String badgeId,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : badgeId = Value(badgeId),
        unlockedAt = Value(unlockedAt);
  static Insertable<BadgeUnlock> custom({
    Expression<String>? badgeId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (badgeId != null) 'badge_id': badgeId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgeUnlocksCompanion copyWith(
      {Value<String>? badgeId,
      Value<DateTime>? unlockedAt,
      Value<int>? rowid}) {
    return BadgeUnlocksCompanion(
      badgeId: badgeId ?? this.badgeId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (badgeId.present) {
      map['badge_id'] = Variable<String>(badgeId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgeUnlocksCompanion(')
          ..write('badgeId: $badgeId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameStateTable extends GameState
    with TableInfo<$GameStateTable, GameStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _heartsMeta = const VerificationMeta('hearts');
  @override
  late final GeneratedColumn<int> hearts = GeneratedColumn<int>(
      'hearts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _heartsUpdatedAtMeta =
      const VerificationMeta('heartsUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> heartsUpdatedAt =
      GeneratedColumn<DateTime>('hearts_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, hearts, heartsUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_state';
  @override
  VerificationContext validateIntegrity(Insertable<GameStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hearts')) {
      context.handle(_heartsMeta,
          hearts.isAcceptableOrUnknown(data['hearts']!, _heartsMeta));
    }
    if (data.containsKey('hearts_updated_at')) {
      context.handle(
          _heartsUpdatedAtMeta,
          heartsUpdatedAt.isAcceptableOrUnknown(
              data['hearts_updated_at']!, _heartsUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameStateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hearts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hearts'])!,
      heartsUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}hearts_updated_at']),
    );
  }

  @override
  $GameStateTable createAlias(String alias) {
    return $GameStateTable(attachedDatabase, alias);
  }
}

class GameStateRow extends DataClass implements Insertable<GameStateRow> {
  final int id;
  final int hearts;
  final DateTime? heartsUpdatedAt;
  const GameStateRow(
      {required this.id, required this.hearts, this.heartsUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hearts'] = Variable<int>(hearts);
    if (!nullToAbsent || heartsUpdatedAt != null) {
      map['hearts_updated_at'] = Variable<DateTime>(heartsUpdatedAt);
    }
    return map;
  }

  GameStateCompanion toCompanion(bool nullToAbsent) {
    return GameStateCompanion(
      id: Value(id),
      hearts: Value(hearts),
      heartsUpdatedAt: heartsUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(heartsUpdatedAt),
    );
  }

  factory GameStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameStateRow(
      id: serializer.fromJson<int>(json['id']),
      hearts: serializer.fromJson<int>(json['hearts']),
      heartsUpdatedAt: serializer.fromJson<DateTime?>(json['heartsUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hearts': serializer.toJson<int>(hearts),
      'heartsUpdatedAt': serializer.toJson<DateTime?>(heartsUpdatedAt),
    };
  }

  GameStateRow copyWith(
          {int? id,
          int? hearts,
          Value<DateTime?> heartsUpdatedAt = const Value.absent()}) =>
      GameStateRow(
        id: id ?? this.id,
        hearts: hearts ?? this.hearts,
        heartsUpdatedAt: heartsUpdatedAt.present
            ? heartsUpdatedAt.value
            : this.heartsUpdatedAt,
      );
  GameStateRow copyWithCompanion(GameStateCompanion data) {
    return GameStateRow(
      id: data.id.present ? data.id.value : this.id,
      hearts: data.hearts.present ? data.hearts.value : this.hearts,
      heartsUpdatedAt: data.heartsUpdatedAt.present
          ? data.heartsUpdatedAt.value
          : this.heartsUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameStateRow(')
          ..write('id: $id, ')
          ..write('hearts: $hearts, ')
          ..write('heartsUpdatedAt: $heartsUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hearts, heartsUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameStateRow &&
          other.id == this.id &&
          other.hearts == this.hearts &&
          other.heartsUpdatedAt == this.heartsUpdatedAt);
}

class GameStateCompanion extends UpdateCompanion<GameStateRow> {
  final Value<int> id;
  final Value<int> hearts;
  final Value<DateTime?> heartsUpdatedAt;
  const GameStateCompanion({
    this.id = const Value.absent(),
    this.hearts = const Value.absent(),
    this.heartsUpdatedAt = const Value.absent(),
  });
  GameStateCompanion.insert({
    this.id = const Value.absent(),
    this.hearts = const Value.absent(),
    this.heartsUpdatedAt = const Value.absent(),
  });
  static Insertable<GameStateRow> custom({
    Expression<int>? id,
    Expression<int>? hearts,
    Expression<DateTime>? heartsUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hearts != null) 'hearts': hearts,
      if (heartsUpdatedAt != null) 'hearts_updated_at': heartsUpdatedAt,
    });
  }

  GameStateCompanion copyWith(
      {Value<int>? id, Value<int>? hearts, Value<DateTime?>? heartsUpdatedAt}) {
    return GameStateCompanion(
      id: id ?? this.id,
      hearts: hearts ?? this.hearts,
      heartsUpdatedAt: heartsUpdatedAt ?? this.heartsUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hearts.present) {
      map['hearts'] = Variable<int>(hearts.value);
    }
    if (heartsUpdatedAt.present) {
      map['hearts_updated_at'] = Variable<DateTime>(heartsUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameStateCompanion(')
          ..write('id: $id, ')
          ..write('hearts: $hearts, ')
          ..write('heartsUpdatedAt: $heartsUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $AccountProfileTable extends AccountProfile
    with TableInfo<$AccountProfileTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountCreatedAtMeta =
      const VerificationMeta('accountCreatedAt');
  @override
  late final GeneratedColumn<DateTime> accountCreatedAt =
      GeneratedColumn<DateTime>('account_created_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _linkedAtMeta =
      const VerificationMeta('linkedAt');
  @override
  late final GeneratedColumn<DateTime> linkedAt = GeneratedColumn<DateTime>(
      'linked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uid,
        provider,
        displayName,
        email,
        photoUrl,
        accountCreatedAt,
        linkedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_profile';
  @override
  VerificationContext validateIntegrity(Insertable<AccountRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('account_created_at')) {
      context.handle(
          _accountCreatedAtMeta,
          accountCreatedAt.isAcceptableOrUnknown(
              data['account_created_at']!, _accountCreatedAtMeta));
    }
    if (data.containsKey('linked_at')) {
      context.handle(_linkedAtMeta,
          linkedAt.isAcceptableOrUnknown(data['linked_at']!, _linkedAtMeta));
    } else if (isInserting) {
      context.missing(_linkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      accountCreatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}account_created_at']),
      linkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}linked_at'])!,
    );
  }

  @override
  $AccountProfileTable createAlias(String alias) {
    return $AccountProfileTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final int id;
  final String uid;
  final String provider;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final DateTime? accountCreatedAt;
  final DateTime linkedAt;
  const AccountRow(
      {required this.id,
      required this.uid,
      required this.provider,
      this.displayName,
      this.email,
      this.photoUrl,
      this.accountCreatedAt,
      required this.linkedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || accountCreatedAt != null) {
      map['account_created_at'] = Variable<DateTime>(accountCreatedAt);
    }
    map['linked_at'] = Variable<DateTime>(linkedAt);
    return map;
  }

  AccountProfileCompanion toCompanion(bool nullToAbsent) {
    return AccountProfileCompanion(
      id: Value(id),
      uid: Value(uid),
      provider: Value(provider),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      accountCreatedAt: accountCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(accountCreatedAt),
      linkedAt: Value(linkedAt),
    );
  }

  factory AccountRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      provider: serializer.fromJson<String>(json['provider']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      email: serializer.fromJson<String?>(json['email']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      accountCreatedAt:
          serializer.fromJson<DateTime?>(json['accountCreatedAt']),
      linkedAt: serializer.fromJson<DateTime>(json['linkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'provider': serializer.toJson<String>(provider),
      'displayName': serializer.toJson<String?>(displayName),
      'email': serializer.toJson<String?>(email),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'accountCreatedAt': serializer.toJson<DateTime?>(accountCreatedAt),
      'linkedAt': serializer.toJson<DateTime>(linkedAt),
    };
  }

  AccountRow copyWith(
          {int? id,
          String? uid,
          String? provider,
          Value<String?> displayName = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> photoUrl = const Value.absent(),
          Value<DateTime?> accountCreatedAt = const Value.absent(),
          DateTime? linkedAt}) =>
      AccountRow(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        provider: provider ?? this.provider,
        displayName: displayName.present ? displayName.value : this.displayName,
        email: email.present ? email.value : this.email,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        accountCreatedAt: accountCreatedAt.present
            ? accountCreatedAt.value
            : this.accountCreatedAt,
        linkedAt: linkedAt ?? this.linkedAt,
      );
  AccountRow copyWithCompanion(AccountProfileCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      provider: data.provider.present ? data.provider.value : this.provider,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      accountCreatedAt: data.accountCreatedAt.present
          ? data.accountCreatedAt.value
          : this.accountCreatedAt,
      linkedAt: data.linkedAt.present ? data.linkedAt.value : this.linkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('provider: $provider, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('accountCreatedAt: $accountCreatedAt, ')
          ..write('linkedAt: $linkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uid, provider, displayName, email,
      photoUrl, accountCreatedAt, linkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.provider == this.provider &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.photoUrl == this.photoUrl &&
          other.accountCreatedAt == this.accountCreatedAt &&
          other.linkedAt == this.linkedAt);
}

class AccountProfileCompanion extends UpdateCompanion<AccountRow> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> provider;
  final Value<String?> displayName;
  final Value<String?> email;
  final Value<String?> photoUrl;
  final Value<DateTime?> accountCreatedAt;
  final Value<DateTime> linkedAt;
  const AccountProfileCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.provider = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.accountCreatedAt = const Value.absent(),
    this.linkedAt = const Value.absent(),
  });
  AccountProfileCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String provider,
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.accountCreatedAt = const Value.absent(),
    required DateTime linkedAt,
  })  : uid = Value(uid),
        provider = Value(provider),
        linkedAt = Value(linkedAt);
  static Insertable<AccountRow> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? provider,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? photoUrl,
    Expression<DateTime>? accountCreatedAt,
    Expression<DateTime>? linkedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (provider != null) 'provider': provider,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (accountCreatedAt != null) 'account_created_at': accountCreatedAt,
      if (linkedAt != null) 'linked_at': linkedAt,
    });
  }

  AccountProfileCompanion copyWith(
      {Value<int>? id,
      Value<String>? uid,
      Value<String>? provider,
      Value<String?>? displayName,
      Value<String?>? email,
      Value<String?>? photoUrl,
      Value<DateTime?>? accountCreatedAt,
      Value<DateTime>? linkedAt}) {
    return AccountProfileCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      provider: provider ?? this.provider,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
      linkedAt: linkedAt ?? this.linkedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (accountCreatedAt.present) {
      map['account_created_at'] = Variable<DateTime>(accountCreatedAt.value);
    }
    if (linkedAt.present) {
      map['linked_at'] = Variable<DateTime>(linkedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountProfileCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('provider: $provider, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('accountCreatedAt: $accountCreatedAt, ')
          ..write('linkedAt: $linkedAt')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _langCodeMeta =
      const VerificationMeta('langCode');
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
      'lang_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
      'target', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enMeta = const VerificationMeta('en');
  @override
  late final GeneratedColumn<String> en = GeneratedColumn<String>(
      'en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pronMeta = const VerificationMeta('pron');
  @override
  late final GeneratedColumn<String> pron = GeneratedColumn<String>(
      'pron', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleMeta =
      const VerificationMeta('example');
  @override
  late final GeneratedColumn<String> example = GeneratedColumn<String>(
      'example', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [langCode, target, en, pron, example, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<Bookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lang_code')) {
      context.handle(_langCodeMeta,
          langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta));
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('en')) {
      context.handle(_enMeta, en.isAcceptableOrUnknown(data['en']!, _enMeta));
    } else if (isInserting) {
      context.missing(_enMeta);
    }
    if (data.containsKey('pron')) {
      context.handle(
          _pronMeta, pron.isAcceptableOrUnknown(data['pron']!, _pronMeta));
    }
    if (data.containsKey('example')) {
      context.handle(_exampleMeta,
          example.isAcceptableOrUnknown(data['example']!, _exampleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {langCode, target};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      langCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang_code'])!,
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target'])!,
      en: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}en'])!,
      pron: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pron']),
      example: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final String langCode;
  final String target;
  final String en;
  final String? pron;
  final String? example;
  final DateTime createdAt;
  const Bookmark(
      {required this.langCode,
      required this.target,
      required this.en,
      this.pron,
      this.example,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lang_code'] = Variable<String>(langCode);
    map['target'] = Variable<String>(target);
    map['en'] = Variable<String>(en);
    if (!nullToAbsent || pron != null) {
      map['pron'] = Variable<String>(pron);
    }
    if (!nullToAbsent || example != null) {
      map['example'] = Variable<String>(example);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      langCode: Value(langCode),
      target: Value(target),
      en: Value(en),
      pron: pron == null && nullToAbsent ? const Value.absent() : Value(pron),
      example: example == null && nullToAbsent
          ? const Value.absent()
          : Value(example),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      langCode: serializer.fromJson<String>(json['langCode']),
      target: serializer.fromJson<String>(json['target']),
      en: serializer.fromJson<String>(json['en']),
      pron: serializer.fromJson<String?>(json['pron']),
      example: serializer.fromJson<String?>(json['example']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'langCode': serializer.toJson<String>(langCode),
      'target': serializer.toJson<String>(target),
      'en': serializer.toJson<String>(en),
      'pron': serializer.toJson<String?>(pron),
      'example': serializer.toJson<String?>(example),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith(
          {String? langCode,
          String? target,
          String? en,
          Value<String?> pron = const Value.absent(),
          Value<String?> example = const Value.absent(),
          DateTime? createdAt}) =>
      Bookmark(
        langCode: langCode ?? this.langCode,
        target: target ?? this.target,
        en: en ?? this.en,
        pron: pron.present ? pron.value : this.pron,
        example: example.present ? example.value : this.example,
        createdAt: createdAt ?? this.createdAt,
      );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      target: data.target.present ? data.target.value : this.target,
      en: data.en.present ? data.en.value : this.en,
      pron: data.pron.present ? data.pron.value : this.pron,
      example: data.example.present ? data.example.value : this.example,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('langCode: $langCode, ')
          ..write('target: $target, ')
          ..write('en: $en, ')
          ..write('pron: $pron, ')
          ..write('example: $example, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(langCode, target, en, pron, example, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.langCode == this.langCode &&
          other.target == this.target &&
          other.en == this.en &&
          other.pron == this.pron &&
          other.example == this.example &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> langCode;
  final Value<String> target;
  final Value<String> en;
  final Value<String?> pron;
  final Value<String?> example;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.langCode = const Value.absent(),
    this.target = const Value.absent(),
    this.en = const Value.absent(),
    this.pron = const Value.absent(),
    this.example = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String langCode,
    required String target,
    required String en,
    this.pron = const Value.absent(),
    this.example = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : langCode = Value(langCode),
        target = Value(target),
        en = Value(en),
        createdAt = Value(createdAt);
  static Insertable<Bookmark> custom({
    Expression<String>? langCode,
    Expression<String>? target,
    Expression<String>? en,
    Expression<String>? pron,
    Expression<String>? example,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (langCode != null) 'lang_code': langCode,
      if (target != null) 'target': target,
      if (en != null) 'en': en,
      if (pron != null) 'pron': pron,
      if (example != null) 'example': example,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith(
      {Value<String>? langCode,
      Value<String>? target,
      Value<String>? en,
      Value<String?>? pron,
      Value<String?>? example,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BookmarksCompanion(
      langCode: langCode ?? this.langCode,
      target: target ?? this.target,
      en: en ?? this.en,
      pron: pron ?? this.pron,
      example: example ?? this.example,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (en.present) {
      map['en'] = Variable<String>(en.value);
    }
    if (pron.present) {
      map['pron'] = Variable<String>(pron.value);
    }
    if (example.present) {
      map['example'] = Variable<String>(example.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('langCode: $langCode, ')
          ..write('target: $target, ')
          ..write('en: $en, ')
          ..write('pron: $pron, ')
          ..write('example: $example, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $ReviewStatesTable reviewStates = $ReviewStatesTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $PronunciationAttemptsTable pronunciationAttempts =
      $PronunciationAttemptsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $ExerciseAttemptsTable exerciseAttempts =
      $ExerciseAttemptsTable(this);
  late final $ExamAttemptsTable examAttempts = $ExamAttemptsTable(this);
  late final $LanguageProgressTable languageProgress =
      $LanguageProgressTable(this);
  late final $StudyTimeTable studyTime = $StudyTimeTable(this);
  late final $XpEventsTable xpEvents = $XpEventsTable(this);
  late final $MissionClaimsTable missionClaims = $MissionClaimsTable(this);
  late final $BadgeUnlocksTable badgeUnlocks = $BadgeUnlocksTable(this);
  late final $GameStateTable gameState = $GameStateTable(this);
  late final $AccountProfileTable accountProfile = $AccountProfileTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        lessons,
        cards,
        reviewStates,
        reviewLogs,
        pronunciationAttempts,
        userProgress,
        lessonProgress,
        exerciseAttempts,
        examAttempts,
        languageProgress,
        studyTime,
        xpEvents,
        missionClaims,
        badgeUnlocks,
        gameState,
        accountProfile,
        bookmarks
      ];
}

typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String langCode,
  required String level,
  required String title,
  required int sortOrder,
  Value<int> version,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> langCode,
  Value<String> level,
  Value<String> title,
  Value<int> sortOrder,
  Value<int> version,
  Value<int> rowid,
});

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
    Lesson,
    PrefetchHooks Function()> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> langCode = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            langCode: langCode,
            level: level,
            title: title,
            sortOrder: sortOrder,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String langCode,
            required String level,
            required String title,
            required int sortOrder,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            langCode: langCode,
            level: level,
            title: title,
            sortOrder: sortOrder,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
    Lesson,
    PrefetchHooks Function()>;
typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String id,
  required String lessonId,
  required int position,
  required String front,
  required String back,
  Value<String?> romanization,
  required String audioText,
  Value<String?> example,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> id,
  Value<String> lessonId,
  Value<int> position,
  Value<String> front,
  Value<String> back,
  Value<String?> romanization,
  Value<String> audioText,
  Value<String?> example,
  Value<int> rowid,
});

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get front => $composableBuilder(
      column: $table.front, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get back => $composableBuilder(
      column: $table.back, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get romanization => $composableBuilder(
      column: $table.romanization, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioText => $composableBuilder(
      column: $table.audioText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnFilters(column));
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get front => $composableBuilder(
      column: $table.front, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get back => $composableBuilder(
      column: $table.back, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get romanization => $composableBuilder(
      column: $table.romanization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioText => $composableBuilder(
      column: $table.audioText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get romanization => $composableBuilder(
      column: $table.romanization, builder: (column) => column);

  GeneratedColumn<String> get audioText =>
      $composableBuilder(column: $table.audioText, builder: (column) => column);

  GeneratedColumn<String> get example =>
      $composableBuilder(column: $table.example, builder: (column) => column);
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    FlashCard,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (FlashCard, BaseReferences<_$AppDatabase, $CardsTable, FlashCard>),
    FlashCard,
    PrefetchHooks Function()> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> front = const Value.absent(),
            Value<String> back = const Value.absent(),
            Value<String?> romanization = const Value.absent(),
            Value<String> audioText = const Value.absent(),
            Value<String?> example = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            lessonId: lessonId,
            position: position,
            front: front,
            back: back,
            romanization: romanization,
            audioText: audioText,
            example: example,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required int position,
            required String front,
            required String back,
            Value<String?> romanization = const Value.absent(),
            required String audioText,
            Value<String?> example = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            lessonId: lessonId,
            position: position,
            front: front,
            back: back,
            romanization: romanization,
            audioText: audioText,
            example: example,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    FlashCard,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (FlashCard, BaseReferences<_$AppDatabase, $CardsTable, FlashCard>),
    FlashCard,
    PrefetchHooks Function()>;
typedef $$ReviewStatesTableCreateCompanionBuilder = ReviewStatesCompanion
    Function({
  required String cardId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  Value<int> lapses,
  required DateTime dueAt,
  Value<double> stability,
  Value<double> difficulty,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});
typedef $$ReviewStatesTableUpdateCompanionBuilder = ReviewStatesCompanion
    Function({
  Value<String> cardId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  Value<int> lapses,
  Value<DateTime> dueAt,
  Value<double> stability,
  Value<double> difficulty,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});

class $$ReviewStatesTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ReviewStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ReviewStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);
}

class $$ReviewStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewStatesTable,
    ReviewRow,
    $$ReviewStatesTableFilterComposer,
    $$ReviewStatesTableOrderingComposer,
    $$ReviewStatesTableAnnotationComposer,
    $$ReviewStatesTableCreateCompanionBuilder,
    $$ReviewStatesTableUpdateCompanionBuilder,
    (ReviewRow, BaseReferences<_$AppDatabase, $ReviewStatesTable, ReviewRow>),
    ReviewRow,
    PrefetchHooks Function()> {
  $$ReviewStatesTableTableManager(_$AppDatabase db, $ReviewStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cardId = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewStatesCompanion(
            cardId: cardId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            lapses: lapses,
            dueAt: dueAt,
            stability: stability,
            difficulty: difficulty,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cardId,
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            required DateTime dueAt,
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewStatesCompanion.insert(
            cardId: cardId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            lapses: lapses,
            dueAt: dueAt,
            stability: stability,
            difficulty: difficulty,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReviewStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewStatesTable,
    ReviewRow,
    $$ReviewStatesTableFilterComposer,
    $$ReviewStatesTableOrderingComposer,
    $$ReviewStatesTableAnnotationComposer,
    $$ReviewStatesTableCreateCompanionBuilder,
    $$ReviewStatesTableUpdateCompanionBuilder,
    (ReviewRow, BaseReferences<_$AppDatabase, $ReviewStatesTable, ReviewRow>),
    ReviewRow,
    PrefetchHooks Function()>;
typedef $$ReviewLogsTableCreateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  required String cardId,
  required int rating,
  required DateTime reviewedAt,
  required int elapsedMs,
});
typedef $$ReviewLogsTableUpdateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  Value<String> cardId,
  Value<int> rating,
  Value<DateTime> reviewedAt,
  Value<int> elapsedMs,
});

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get elapsedMs => $composableBuilder(
      column: $table.elapsedMs, builder: (column) => ColumnFilters(column));
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get elapsedMs => $composableBuilder(
      column: $table.elapsedMs, builder: (column) => ColumnOrderings(column));
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);

  GeneratedColumn<int> get elapsedMs =>
      $composableBuilder(column: $table.elapsedMs, builder: (column) => column);
}

class $$ReviewLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewLogsTable,
    ReviewLog,
    $$ReviewLogsTableFilterComposer,
    $$ReviewLogsTableOrderingComposer,
    $$ReviewLogsTableAnnotationComposer,
    $$ReviewLogsTableCreateCompanionBuilder,
    $$ReviewLogsTableUpdateCompanionBuilder,
    (ReviewLog, BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>),
    ReviewLog,
    PrefetchHooks Function()> {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<DateTime> reviewedAt = const Value.absent(),
            Value<int> elapsedMs = const Value.absent(),
          }) =>
              ReviewLogsCompanion(
            id: id,
            cardId: cardId,
            rating: rating,
            reviewedAt: reviewedAt,
            elapsedMs: elapsedMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String cardId,
            required int rating,
            required DateTime reviewedAt,
            required int elapsedMs,
          }) =>
              ReviewLogsCompanion.insert(
            id: id,
            cardId: cardId,
            rating: rating,
            reviewedAt: reviewedAt,
            elapsedMs: elapsedMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReviewLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewLogsTable,
    ReviewLog,
    $$ReviewLogsTableFilterComposer,
    $$ReviewLogsTableOrderingComposer,
    $$ReviewLogsTableAnnotationComposer,
    $$ReviewLogsTableCreateCompanionBuilder,
    $$ReviewLogsTableUpdateCompanionBuilder,
    (ReviewLog, BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>),
    ReviewLog,
    PrefetchHooks Function()>;
typedef $$PronunciationAttemptsTableCreateCompanionBuilder
    = PronunciationAttemptsCompanion Function({
  Value<int> id,
  required String cardId,
  required String recognized,
  required int score,
  required DateTime at,
});
typedef $$PronunciationAttemptsTableUpdateCompanionBuilder
    = PronunciationAttemptsCompanion Function({
  Value<int> id,
  Value<String> cardId,
  Value<String> recognized,
  Value<int> score,
  Value<DateTime> at,
});

class $$PronunciationAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $PronunciationAttemptsTable> {
  $$PronunciationAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recognized => $composableBuilder(
      column: $table.recognized, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));
}

class $$PronunciationAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $PronunciationAttemptsTable> {
  $$PronunciationAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recognized => $composableBuilder(
      column: $table.recognized, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));
}

class $$PronunciationAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PronunciationAttemptsTable> {
  $$PronunciationAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get recognized => $composableBuilder(
      column: $table.recognized, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$PronunciationAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PronunciationAttemptsTable,
    PronunciationAttempt,
    $$PronunciationAttemptsTableFilterComposer,
    $$PronunciationAttemptsTableOrderingComposer,
    $$PronunciationAttemptsTableAnnotationComposer,
    $$PronunciationAttemptsTableCreateCompanionBuilder,
    $$PronunciationAttemptsTableUpdateCompanionBuilder,
    (
      PronunciationAttempt,
      BaseReferences<_$AppDatabase, $PronunciationAttemptsTable,
          PronunciationAttempt>
    ),
    PronunciationAttempt,
    PrefetchHooks Function()> {
  $$PronunciationAttemptsTableTableManager(
      _$AppDatabase db, $PronunciationAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PronunciationAttemptsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PronunciationAttemptsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PronunciationAttemptsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<String> recognized = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
          }) =>
              PronunciationAttemptsCompanion(
            id: id,
            cardId: cardId,
            recognized: recognized,
            score: score,
            at: at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String cardId,
            required String recognized,
            required int score,
            required DateTime at,
          }) =>
              PronunciationAttemptsCompanion.insert(
            id: id,
            cardId: cardId,
            recognized: recognized,
            score: score,
            at: at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PronunciationAttemptsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PronunciationAttemptsTable,
        PronunciationAttempt,
        $$PronunciationAttemptsTableFilterComposer,
        $$PronunciationAttemptsTableOrderingComposer,
        $$PronunciationAttemptsTableAnnotationComposer,
        $$PronunciationAttemptsTableCreateCompanionBuilder,
        $$PronunciationAttemptsTableUpdateCompanionBuilder,
        (
          PronunciationAttempt,
          BaseReferences<_$AppDatabase, $PronunciationAttemptsTable,
              PronunciationAttempt>
        ),
        PronunciationAttempt,
        PrefetchHooks Function()>;
typedef $$UserProgressTableCreateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<int> streak,
  Value<DateTime?> lastActiveDate,
  Value<int> dailyGoal,
});
typedef $$UserProgressTableUpdateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<int> streak,
  Value<DateTime?> lastActiveDate,
  Value<int> dailyGoal,
});

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyGoal => $composableBuilder(
      column: $table.dailyGoal, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
      column: $table.dailyGoal, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);
}

class $$UserProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTable,
    ProgressRow,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      ProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTable, ProgressRow>
    ),
    ProgressRow,
    PrefetchHooks Function()> {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<DateTime?> lastActiveDate = const Value.absent(),
            Value<int> dailyGoal = const Value.absent(),
          }) =>
              UserProgressCompanion(
            id: id,
            streak: streak,
            lastActiveDate: lastActiveDate,
            dailyGoal: dailyGoal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<DateTime?> lastActiveDate = const Value.absent(),
            Value<int> dailyGoal = const Value.absent(),
          }) =>
              UserProgressCompanion.insert(
            id: id,
            streak: streak,
            lastActiveDate: lastActiveDate,
            dailyGoal: dailyGoal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTable,
    ProgressRow,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      ProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTable, ProgressRow>
    ),
    ProgressRow,
    PrefetchHooks Function()>;
typedef $$LessonProgressTableCreateCompanionBuilder = LessonProgressCompanion
    Function({
  required String lessonId,
  required String langCode,
  required String levelId,
  required String moduleType,
  Value<int> status,
  Value<double> bestScore,
  Value<int> attempts,
  Value<int> runIndex,
  Value<int> runCorrect,
  Value<int> runAnswered,
  Value<int> runSkipped,
  required DateTime updatedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$LessonProgressTableUpdateCompanionBuilder = LessonProgressCompanion
    Function({
  Value<String> lessonId,
  Value<String> langCode,
  Value<String> levelId,
  Value<String> moduleType,
  Value<int> status,
  Value<double> bestScore,
  Value<int> attempts,
  Value<int> runIndex,
  Value<int> runCorrect,
  Value<int> runAnswered,
  Value<int> runSkipped,
  Value<DateTime> updatedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$LessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleType => $composableBuilder(
      column: $table.moduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runIndex => $composableBuilder(
      column: $table.runIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runCorrect => $composableBuilder(
      column: $table.runCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runAnswered => $composableBuilder(
      column: $table.runAnswered, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runSkipped => $composableBuilder(
      column: $table.runSkipped, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleType => $composableBuilder(
      column: $table.moduleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runIndex => $composableBuilder(
      column: $table.runIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runCorrect => $composableBuilder(
      column: $table.runCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runAnswered => $composableBuilder(
      column: $table.runAnswered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runSkipped => $composableBuilder(
      column: $table.runSkipped, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get moduleType => $composableBuilder(
      column: $table.moduleType, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get runIndex =>
      $composableBuilder(column: $table.runIndex, builder: (column) => column);

  GeneratedColumn<int> get runCorrect => $composableBuilder(
      column: $table.runCorrect, builder: (column) => column);

  GeneratedColumn<int> get runAnswered => $composableBuilder(
      column: $table.runAnswered, builder: (column) => column);

  GeneratedColumn<int> get runSkipped => $composableBuilder(
      column: $table.runSkipped, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$LessonProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressRow,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressRow,
      BaseReferences<_$AppDatabase, $LessonProgressTable, LessonProgressRow>
    ),
    LessonProgressRow,
    PrefetchHooks Function()> {
  $$LessonProgressTableTableManager(
      _$AppDatabase db, $LessonProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<String> langCode = const Value.absent(),
            Value<String> levelId = const Value.absent(),
            Value<String> moduleType = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<double> bestScore = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> runIndex = const Value.absent(),
            Value<int> runCorrect = const Value.absent(),
            Value<int> runAnswered = const Value.absent(),
            Value<int> runSkipped = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion(
            lessonId: lessonId,
            langCode: langCode,
            levelId: levelId,
            moduleType: moduleType,
            status: status,
            bestScore: bestScore,
            attempts: attempts,
            runIndex: runIndex,
            runCorrect: runCorrect,
            runAnswered: runAnswered,
            runSkipped: runSkipped,
            updatedAt: updatedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            required String langCode,
            required String levelId,
            required String moduleType,
            Value<int> status = const Value.absent(),
            Value<double> bestScore = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> runIndex = const Value.absent(),
            Value<int> runCorrect = const Value.absent(),
            Value<int> runAnswered = const Value.absent(),
            Value<int> runSkipped = const Value.absent(),
            required DateTime updatedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion.insert(
            lessonId: lessonId,
            langCode: langCode,
            levelId: levelId,
            moduleType: moduleType,
            status: status,
            bestScore: bestScore,
            attempts: attempts,
            runIndex: runIndex,
            runCorrect: runCorrect,
            runAnswered: runAnswered,
            runSkipped: runSkipped,
            updatedAt: updatedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressRow,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressRow,
      BaseReferences<_$AppDatabase, $LessonProgressTable, LessonProgressRow>
    ),
    LessonProgressRow,
    PrefetchHooks Function()>;
typedef $$ExerciseAttemptsTableCreateCompanionBuilder
    = ExerciseAttemptsCompanion Function({
  Value<int> id,
  required String langCode,
  required String lessonId,
  required String questionId,
  required String questionType,
  required bool correct,
  Value<bool> skipped,
  Value<String> answer,
  Value<int?> score,
  required DateTime at,
});
typedef $$ExerciseAttemptsTableUpdateCompanionBuilder
    = ExerciseAttemptsCompanion Function({
  Value<int> id,
  Value<String> langCode,
  Value<String> lessonId,
  Value<String> questionId,
  Value<String> questionType,
  Value<bool> correct,
  Value<bool> skipped,
  Value<String> answer,
  Value<int?> score,
  Value<DateTime> at,
});

class $$ExerciseAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionType => $composableBuilder(
      column: $table.questionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get skipped => $composableBuilder(
      column: $table.skipped, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));
}

class $$ExerciseAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionType => $composableBuilder(
      column: $table.questionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get skipped => $composableBuilder(
      column: $table.skipped, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));
}

class $$ExerciseAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<String> get questionType => $composableBuilder(
      column: $table.questionType, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$ExerciseAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseAttemptsTable,
    ExerciseAttempt,
    $$ExerciseAttemptsTableFilterComposer,
    $$ExerciseAttemptsTableOrderingComposer,
    $$ExerciseAttemptsTableAnnotationComposer,
    $$ExerciseAttemptsTableCreateCompanionBuilder,
    $$ExerciseAttemptsTableUpdateCompanionBuilder,
    (
      ExerciseAttempt,
      BaseReferences<_$AppDatabase, $ExerciseAttemptsTable, ExerciseAttempt>
    ),
    ExerciseAttempt,
    PrefetchHooks Function()> {
  $$ExerciseAttemptsTableTableManager(
      _$AppDatabase db, $ExerciseAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> langCode = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<String> questionType = const Value.absent(),
            Value<bool> correct = const Value.absent(),
            Value<bool> skipped = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<int?> score = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
          }) =>
              ExerciseAttemptsCompanion(
            id: id,
            langCode: langCode,
            lessonId: lessonId,
            questionId: questionId,
            questionType: questionType,
            correct: correct,
            skipped: skipped,
            answer: answer,
            score: score,
            at: at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String langCode,
            required String lessonId,
            required String questionId,
            required String questionType,
            required bool correct,
            Value<bool> skipped = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<int?> score = const Value.absent(),
            required DateTime at,
          }) =>
              ExerciseAttemptsCompanion.insert(
            id: id,
            langCode: langCode,
            lessonId: lessonId,
            questionId: questionId,
            questionType: questionType,
            correct: correct,
            skipped: skipped,
            answer: answer,
            score: score,
            at: at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExerciseAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseAttemptsTable,
    ExerciseAttempt,
    $$ExerciseAttemptsTableFilterComposer,
    $$ExerciseAttemptsTableOrderingComposer,
    $$ExerciseAttemptsTableAnnotationComposer,
    $$ExerciseAttemptsTableCreateCompanionBuilder,
    $$ExerciseAttemptsTableUpdateCompanionBuilder,
    (
      ExerciseAttempt,
      BaseReferences<_$AppDatabase, $ExerciseAttemptsTable, ExerciseAttempt>
    ),
    ExerciseAttempt,
    PrefetchHooks Function()>;
typedef $$ExamAttemptsTableCreateCompanionBuilder = ExamAttemptsCompanion
    Function({
  Value<int> id,
  required String langCode,
  required String levelId,
  Value<String> kind,
  required double percent,
  required bool passed,
  required int threshold,
  Value<String> detailJson,
  required DateTime startedAt,
  required DateTime finishedAt,
});
typedef $$ExamAttemptsTableUpdateCompanionBuilder = ExamAttemptsCompanion
    Function({
  Value<int> id,
  Value<String> langCode,
  Value<String> levelId,
  Value<String> kind,
  Value<double> percent,
  Value<bool> passed,
  Value<int> threshold,
  Value<String> detailJson,
  Value<DateTime> startedAt,
  Value<DateTime> finishedAt,
});

class $$ExamAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get passed => $composableBuilder(
      column: $table.passed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));
}

class $$ExamAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get passed => $composableBuilder(
      column: $table.passed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExamAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<int> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);
}

class $$ExamAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamAttemptsTable,
    ExamAttempt,
    $$ExamAttemptsTableFilterComposer,
    $$ExamAttemptsTableOrderingComposer,
    $$ExamAttemptsTableAnnotationComposer,
    $$ExamAttemptsTableCreateCompanionBuilder,
    $$ExamAttemptsTableUpdateCompanionBuilder,
    (
      ExamAttempt,
      BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttempt>
    ),
    ExamAttempt,
    PrefetchHooks Function()> {
  $$ExamAttemptsTableTableManager(_$AppDatabase db, $ExamAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> langCode = const Value.absent(),
            Value<String> levelId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<double> percent = const Value.absent(),
            Value<bool> passed = const Value.absent(),
            Value<int> threshold = const Value.absent(),
            Value<String> detailJson = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> finishedAt = const Value.absent(),
          }) =>
              ExamAttemptsCompanion(
            id: id,
            langCode: langCode,
            levelId: levelId,
            kind: kind,
            percent: percent,
            passed: passed,
            threshold: threshold,
            detailJson: detailJson,
            startedAt: startedAt,
            finishedAt: finishedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String langCode,
            required String levelId,
            Value<String> kind = const Value.absent(),
            required double percent,
            required bool passed,
            required int threshold,
            Value<String> detailJson = const Value.absent(),
            required DateTime startedAt,
            required DateTime finishedAt,
          }) =>
              ExamAttemptsCompanion.insert(
            id: id,
            langCode: langCode,
            levelId: levelId,
            kind: kind,
            percent: percent,
            passed: passed,
            threshold: threshold,
            detailJson: detailJson,
            startedAt: startedAt,
            finishedAt: finishedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExamAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamAttemptsTable,
    ExamAttempt,
    $$ExamAttemptsTableFilterComposer,
    $$ExamAttemptsTableOrderingComposer,
    $$ExamAttemptsTableAnnotationComposer,
    $$ExamAttemptsTableCreateCompanionBuilder,
    $$ExamAttemptsTableUpdateCompanionBuilder,
    (
      ExamAttempt,
      BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttempt>
    ),
    ExamAttempt,
    PrefetchHooks Function()>;
typedef $$LanguageProgressTableCreateCompanionBuilder
    = LanguageProgressCompanion Function({
  required String langCode,
  Value<String?> startLevelId,
  Value<String?> placementLevelId,
  Value<String?> lastLessonId,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LanguageProgressTableUpdateCompanionBuilder
    = LanguageProgressCompanion Function({
  Value<String> langCode,
  Value<String?> startLevelId,
  Value<String?> placementLevelId,
  Value<String?> lastLessonId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LanguageProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LanguageProgressTable> {
  $$LanguageProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startLevelId => $composableBuilder(
      column: $table.startLevelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placementLevelId => $composableBuilder(
      column: $table.placementLevelId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastLessonId => $composableBuilder(
      column: $table.lastLessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LanguageProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguageProgressTable> {
  $$LanguageProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startLevelId => $composableBuilder(
      column: $table.startLevelId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placementLevelId => $composableBuilder(
      column: $table.placementLevelId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastLessonId => $composableBuilder(
      column: $table.lastLessonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LanguageProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguageProgressTable> {
  $$LanguageProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get startLevelId => $composableBuilder(
      column: $table.startLevelId, builder: (column) => column);

  GeneratedColumn<String> get placementLevelId => $composableBuilder(
      column: $table.placementLevelId, builder: (column) => column);

  GeneratedColumn<String> get lastLessonId => $composableBuilder(
      column: $table.lastLessonId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LanguageProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LanguageProgressTable,
    LanguageProgressRow,
    $$LanguageProgressTableFilterComposer,
    $$LanguageProgressTableOrderingComposer,
    $$LanguageProgressTableAnnotationComposer,
    $$LanguageProgressTableCreateCompanionBuilder,
    $$LanguageProgressTableUpdateCompanionBuilder,
    (
      LanguageProgressRow,
      BaseReferences<_$AppDatabase, $LanguageProgressTable, LanguageProgressRow>
    ),
    LanguageProgressRow,
    PrefetchHooks Function()> {
  $$LanguageProgressTableTableManager(
      _$AppDatabase db, $LanguageProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguageProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguageProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguageProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> langCode = const Value.absent(),
            Value<String?> startLevelId = const Value.absent(),
            Value<String?> placementLevelId = const Value.absent(),
            Value<String?> lastLessonId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LanguageProgressCompanion(
            langCode: langCode,
            startLevelId: startLevelId,
            placementLevelId: placementLevelId,
            lastLessonId: lastLessonId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String langCode,
            Value<String?> startLevelId = const Value.absent(),
            Value<String?> placementLevelId = const Value.absent(),
            Value<String?> lastLessonId = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LanguageProgressCompanion.insert(
            langCode: langCode,
            startLevelId: startLevelId,
            placementLevelId: placementLevelId,
            lastLessonId: lastLessonId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LanguageProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LanguageProgressTable,
    LanguageProgressRow,
    $$LanguageProgressTableFilterComposer,
    $$LanguageProgressTableOrderingComposer,
    $$LanguageProgressTableAnnotationComposer,
    $$LanguageProgressTableCreateCompanionBuilder,
    $$LanguageProgressTableUpdateCompanionBuilder,
    (
      LanguageProgressRow,
      BaseReferences<_$AppDatabase, $LanguageProgressTable, LanguageProgressRow>
    ),
    LanguageProgressRow,
    PrefetchHooks Function()>;
typedef $$StudyTimeTableCreateCompanionBuilder = StudyTimeCompanion Function({
  required String langCode,
  required DateTime day,
  Value<int> ms,
  Value<int> rowid,
});
typedef $$StudyTimeTableUpdateCompanionBuilder = StudyTimeCompanion Function({
  Value<String> langCode,
  Value<DateTime> day,
  Value<int> ms,
  Value<int> rowid,
});

class $$StudyTimeTableFilterComposer
    extends Composer<_$AppDatabase, $StudyTimeTable> {
  $$StudyTimeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ms => $composableBuilder(
      column: $table.ms, builder: (column) => ColumnFilters(column));
}

class $$StudyTimeTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyTimeTable> {
  $$StudyTimeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ms => $composableBuilder(
      column: $table.ms, builder: (column) => ColumnOrderings(column));
}

class $$StudyTimeTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyTimeTable> {
  $$StudyTimeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get ms =>
      $composableBuilder(column: $table.ms, builder: (column) => column);
}

class $$StudyTimeTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudyTimeTable,
    StudyTimeRow,
    $$StudyTimeTableFilterComposer,
    $$StudyTimeTableOrderingComposer,
    $$StudyTimeTableAnnotationComposer,
    $$StudyTimeTableCreateCompanionBuilder,
    $$StudyTimeTableUpdateCompanionBuilder,
    (
      StudyTimeRow,
      BaseReferences<_$AppDatabase, $StudyTimeTable, StudyTimeRow>
    ),
    StudyTimeRow,
    PrefetchHooks Function()> {
  $$StudyTimeTableTableManager(_$AppDatabase db, $StudyTimeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyTimeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyTimeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyTimeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> langCode = const Value.absent(),
            Value<DateTime> day = const Value.absent(),
            Value<int> ms = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyTimeCompanion(
            langCode: langCode,
            day: day,
            ms: ms,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String langCode,
            required DateTime day,
            Value<int> ms = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyTimeCompanion.insert(
            langCode: langCode,
            day: day,
            ms: ms,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudyTimeTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudyTimeTable,
    StudyTimeRow,
    $$StudyTimeTableFilterComposer,
    $$StudyTimeTableOrderingComposer,
    $$StudyTimeTableAnnotationComposer,
    $$StudyTimeTableCreateCompanionBuilder,
    $$StudyTimeTableUpdateCompanionBuilder,
    (
      StudyTimeRow,
      BaseReferences<_$AppDatabase, $StudyTimeTable, StudyTimeRow>
    ),
    StudyTimeRow,
    PrefetchHooks Function()>;
typedef $$XpEventsTableCreateCompanionBuilder = XpEventsCompanion Function({
  Value<int> id,
  required String langCode,
  required int amount,
  required String reason,
  required DateTime at,
});
typedef $$XpEventsTableUpdateCompanionBuilder = XpEventsCompanion Function({
  Value<int> id,
  Value<String> langCode,
  Value<int> amount,
  Value<String> reason,
  Value<DateTime> at,
});

class $$XpEventsTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));
}

class $$XpEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));
}

class $$XpEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$XpEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEvent,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
    XpEvent,
    PrefetchHooks Function()> {
  $$XpEventsTableTableManager(_$AppDatabase db, $XpEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> langCode = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
          }) =>
              XpEventsCompanion(
            id: id,
            langCode: langCode,
            amount: amount,
            reason: reason,
            at: at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String langCode,
            required int amount,
            required String reason,
            required DateTime at,
          }) =>
              XpEventsCompanion.insert(
            id: id,
            langCode: langCode,
            amount: amount,
            reason: reason,
            at: at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$XpEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEvent,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
    XpEvent,
    PrefetchHooks Function()>;
typedef $$MissionClaimsTableCreateCompanionBuilder = MissionClaimsCompanion
    Function({
  required String periodKey,
  required String missionId,
  required int xp,
  required DateTime claimedAt,
  Value<int> rowid,
});
typedef $$MissionClaimsTableUpdateCompanionBuilder = MissionClaimsCompanion
    Function({
  Value<String> periodKey,
  Value<String> missionId,
  Value<int> xp,
  Value<DateTime> claimedAt,
  Value<int> rowid,
});

class $$MissionClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionClaimsTable> {
  $$MissionClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get periodKey => $composableBuilder(
      column: $table.periodKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get missionId => $composableBuilder(
      column: $table.missionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get claimedAt => $composableBuilder(
      column: $table.claimedAt, builder: (column) => ColumnFilters(column));
}

class $$MissionClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionClaimsTable> {
  $$MissionClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get periodKey => $composableBuilder(
      column: $table.periodKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get missionId => $composableBuilder(
      column: $table.missionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get claimedAt => $composableBuilder(
      column: $table.claimedAt, builder: (column) => ColumnOrderings(column));
}

class $$MissionClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionClaimsTable> {
  $$MissionClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<String> get missionId =>
      $composableBuilder(column: $table.missionId, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<DateTime> get claimedAt =>
      $composableBuilder(column: $table.claimedAt, builder: (column) => column);
}

class $$MissionClaimsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MissionClaimsTable,
    MissionClaim,
    $$MissionClaimsTableFilterComposer,
    $$MissionClaimsTableOrderingComposer,
    $$MissionClaimsTableAnnotationComposer,
    $$MissionClaimsTableCreateCompanionBuilder,
    $$MissionClaimsTableUpdateCompanionBuilder,
    (
      MissionClaim,
      BaseReferences<_$AppDatabase, $MissionClaimsTable, MissionClaim>
    ),
    MissionClaim,
    PrefetchHooks Function()> {
  $$MissionClaimsTableTableManager(_$AppDatabase db, $MissionClaimsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> periodKey = const Value.absent(),
            Value<String> missionId = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<DateTime> claimedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MissionClaimsCompanion(
            periodKey: periodKey,
            missionId: missionId,
            xp: xp,
            claimedAt: claimedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String periodKey,
            required String missionId,
            required int xp,
            required DateTime claimedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MissionClaimsCompanion.insert(
            periodKey: periodKey,
            missionId: missionId,
            xp: xp,
            claimedAt: claimedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MissionClaimsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MissionClaimsTable,
    MissionClaim,
    $$MissionClaimsTableFilterComposer,
    $$MissionClaimsTableOrderingComposer,
    $$MissionClaimsTableAnnotationComposer,
    $$MissionClaimsTableCreateCompanionBuilder,
    $$MissionClaimsTableUpdateCompanionBuilder,
    (
      MissionClaim,
      BaseReferences<_$AppDatabase, $MissionClaimsTable, MissionClaim>
    ),
    MissionClaim,
    PrefetchHooks Function()>;
typedef $$BadgeUnlocksTableCreateCompanionBuilder = BadgeUnlocksCompanion
    Function({
  required String badgeId,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$BadgeUnlocksTableUpdateCompanionBuilder = BadgeUnlocksCompanion
    Function({
  Value<String> badgeId,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$BadgeUnlocksTableFilterComposer
    extends Composer<_$AppDatabase, $BadgeUnlocksTable> {
  $$BadgeUnlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get badgeId => $composableBuilder(
      column: $table.badgeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$BadgeUnlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgeUnlocksTable> {
  $$BadgeUnlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get badgeId => $composableBuilder(
      column: $table.badgeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$BadgeUnlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgeUnlocksTable> {
  $$BadgeUnlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get badgeId =>
      $composableBuilder(column: $table.badgeId, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$BadgeUnlocksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BadgeUnlocksTable,
    BadgeUnlock,
    $$BadgeUnlocksTableFilterComposer,
    $$BadgeUnlocksTableOrderingComposer,
    $$BadgeUnlocksTableAnnotationComposer,
    $$BadgeUnlocksTableCreateCompanionBuilder,
    $$BadgeUnlocksTableUpdateCompanionBuilder,
    (
      BadgeUnlock,
      BaseReferences<_$AppDatabase, $BadgeUnlocksTable, BadgeUnlock>
    ),
    BadgeUnlock,
    PrefetchHooks Function()> {
  $$BadgeUnlocksTableTableManager(_$AppDatabase db, $BadgeUnlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgeUnlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgeUnlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgeUnlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> badgeId = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BadgeUnlocksCompanion(
            badgeId: badgeId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String badgeId,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BadgeUnlocksCompanion.insert(
            badgeId: badgeId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BadgeUnlocksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BadgeUnlocksTable,
    BadgeUnlock,
    $$BadgeUnlocksTableFilterComposer,
    $$BadgeUnlocksTableOrderingComposer,
    $$BadgeUnlocksTableAnnotationComposer,
    $$BadgeUnlocksTableCreateCompanionBuilder,
    $$BadgeUnlocksTableUpdateCompanionBuilder,
    (
      BadgeUnlock,
      BaseReferences<_$AppDatabase, $BadgeUnlocksTable, BadgeUnlock>
    ),
    BadgeUnlock,
    PrefetchHooks Function()>;
typedef $$GameStateTableCreateCompanionBuilder = GameStateCompanion Function({
  Value<int> id,
  Value<int> hearts,
  Value<DateTime?> heartsUpdatedAt,
});
typedef $$GameStateTableUpdateCompanionBuilder = GameStateCompanion Function({
  Value<int> id,
  Value<int> hearts,
  Value<DateTime?> heartsUpdatedAt,
});

class $$GameStateTableFilterComposer
    extends Composer<_$AppDatabase, $GameStateTable> {
  $$GameStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hearts => $composableBuilder(
      column: $table.hearts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get heartsUpdatedAt => $composableBuilder(
      column: $table.heartsUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$GameStateTableOrderingComposer
    extends Composer<_$AppDatabase, $GameStateTable> {
  $$GameStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hearts => $composableBuilder(
      column: $table.hearts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get heartsUpdatedAt => $composableBuilder(
      column: $table.heartsUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$GameStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameStateTable> {
  $$GameStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hearts =>
      $composableBuilder(column: $table.hearts, builder: (column) => column);

  GeneratedColumn<DateTime> get heartsUpdatedAt => $composableBuilder(
      column: $table.heartsUpdatedAt, builder: (column) => column);
}

class $$GameStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameStateTable,
    GameStateRow,
    $$GameStateTableFilterComposer,
    $$GameStateTableOrderingComposer,
    $$GameStateTableAnnotationComposer,
    $$GameStateTableCreateCompanionBuilder,
    $$GameStateTableUpdateCompanionBuilder,
    (
      GameStateRow,
      BaseReferences<_$AppDatabase, $GameStateTable, GameStateRow>
    ),
    GameStateRow,
    PrefetchHooks Function()> {
  $$GameStateTableTableManager(_$AppDatabase db, $GameStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> hearts = const Value.absent(),
            Value<DateTime?> heartsUpdatedAt = const Value.absent(),
          }) =>
              GameStateCompanion(
            id: id,
            hearts: hearts,
            heartsUpdatedAt: heartsUpdatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> hearts = const Value.absent(),
            Value<DateTime?> heartsUpdatedAt = const Value.absent(),
          }) =>
              GameStateCompanion.insert(
            id: id,
            hearts: hearts,
            heartsUpdatedAt: heartsUpdatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GameStateTable,
    GameStateRow,
    $$GameStateTableFilterComposer,
    $$GameStateTableOrderingComposer,
    $$GameStateTableAnnotationComposer,
    $$GameStateTableCreateCompanionBuilder,
    $$GameStateTableUpdateCompanionBuilder,
    (
      GameStateRow,
      BaseReferences<_$AppDatabase, $GameStateTable, GameStateRow>
    ),
    GameStateRow,
    PrefetchHooks Function()>;
typedef $$AccountProfileTableCreateCompanionBuilder = AccountProfileCompanion
    Function({
  Value<int> id,
  required String uid,
  required String provider,
  Value<String?> displayName,
  Value<String?> email,
  Value<String?> photoUrl,
  Value<DateTime?> accountCreatedAt,
  required DateTime linkedAt,
});
typedef $$AccountProfileTableUpdateCompanionBuilder = AccountProfileCompanion
    Function({
  Value<int> id,
  Value<String> uid,
  Value<String> provider,
  Value<String?> displayName,
  Value<String?> email,
  Value<String?> photoUrl,
  Value<DateTime?> accountCreatedAt,
  Value<DateTime> linkedAt,
});

class $$AccountProfileTableFilterComposer
    extends Composer<_$AppDatabase, $AccountProfileTable> {
  $$AccountProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get accountCreatedAt => $composableBuilder(
      column: $table.accountCreatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnFilters(column));
}

class $$AccountProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountProfileTable> {
  $$AccountProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get accountCreatedAt => $composableBuilder(
      column: $table.accountCreatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountProfileTable> {
  $$AccountProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get accountCreatedAt => $composableBuilder(
      column: $table.accountCreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get linkedAt =>
      $composableBuilder(column: $table.linkedAt, builder: (column) => column);
}

class $$AccountProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountProfileTable,
    AccountRow,
    $$AccountProfileTableFilterComposer,
    $$AccountProfileTableOrderingComposer,
    $$AccountProfileTableAnnotationComposer,
    $$AccountProfileTableCreateCompanionBuilder,
    $$AccountProfileTableUpdateCompanionBuilder,
    (
      AccountRow,
      BaseReferences<_$AppDatabase, $AccountProfileTable, AccountRow>
    ),
    AccountRow,
    PrefetchHooks Function()> {
  $$AccountProfileTableTableManager(
      _$AppDatabase db, $AccountProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uid = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<DateTime?> accountCreatedAt = const Value.absent(),
            Value<DateTime> linkedAt = const Value.absent(),
          }) =>
              AccountProfileCompanion(
            id: id,
            uid: uid,
            provider: provider,
            displayName: displayName,
            email: email,
            photoUrl: photoUrl,
            accountCreatedAt: accountCreatedAt,
            linkedAt: linkedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uid,
            required String provider,
            Value<String?> displayName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<DateTime?> accountCreatedAt = const Value.absent(),
            required DateTime linkedAt,
          }) =>
              AccountProfileCompanion.insert(
            id: id,
            uid: uid,
            provider: provider,
            displayName: displayName,
            email: email,
            photoUrl: photoUrl,
            accountCreatedAt: accountCreatedAt,
            linkedAt: linkedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountProfileTable,
    AccountRow,
    $$AccountProfileTableFilterComposer,
    $$AccountProfileTableOrderingComposer,
    $$AccountProfileTableAnnotationComposer,
    $$AccountProfileTableCreateCompanionBuilder,
    $$AccountProfileTableUpdateCompanionBuilder,
    (
      AccountRow,
      BaseReferences<_$AppDatabase, $AccountProfileTable, AccountRow>
    ),
    AccountRow,
    PrefetchHooks Function()>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String langCode,
  required String target,
  required String en,
  Value<String?> pron,
  Value<String?> example,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> langCode,
  Value<String> target,
  Value<String> en,
  Value<String?> pron,
  Value<String?> example,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get en => $composableBuilder(
      column: $table.en, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pron => $composableBuilder(
      column: $table.pron, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get langCode => $composableBuilder(
      column: $table.langCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get en => $composableBuilder(
      column: $table.en, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pron => $composableBuilder(
      column: $table.pron, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get en =>
      $composableBuilder(column: $table.en, builder: (column) => column);

  GeneratedColumn<String> get pron =>
      $composableBuilder(column: $table.pron, builder: (column) => column);

  GeneratedColumn<String> get example =>
      $composableBuilder(column: $table.example, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> langCode = const Value.absent(),
            Value<String> target = const Value.absent(),
            Value<String> en = const Value.absent(),
            Value<String?> pron = const Value.absent(),
            Value<String?> example = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion(
            langCode: langCode,
            target: target,
            en: en,
            pron: pron,
            example: example,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String langCode,
            required String target,
            required String en,
            Value<String?> pron = const Value.absent(),
            Value<String?> example = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            langCode: langCode,
            target: target,
            en: en,
            pron: pron,
            example: example,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$ReviewStatesTableTableManager get reviewStates =>
      $$ReviewStatesTableTableManager(_db, _db.reviewStates);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$PronunciationAttemptsTableTableManager get pronunciationAttempts =>
      $$PronunciationAttemptsTableTableManager(_db, _db.pronunciationAttempts);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$ExerciseAttemptsTableTableManager get exerciseAttempts =>
      $$ExerciseAttemptsTableTableManager(_db, _db.exerciseAttempts);
  $$ExamAttemptsTableTableManager get examAttempts =>
      $$ExamAttemptsTableTableManager(_db, _db.examAttempts);
  $$LanguageProgressTableTableManager get languageProgress =>
      $$LanguageProgressTableTableManager(_db, _db.languageProgress);
  $$StudyTimeTableTableManager get studyTime =>
      $$StudyTimeTableTableManager(_db, _db.studyTime);
  $$XpEventsTableTableManager get xpEvents =>
      $$XpEventsTableTableManager(_db, _db.xpEvents);
  $$MissionClaimsTableTableManager get missionClaims =>
      $$MissionClaimsTableTableManager(_db, _db.missionClaims);
  $$BadgeUnlocksTableTableManager get badgeUnlocks =>
      $$BadgeUnlocksTableTableManager(_db, _db.badgeUnlocks);
  $$GameStateTableTableManager get gameState =>
      $$GameStateTableTableManager(_db, _db.gameState);
  $$AccountProfileTableTableManager get accountProfile =>
      $$AccountProfileTableTableManager(_db, _db.accountProfile);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
