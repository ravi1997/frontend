// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $CachedFormsTable extends CachedForms
    with TableInfo<$CachedFormsTable, CachedForm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFormsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, slug, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_forms';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedForm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedForm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedForm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedFormsTable createAlias(String alias) {
    return $CachedFormsTable(attachedDatabase, alias);
  }
}

class CachedForm extends DataClass implements Insertable<CachedForm> {
  final String id;
  final String title;
  final String slug;
  final String rawJson;
  final DateTime cachedAt;
  const CachedForm({
    required this.id,
    required this.title,
    required this.slug,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedFormsCompanion toCompanion(bool nullToAbsent) {
    return CachedFormsCompanion(
      id: Value(id),
      title: Value(title),
      slug: Value(slug),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedForm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedForm(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedForm copyWith({
    String? id,
    String? title,
    String? slug,
    String? rawJson,
    DateTime? cachedAt,
  }) => CachedForm(
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedForm copyWithCompanion(CachedFormsCompanion data) {
    return CachedForm(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      slug: data.slug.present ? data.slug.value : this.slug,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedForm(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, slug, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedForm &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class CachedFormsCompanion extends UpdateCompanion<CachedForm> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedFormsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedFormsCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String rawJson,
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       slug = Value(slug),
       rawJson = Value(rawJson);
  static Insertable<CachedForm> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedFormsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? slug,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedFormsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      rawJson: rawJson ?? this.rawJson,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFormsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedResponsesTable extends CachedResponses
    with TableInfo<$CachedResponsesTable, CachedResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    formId,
    dataJson,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedResponse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedResponse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CachedResponsesTable createAlias(String alias) {
    return $CachedResponsesTable(attachedDatabase, alias);
  }
}

class CachedResponse extends DataClass implements Insertable<CachedResponse> {
  final String id;
  final String formId;
  final String dataJson;
  final String status;
  final DateTime createdAt;
  const CachedResponse({
    required this.id,
    required this.formId,
    required this.dataJson,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form_id'] = Variable<String>(formId);
    map['data_json'] = Variable<String>(dataJson);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CachedResponsesCompanion toCompanion(bool nullToAbsent) {
    return CachedResponsesCompanion(
      id: Value(id),
      formId: Value(formId),
      dataJson: Value(dataJson),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory CachedResponse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedResponse(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String>(json['formId']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String>(formId),
      'dataJson': serializer.toJson<String>(dataJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CachedResponse copyWith({
    String? id,
    String? formId,
    String? dataJson,
    String? status,
    DateTime? createdAt,
  }) => CachedResponse(
    id: id ?? this.id,
    formId: formId ?? this.formId,
    dataJson: dataJson ?? this.dataJson,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  CachedResponse copyWithCompanion(CachedResponsesCompanion data) {
    return CachedResponse(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedResponse(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, formId, dataJson, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedResponse &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.dataJson == this.dataJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class CachedResponsesCompanion extends UpdateCompanion<CachedResponse> {
  final Value<String> id;
  final Value<String> formId;
  final Value<String> dataJson;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CachedResponsesCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedResponsesCompanion.insert({
    required String id,
    required String formId,
    required String dataJson,
    required String status,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       formId = Value(formId),
       dataJson = Value(dataJson),
       status = Value(status);
  static Insertable<CachedResponse> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? dataJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (dataJson != null) 'data_json': dataJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedResponsesCompanion copyWith({
    Value<String>? id,
    Value<String>? formId,
    Value<String>? dataJson,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CachedResponsesCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      dataJson: dataJson ?? this.dataJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('CachedResponsesCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingUploadsTable extends PendingUploads
    with TableInfo<$PendingUploadsTable, PendingUpload> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingUploadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    formId,
    payloadJson,
    queuedAt,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_uploads';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingUpload> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingUpload map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingUpload(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $PendingUploadsTable createAlias(String alias) {
    return $PendingUploadsTable(attachedDatabase, alias);
  }
}

class PendingUpload extends DataClass implements Insertable<PendingUpload> {
  final String id;
  final String formId;
  final String payloadJson;
  final DateTime queuedAt;
  final int retryCount;
  const PendingUpload({
    required this.id,
    required this.formId,
    required this.payloadJson,
    required this.queuedAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form_id'] = Variable<String>(formId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  PendingUploadsCompanion toCompanion(bool nullToAbsent) {
    return PendingUploadsCompanion(
      id: Value(id),
      formId: Value(formId),
      payloadJson: Value(payloadJson),
      queuedAt: Value(queuedAt),
      retryCount: Value(retryCount),
    );
  }

  factory PendingUpload.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingUpload(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String>(json['formId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String>(formId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  PendingUpload copyWith({
    String? id,
    String? formId,
    String? payloadJson,
    DateTime? queuedAt,
    int? retryCount,
  }) => PendingUpload(
    id: id ?? this.id,
    formId: formId ?? this.formId,
    payloadJson: payloadJson ?? this.payloadJson,
    queuedAt: queuedAt ?? this.queuedAt,
    retryCount: retryCount ?? this.retryCount,
  );
  PendingUpload copyWithCompanion(PendingUploadsCompanion data) {
    return PendingUpload(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingUpload(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, formId, payloadJson, queuedAt, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingUpload &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.payloadJson == this.payloadJson &&
          other.queuedAt == this.queuedAt &&
          other.retryCount == this.retryCount);
}

class PendingUploadsCompanion extends UpdateCompanion<PendingUpload> {
  final Value<String> id;
  final Value<String> formId;
  final Value<String> payloadJson;
  final Value<DateTime> queuedAt;
  final Value<int> retryCount;
  final Value<int> rowid;
  const PendingUploadsCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingUploadsCompanion.insert({
    required String id,
    required String formId,
    required String payloadJson,
    this.queuedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       formId = Value(formId),
       payloadJson = Value(payloadJson);
  static Insertable<PendingUpload> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? payloadJson,
    Expression<DateTime>? queuedAt,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingUploadsCompanion copyWith({
    Value<String>? id,
    Value<String>? formId,
    Value<String>? payloadJson,
    Value<DateTime>? queuedAt,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return PendingUploadsCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      payloadJson: payloadJson ?? this.payloadJson,
      queuedAt: queuedAt ?? this.queuedAt,
      retryCount: retryCount ?? this.retryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingUploadsCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $CachedFormsTable cachedForms = $CachedFormsTable(this);
  late final $CachedResponsesTable cachedResponses = $CachedResponsesTable(
    this,
  );
  late final $PendingUploadsTable pendingUploads = $PendingUploadsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedForms,
    cachedResponses,
    pendingUploads,
  ];
}

typedef $$CachedFormsTableCreateCompanionBuilder =
    CachedFormsCompanion Function({
      required String id,
      required String title,
      required String slug,
      required String rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$CachedFormsTableUpdateCompanionBuilder =
    CachedFormsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> slug,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedFormsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedFormsTable> {
  $$CachedFormsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedFormsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedFormsTable> {
  $$CachedFormsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFormsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedFormsTable> {
  $$CachedFormsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedFormsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedFormsTable,
          CachedForm,
          $$CachedFormsTableFilterComposer,
          $$CachedFormsTableOrderingComposer,
          $$CachedFormsTableAnnotationComposer,
          $$CachedFormsTableCreateCompanionBuilder,
          $$CachedFormsTableUpdateCompanionBuilder,
          (
            CachedForm,
            BaseReferences<_$LocalDatabase, $CachedFormsTable, CachedForm>,
          ),
          CachedForm,
          PrefetchHooks Function()
        > {
  $$CachedFormsTableTableManager(_$LocalDatabase db, $CachedFormsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFormsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFormsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFormsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFormsCompanion(
                id: id,
                title: title,
                slug: slug,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String slug,
                required String rawJson,
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFormsCompanion.insert(
                id: id,
                title: title,
                slug: slug,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedFormsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedFormsTable,
      CachedForm,
      $$CachedFormsTableFilterComposer,
      $$CachedFormsTableOrderingComposer,
      $$CachedFormsTableAnnotationComposer,
      $$CachedFormsTableCreateCompanionBuilder,
      $$CachedFormsTableUpdateCompanionBuilder,
      (
        CachedForm,
        BaseReferences<_$LocalDatabase, $CachedFormsTable, CachedForm>,
      ),
      CachedForm,
      PrefetchHooks Function()
    >;
typedef $$CachedResponsesTableCreateCompanionBuilder =
    CachedResponsesCompanion Function({
      required String id,
      required String formId,
      required String dataJson,
      required String status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CachedResponsesTableUpdateCompanionBuilder =
    CachedResponsesCompanion Function({
      Value<String> id,
      Value<String> formId,
      Value<String> dataJson,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CachedResponsesTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedResponsesTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedResponsesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CachedResponsesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedResponsesTable,
          CachedResponse,
          $$CachedResponsesTableFilterComposer,
          $$CachedResponsesTableOrderingComposer,
          $$CachedResponsesTableAnnotationComposer,
          $$CachedResponsesTableCreateCompanionBuilder,
          $$CachedResponsesTableUpdateCompanionBuilder,
          (
            CachedResponse,
            BaseReferences<
              _$LocalDatabase,
              $CachedResponsesTable,
              CachedResponse
            >,
          ),
          CachedResponse,
          PrefetchHooks Function()
        > {
  $$CachedResponsesTableTableManager(
    _$LocalDatabase db,
    $CachedResponsesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedResponsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> formId = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedResponsesCompanion(
                id: id,
                formId: formId,
                dataJson: dataJson,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String formId,
                required String dataJson,
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedResponsesCompanion.insert(
                id: id,
                formId: formId,
                dataJson: dataJson,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedResponsesTable,
      CachedResponse,
      $$CachedResponsesTableFilterComposer,
      $$CachedResponsesTableOrderingComposer,
      $$CachedResponsesTableAnnotationComposer,
      $$CachedResponsesTableCreateCompanionBuilder,
      $$CachedResponsesTableUpdateCompanionBuilder,
      (
        CachedResponse,
        BaseReferences<_$LocalDatabase, $CachedResponsesTable, CachedResponse>,
      ),
      CachedResponse,
      PrefetchHooks Function()
    >;
typedef $$PendingUploadsTableCreateCompanionBuilder =
    PendingUploadsCompanion Function({
      required String id,
      required String formId,
      required String payloadJson,
      Value<DateTime> queuedAt,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$PendingUploadsTableUpdateCompanionBuilder =
    PendingUploadsCompanion Function({
      Value<String> id,
      Value<String> formId,
      Value<String> payloadJson,
      Value<DateTime> queuedAt,
      Value<int> retryCount,
      Value<int> rowid,
    });

class $$PendingUploadsTableFilterComposer
    extends Composer<_$LocalDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingUploadsTableOrderingComposer
    extends Composer<_$LocalDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingUploadsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$PendingUploadsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $PendingUploadsTable,
          PendingUpload,
          $$PendingUploadsTableFilterComposer,
          $$PendingUploadsTableOrderingComposer,
          $$PendingUploadsTableAnnotationComposer,
          $$PendingUploadsTableCreateCompanionBuilder,
          $$PendingUploadsTableUpdateCompanionBuilder,
          (
            PendingUpload,
            BaseReferences<
              _$LocalDatabase,
              $PendingUploadsTable,
              PendingUpload
            >,
          ),
          PendingUpload,
          PrefetchHooks Function()
        > {
  $$PendingUploadsTableTableManager(
    _$LocalDatabase db,
    $PendingUploadsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingUploadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingUploadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingUploadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> formId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingUploadsCompanion(
                id: id,
                formId: formId,
                payloadJson: payloadJson,
                queuedAt: queuedAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String formId,
                required String payloadJson,
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingUploadsCompanion.insert(
                id: id,
                formId: formId,
                payloadJson: payloadJson,
                queuedAt: queuedAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingUploadsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $PendingUploadsTable,
      PendingUpload,
      $$PendingUploadsTableFilterComposer,
      $$PendingUploadsTableOrderingComposer,
      $$PendingUploadsTableAnnotationComposer,
      $$PendingUploadsTableCreateCompanionBuilder,
      $$PendingUploadsTableUpdateCompanionBuilder,
      (
        PendingUpload,
        BaseReferences<_$LocalDatabase, $PendingUploadsTable, PendingUpload>,
      ),
      PendingUpload,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$CachedFormsTableTableManager get cachedForms =>
      $$CachedFormsTableTableManager(_db, _db.cachedForms);
  $$CachedResponsesTableTableManager get cachedResponses =>
      $$CachedResponsesTableTableManager(_db, _db.cachedResponses);
  $$PendingUploadsTableTableManager get pendingUploads =>
      $$PendingUploadsTableTableManager(_db, _db.pendingUploads);
}
