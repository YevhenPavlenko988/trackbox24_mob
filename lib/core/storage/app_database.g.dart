// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScanQueueItemsTable extends ScanQueueItems
    with TableInfo<$ScanQueueItemsTable, ScanQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualInputMeta = const VerificationMeta(
    'manualInput',
  );
  @override
  late final GeneratedColumn<bool> manualInput = GeneratedColumn<bool>(
    'manual_input',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("manual_input" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warehouseIdMeta = const VerificationMeta(
    'warehouseId',
  );
  @override
  late final GeneratedColumn<int> warehouseId = GeneratedColumn<int>(
    'warehouse_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentReceivedMeta = const VerificationMeta(
    'paymentReceived',
  );
  @override
  late final GeneratedColumn<bool> paymentReceived = GeneratedColumn<bool>(
    'payment_received',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("payment_received" IN (0, 1))',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueueStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<QueueStatus>($ScanQueueItemsTable.$converterstatus);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastStatusCodeMeta = const VerificationMeta(
    'lastStatusCode',
  );
  @override
  late final GeneratedColumn<int> lastStatusCode = GeneratedColumn<int>(
    'last_status_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverResponseMeta = const VerificationMeta(
    'serverResponse',
  );
  @override
  late final GeneratedColumn<String> serverResponse = GeneratedColumn<String>(
    'server_response',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    code,
    manualInput,
    comment,
    tripId,
    warehouseId,
    paymentReceived,
    createdAt,
    attempts,
    status,
    lastError,
    lastStatusCode,
    serverResponse,
    sentAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('manual_input')) {
      context.handle(
        _manualInputMeta,
        manualInput.isAcceptableOrUnknown(
          data['manual_input']!,
          _manualInputMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
        _warehouseIdMeta,
        warehouseId.isAcceptableOrUnknown(
          data['warehouse_id']!,
          _warehouseIdMeta,
        ),
      );
    }
    if (data.containsKey('payment_received')) {
      context.handle(
        _paymentReceivedMeta,
        paymentReceived.isAcceptableOrUnknown(
          data['payment_received']!,
          _paymentReceivedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_status_code')) {
      context.handle(
        _lastStatusCodeMeta,
        lastStatusCode.isAcceptableOrUnknown(
          data['last_status_code']!,
          _lastStatusCodeMeta,
        ),
      );
    }
    if (data.containsKey('server_response')) {
      context.handle(
        _serverResponseMeta,
        serverResponse.isAcceptableOrUnknown(
          data['server_response']!,
          _serverResponseMeta,
        ),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      manualInput: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}manual_input'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      ),
      warehouseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warehouse_id'],
      ),
      paymentReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}payment_received'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      status: $ScanQueueItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastStatusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_status_code'],
      ),
      serverResponse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_response'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
    );
  }

  @override
  $ScanQueueItemsTable createAlias(String alias) {
    return $ScanQueueItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QueueStatus, String, String> $converterstatus =
      const EnumNameConverter<QueueStatus>(QueueStatus.values);
}

class ScanQueueItem extends DataClass implements Insertable<ScanQueueItem> {
  final int id;

  /// `receive` | `load` | `deliver` | `toWarehouse` — the [ScanMode] name.
  final String type;
  final String code;
  final bool manualInput;
  final String? comment;
  final int? tripId;
  final int? warehouseId;
  final bool? paymentReceived;
  final DateTime createdAt;
  final int attempts;
  final QueueStatus status;
  final String? lastError;
  final int? lastStatusCode;

  /// Backend `ParcelResponse` JSON after a successful replay.
  final String? serverResponse;
  final DateTime? sentAt;
  const ScanQueueItem({
    required this.id,
    required this.type,
    required this.code,
    required this.manualInput,
    this.comment,
    this.tripId,
    this.warehouseId,
    this.paymentReceived,
    required this.createdAt,
    required this.attempts,
    required this.status,
    this.lastError,
    this.lastStatusCode,
    this.serverResponse,
    this.sentAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['code'] = Variable<String>(code);
    map['manual_input'] = Variable<bool>(manualInput);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<int>(tripId);
    }
    if (!nullToAbsent || warehouseId != null) {
      map['warehouse_id'] = Variable<int>(warehouseId);
    }
    if (!nullToAbsent || paymentReceived != null) {
      map['payment_received'] = Variable<bool>(paymentReceived);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    {
      map['status'] = Variable<String>(
        $ScanQueueItemsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastStatusCode != null) {
      map['last_status_code'] = Variable<int>(lastStatusCode);
    }
    if (!nullToAbsent || serverResponse != null) {
      map['server_response'] = Variable<String>(serverResponse);
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    return map;
  }

  ScanQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return ScanQueueItemsCompanion(
      id: Value(id),
      type: Value(type),
      code: Value(code),
      manualInput: Value(manualInput),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      tripId: tripId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripId),
      warehouseId: warehouseId == null && nullToAbsent
          ? const Value.absent()
          : Value(warehouseId),
      paymentReceived: paymentReceived == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentReceived),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastStatusCode: lastStatusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStatusCode),
      serverResponse: serverResponse == null && nullToAbsent
          ? const Value.absent()
          : Value(serverResponse),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
    );
  }

  factory ScanQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanQueueItem(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      code: serializer.fromJson<String>(json['code']),
      manualInput: serializer.fromJson<bool>(json['manualInput']),
      comment: serializer.fromJson<String?>(json['comment']),
      tripId: serializer.fromJson<int?>(json['tripId']),
      warehouseId: serializer.fromJson<int?>(json['warehouseId']),
      paymentReceived: serializer.fromJson<bool?>(json['paymentReceived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      status: $ScanQueueItemsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastStatusCode: serializer.fromJson<int?>(json['lastStatusCode']),
      serverResponse: serializer.fromJson<String?>(json['serverResponse']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'code': serializer.toJson<String>(code),
      'manualInput': serializer.toJson<bool>(manualInput),
      'comment': serializer.toJson<String?>(comment),
      'tripId': serializer.toJson<int?>(tripId),
      'warehouseId': serializer.toJson<int?>(warehouseId),
      'paymentReceived': serializer.toJson<bool?>(paymentReceived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'status': serializer.toJson<String>(
        $ScanQueueItemsTable.$converterstatus.toJson(status),
      ),
      'lastError': serializer.toJson<String?>(lastError),
      'lastStatusCode': serializer.toJson<int?>(lastStatusCode),
      'serverResponse': serializer.toJson<String?>(serverResponse),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
    };
  }

  ScanQueueItem copyWith({
    int? id,
    String? type,
    String? code,
    bool? manualInput,
    Value<String?> comment = const Value.absent(),
    Value<int?> tripId = const Value.absent(),
    Value<int?> warehouseId = const Value.absent(),
    Value<bool?> paymentReceived = const Value.absent(),
    DateTime? createdAt,
    int? attempts,
    QueueStatus? status,
    Value<String?> lastError = const Value.absent(),
    Value<int?> lastStatusCode = const Value.absent(),
    Value<String?> serverResponse = const Value.absent(),
    Value<DateTime?> sentAt = const Value.absent(),
  }) => ScanQueueItem(
    id: id ?? this.id,
    type: type ?? this.type,
    code: code ?? this.code,
    manualInput: manualInput ?? this.manualInput,
    comment: comment.present ? comment.value : this.comment,
    tripId: tripId.present ? tripId.value : this.tripId,
    warehouseId: warehouseId.present ? warehouseId.value : this.warehouseId,
    paymentReceived: paymentReceived.present
        ? paymentReceived.value
        : this.paymentReceived,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastStatusCode: lastStatusCode.present
        ? lastStatusCode.value
        : this.lastStatusCode,
    serverResponse: serverResponse.present
        ? serverResponse.value
        : this.serverResponse,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
  );
  ScanQueueItem copyWithCompanion(ScanQueueItemsCompanion data) {
    return ScanQueueItem(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      code: data.code.present ? data.code.value : this.code,
      manualInput: data.manualInput.present
          ? data.manualInput.value
          : this.manualInput,
      comment: data.comment.present ? data.comment.value : this.comment,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      warehouseId: data.warehouseId.present
          ? data.warehouseId.value
          : this.warehouseId,
      paymentReceived: data.paymentReceived.present
          ? data.paymentReceived.value
          : this.paymentReceived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastStatusCode: data.lastStatusCode.present
          ? data.lastStatusCode.value
          : this.lastStatusCode,
      serverResponse: data.serverResponse.present
          ? data.serverResponse.value
          : this.serverResponse,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanQueueItem(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('manualInput: $manualInput, ')
          ..write('comment: $comment, ')
          ..write('tripId: $tripId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('paymentReceived: $paymentReceived, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('lastStatusCode: $lastStatusCode, ')
          ..write('serverResponse: $serverResponse, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    code,
    manualInput,
    comment,
    tripId,
    warehouseId,
    paymentReceived,
    createdAt,
    attempts,
    status,
    lastError,
    lastStatusCode,
    serverResponse,
    sentAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanQueueItem &&
          other.id == this.id &&
          other.type == this.type &&
          other.code == this.code &&
          other.manualInput == this.manualInput &&
          other.comment == this.comment &&
          other.tripId == this.tripId &&
          other.warehouseId == this.warehouseId &&
          other.paymentReceived == this.paymentReceived &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.lastStatusCode == this.lastStatusCode &&
          other.serverResponse == this.serverResponse &&
          other.sentAt == this.sentAt);
}

class ScanQueueItemsCompanion extends UpdateCompanion<ScanQueueItem> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> code;
  final Value<bool> manualInput;
  final Value<String?> comment;
  final Value<int?> tripId;
  final Value<int?> warehouseId;
  final Value<bool?> paymentReceived;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<QueueStatus> status;
  final Value<String?> lastError;
  final Value<int?> lastStatusCode;
  final Value<String?> serverResponse;
  final Value<DateTime?> sentAt;
  const ScanQueueItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.code = const Value.absent(),
    this.manualInput = const Value.absent(),
    this.comment = const Value.absent(),
    this.tripId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.paymentReceived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastStatusCode = const Value.absent(),
    this.serverResponse = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  ScanQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String code,
    this.manualInput = const Value.absent(),
    this.comment = const Value.absent(),
    this.tripId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.paymentReceived = const Value.absent(),
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastStatusCode = const Value.absent(),
    this.serverResponse = const Value.absent(),
    this.sentAt = const Value.absent(),
  }) : type = Value(type),
       code = Value(code),
       createdAt = Value(createdAt);
  static Insertable<ScanQueueItem> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? code,
    Expression<bool>? manualInput,
    Expression<String>? comment,
    Expression<int>? tripId,
    Expression<int>? warehouseId,
    Expression<bool>? paymentReceived,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<int>? lastStatusCode,
    Expression<String>? serverResponse,
    Expression<DateTime>? sentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (code != null) 'code': code,
      if (manualInput != null) 'manual_input': manualInput,
      if (comment != null) 'comment': comment,
      if (tripId != null) 'trip_id': tripId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (paymentReceived != null) 'payment_received': paymentReceived,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (lastStatusCode != null) 'last_status_code': lastStatusCode,
      if (serverResponse != null) 'server_response': serverResponse,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  ScanQueueItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? code,
    Value<bool>? manualInput,
    Value<String?>? comment,
    Value<int?>? tripId,
    Value<int?>? warehouseId,
    Value<bool?>? paymentReceived,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<QueueStatus>? status,
    Value<String?>? lastError,
    Value<int?>? lastStatusCode,
    Value<String?>? serverResponse,
    Value<DateTime?>? sentAt,
  }) {
    return ScanQueueItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      manualInput: manualInput ?? this.manualInput,
      comment: comment ?? this.comment,
      tripId: tripId ?? this.tripId,
      warehouseId: warehouseId ?? this.warehouseId,
      paymentReceived: paymentReceived ?? this.paymentReceived,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      lastStatusCode: lastStatusCode ?? this.lastStatusCode,
      serverResponse: serverResponse ?? this.serverResponse,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (manualInput.present) {
      map['manual_input'] = Variable<bool>(manualInput.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<int>(warehouseId.value);
    }
    if (paymentReceived.present) {
      map['payment_received'] = Variable<bool>(paymentReceived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ScanQueueItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastStatusCode.present) {
      map['last_status_code'] = Variable<int>(lastStatusCode.value);
    }
    if (serverResponse.present) {
      map['server_response'] = Variable<String>(serverResponse.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('manualInput: $manualInput, ')
          ..write('comment: $comment, ')
          ..write('tripId: $tripId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('paymentReceived: $paymentReceived, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('lastStatusCode: $lastStatusCode, ')
          ..write('serverResponse: $serverResponse, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScanQueueItemsTable scanQueueItems = $ScanQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [scanQueueItems];
}

typedef $$ScanQueueItemsTableCreateCompanionBuilder =
    ScanQueueItemsCompanion Function({
      Value<int> id,
      required String type,
      required String code,
      Value<bool> manualInput,
      Value<String?> comment,
      Value<int?> tripId,
      Value<int?> warehouseId,
      Value<bool?> paymentReceived,
      required DateTime createdAt,
      Value<int> attempts,
      Value<QueueStatus> status,
      Value<String?> lastError,
      Value<int?> lastStatusCode,
      Value<String?> serverResponse,
      Value<DateTime?> sentAt,
    });
typedef $$ScanQueueItemsTableUpdateCompanionBuilder =
    ScanQueueItemsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> code,
      Value<bool> manualInput,
      Value<String?> comment,
      Value<int?> tripId,
      Value<int?> warehouseId,
      Value<bool?> paymentReceived,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<QueueStatus> status,
      Value<String?> lastError,
      Value<int?> lastStatusCode,
      Value<String?> serverResponse,
      Value<DateTime?> sentAt,
    });

class $$ScanQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ScanQueueItemsTable> {
  $$ScanQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get manualInput => $composableBuilder(
    column: $table.manualInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueueStatus, QueueStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastStatusCode => $composableBuilder(
    column: $table.lastStatusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScanQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanQueueItemsTable> {
  $$ScanQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get manualInput => $composableBuilder(
    column: $table.manualInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastStatusCode => $composableBuilder(
    column: $table.lastStatusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanQueueItemsTable> {
  $$ScanQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<bool> get manualInput => $composableBuilder(
    column: $table.manualInput,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueueStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get lastStatusCode => $composableBuilder(
    column: $table.lastStatusCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$ScanQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanQueueItemsTable,
          ScanQueueItem,
          $$ScanQueueItemsTableFilterComposer,
          $$ScanQueueItemsTableOrderingComposer,
          $$ScanQueueItemsTableAnnotationComposer,
          $$ScanQueueItemsTableCreateCompanionBuilder,
          $$ScanQueueItemsTableUpdateCompanionBuilder,
          (
            ScanQueueItem,
            BaseReferences<_$AppDatabase, $ScanQueueItemsTable, ScanQueueItem>,
          ),
          ScanQueueItem,
          PrefetchHooks Function()
        > {
  $$ScanQueueItemsTableTableManager(
    _$AppDatabase db,
    $ScanQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<bool> manualInput = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> tripId = const Value.absent(),
                Value<int?> warehouseId = const Value.absent(),
                Value<bool?> paymentReceived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<QueueStatus> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int?> lastStatusCode = const Value.absent(),
                Value<String?> serverResponse = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
              }) => ScanQueueItemsCompanion(
                id: id,
                type: type,
                code: code,
                manualInput: manualInput,
                comment: comment,
                tripId: tripId,
                warehouseId: warehouseId,
                paymentReceived: paymentReceived,
                createdAt: createdAt,
                attempts: attempts,
                status: status,
                lastError: lastError,
                lastStatusCode: lastStatusCode,
                serverResponse: serverResponse,
                sentAt: sentAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String code,
                Value<bool> manualInput = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> tripId = const Value.absent(),
                Value<int?> warehouseId = const Value.absent(),
                Value<bool?> paymentReceived = const Value.absent(),
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<QueueStatus> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int?> lastStatusCode = const Value.absent(),
                Value<String?> serverResponse = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
              }) => ScanQueueItemsCompanion.insert(
                id: id,
                type: type,
                code: code,
                manualInput: manualInput,
                comment: comment,
                tripId: tripId,
                warehouseId: warehouseId,
                paymentReceived: paymentReceived,
                createdAt: createdAt,
                attempts: attempts,
                status: status,
                lastError: lastError,
                lastStatusCode: lastStatusCode,
                serverResponse: serverResponse,
                sentAt: sentAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanQueueItemsTable, ScanQueueItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ScanQueueItemsTable,
                    ScanQueueItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanQueueItemsTable,
      ScanQueueItem,
      $$ScanQueueItemsTableFilterComposer,
      $$ScanQueueItemsTableOrderingComposer,
      $$ScanQueueItemsTableAnnotationComposer,
      $$ScanQueueItemsTableCreateCompanionBuilder,
      $$ScanQueueItemsTableUpdateCompanionBuilder,
      (
        ScanQueueItem,
        BaseReferences<_$AppDatabase, $ScanQueueItemsTable, ScanQueueItem>,
      ),
      ScanQueueItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScanQueueItemsTableTableManager get scanQueueItems =>
      $$ScanQueueItemsTableTableManager(_db, _db.scanQueueItems);
}
