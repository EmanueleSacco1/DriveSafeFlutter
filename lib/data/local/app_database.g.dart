// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CarsTable extends Cars with TableInfo<$CarsTable, Car> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rcaPaidDateMeta =
      const VerificationMeta('rcaPaidDate');
  @override
  late final GeneratedColumn<int> rcaPaidDate = GeneratedColumn<int>(
      'rca_paid_date', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nextRevisionDateMeta =
      const VerificationMeta('nextRevisionDate');
  @override
  late final GeneratedColumn<int> nextRevisionDate = GeneratedColumn<int>(
      'next_revision_date', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _revisionOdometerMeta =
      const VerificationMeta('revisionOdometer');
  @override
  late final GeneratedColumn<int> revisionOdometer = GeneratedColumn<int>(
      'revision_odometer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _registrationDateMeta =
      const VerificationMeta('registrationDate');
  @override
  late final GeneratedColumn<int> registrationDate = GeneratedColumn<int>(
      'registration_date', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bolloCostMeta =
      const VerificationMeta('bolloCost');
  @override
  late final GeneratedColumn<double> bolloCost = GeneratedColumn<double>(
      'bollo_cost', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bolloExpirationDateMeta =
      const VerificationMeta('bolloExpirationDate');
  @override
  late final GeneratedColumn<int> bolloExpirationDate = GeneratedColumn<int>(
      'bollo_expiration_date', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        brand,
        model,
        year,
        rcaPaidDate,
        nextRevisionDate,
        revisionOdometer,
        registrationDate,
        bolloCost,
        bolloExpirationDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars';
  @override
  VerificationContext validateIntegrity(Insertable<Car> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('rca_paid_date')) {
      context.handle(
          _rcaPaidDateMeta,
          rcaPaidDate.isAcceptableOrUnknown(
              data['rca_paid_date']!, _rcaPaidDateMeta));
    }
    if (data.containsKey('next_revision_date')) {
      context.handle(
          _nextRevisionDateMeta,
          nextRevisionDate.isAcceptableOrUnknown(
              data['next_revision_date']!, _nextRevisionDateMeta));
    }
    if (data.containsKey('revision_odometer')) {
      context.handle(
          _revisionOdometerMeta,
          revisionOdometer.isAcceptableOrUnknown(
              data['revision_odometer']!, _revisionOdometerMeta));
    }
    if (data.containsKey('registration_date')) {
      context.handle(
          _registrationDateMeta,
          registrationDate.isAcceptableOrUnknown(
              data['registration_date']!, _registrationDateMeta));
    }
    if (data.containsKey('bollo_cost')) {
      context.handle(_bolloCostMeta,
          bolloCost.isAcceptableOrUnknown(data['bollo_cost']!, _bolloCostMeta));
    }
    if (data.containsKey('bollo_expiration_date')) {
      context.handle(
          _bolloExpirationDateMeta,
          bolloExpirationDate.isAcceptableOrUnknown(
              data['bollo_expiration_date']!, _bolloExpirationDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Car map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Car(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      rcaPaidDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rca_paid_date']),
      nextRevisionDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_revision_date']),
      revisionOdometer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision_odometer']),
      registrationDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}registration_date']),
      bolloCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bollo_cost']),
      bolloExpirationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bollo_expiration_date']),
    );
  }

  @override
  $CarsTable createAlias(String alias) {
    return $CarsTable(attachedDatabase, alias);
  }
}

class Car extends DataClass implements Insertable<Car> {
  final int id;
  final String brand;
  final String model;
  final int year;
  final int? rcaPaidDate;
  final int? nextRevisionDate;
  final int? revisionOdometer;
  final int? registrationDate;
  final double? bolloCost;
  final int? bolloExpirationDate;
  const Car(
      {required this.id,
      required this.brand,
      required this.model,
      required this.year,
      this.rcaPaidDate,
      this.nextRevisionDate,
      this.revisionOdometer,
      this.registrationDate,
      this.bolloCost,
      this.bolloExpirationDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || rcaPaidDate != null) {
      map['rca_paid_date'] = Variable<int>(rcaPaidDate);
    }
    if (!nullToAbsent || nextRevisionDate != null) {
      map['next_revision_date'] = Variable<int>(nextRevisionDate);
    }
    if (!nullToAbsent || revisionOdometer != null) {
      map['revision_odometer'] = Variable<int>(revisionOdometer);
    }
    if (!nullToAbsent || registrationDate != null) {
      map['registration_date'] = Variable<int>(registrationDate);
    }
    if (!nullToAbsent || bolloCost != null) {
      map['bollo_cost'] = Variable<double>(bolloCost);
    }
    if (!nullToAbsent || bolloExpirationDate != null) {
      map['bollo_expiration_date'] = Variable<int>(bolloExpirationDate);
    }
    return map;
  }

  CarsCompanion toCompanion(bool nullToAbsent) {
    return CarsCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      year: Value(year),
      rcaPaidDate: rcaPaidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(rcaPaidDate),
      nextRevisionDate: nextRevisionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRevisionDate),
      revisionOdometer: revisionOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionOdometer),
      registrationDate: registrationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationDate),
      bolloCost: bolloCost == null && nullToAbsent
          ? const Value.absent()
          : Value(bolloCost),
      bolloExpirationDate: bolloExpirationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(bolloExpirationDate),
    );
  }

  factory Car.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Car(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int>(json['year']),
      rcaPaidDate: serializer.fromJson<int?>(json['rcaPaidDate']),
      nextRevisionDate: serializer.fromJson<int?>(json['nextRevisionDate']),
      revisionOdometer: serializer.fromJson<int?>(json['revisionOdometer']),
      registrationDate: serializer.fromJson<int?>(json['registrationDate']),
      bolloCost: serializer.fromJson<double?>(json['bolloCost']),
      bolloExpirationDate:
          serializer.fromJson<int?>(json['bolloExpirationDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int>(year),
      'rcaPaidDate': serializer.toJson<int?>(rcaPaidDate),
      'nextRevisionDate': serializer.toJson<int?>(nextRevisionDate),
      'revisionOdometer': serializer.toJson<int?>(revisionOdometer),
      'registrationDate': serializer.toJson<int?>(registrationDate),
      'bolloCost': serializer.toJson<double?>(bolloCost),
      'bolloExpirationDate': serializer.toJson<int?>(bolloExpirationDate),
    };
  }

  Car copyWith(
          {int? id,
          String? brand,
          String? model,
          int? year,
          Value<int?> rcaPaidDate = const Value.absent(),
          Value<int?> nextRevisionDate = const Value.absent(),
          Value<int?> revisionOdometer = const Value.absent(),
          Value<int?> registrationDate = const Value.absent(),
          Value<double?> bolloCost = const Value.absent(),
          Value<int?> bolloExpirationDate = const Value.absent()}) =>
      Car(
        id: id ?? this.id,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        year: year ?? this.year,
        rcaPaidDate: rcaPaidDate.present ? rcaPaidDate.value : this.rcaPaidDate,
        nextRevisionDate: nextRevisionDate.present
            ? nextRevisionDate.value
            : this.nextRevisionDate,
        revisionOdometer: revisionOdometer.present
            ? revisionOdometer.value
            : this.revisionOdometer,
        registrationDate: registrationDate.present
            ? registrationDate.value
            : this.registrationDate,
        bolloCost: bolloCost.present ? bolloCost.value : this.bolloCost,
        bolloExpirationDate: bolloExpirationDate.present
            ? bolloExpirationDate.value
            : this.bolloExpirationDate,
      );
  Car copyWithCompanion(CarsCompanion data) {
    return Car(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      rcaPaidDate:
          data.rcaPaidDate.present ? data.rcaPaidDate.value : this.rcaPaidDate,
      nextRevisionDate: data.nextRevisionDate.present
          ? data.nextRevisionDate.value
          : this.nextRevisionDate,
      revisionOdometer: data.revisionOdometer.present
          ? data.revisionOdometer.value
          : this.revisionOdometer,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      bolloCost: data.bolloCost.present ? data.bolloCost.value : this.bolloCost,
      bolloExpirationDate: data.bolloExpirationDate.present
          ? data.bolloExpirationDate.value
          : this.bolloExpirationDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Car(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('rcaPaidDate: $rcaPaidDate, ')
          ..write('nextRevisionDate: $nextRevisionDate, ')
          ..write('revisionOdometer: $revisionOdometer, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('bolloCost: $bolloCost, ')
          ..write('bolloExpirationDate: $bolloExpirationDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      brand,
      model,
      year,
      rcaPaidDate,
      nextRevisionDate,
      revisionOdometer,
      registrationDate,
      bolloCost,
      bolloExpirationDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Car &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.rcaPaidDate == this.rcaPaidDate &&
          other.nextRevisionDate == this.nextRevisionDate &&
          other.revisionOdometer == this.revisionOdometer &&
          other.registrationDate == this.registrationDate &&
          other.bolloCost == this.bolloCost &&
          other.bolloExpirationDate == this.bolloExpirationDate);
}

class CarsCompanion extends UpdateCompanion<Car> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> year;
  final Value<int?> rcaPaidDate;
  final Value<int?> nextRevisionDate;
  final Value<int?> revisionOdometer;
  final Value<int?> registrationDate;
  final Value<double?> bolloCost;
  final Value<int?> bolloExpirationDate;
  const CarsCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.rcaPaidDate = const Value.absent(),
    this.nextRevisionDate = const Value.absent(),
    this.revisionOdometer = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.bolloCost = const Value.absent(),
    this.bolloExpirationDate = const Value.absent(),
  });
  CarsCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    required int year,
    this.rcaPaidDate = const Value.absent(),
    this.nextRevisionDate = const Value.absent(),
    this.revisionOdometer = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.bolloCost = const Value.absent(),
    this.bolloExpirationDate = const Value.absent(),
  })  : brand = Value(brand),
        model = Value(model),
        year = Value(year);
  static Insertable<Car> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<int>? rcaPaidDate,
    Expression<int>? nextRevisionDate,
    Expression<int>? revisionOdometer,
    Expression<int>? registrationDate,
    Expression<double>? bolloCost,
    Expression<int>? bolloExpirationDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (rcaPaidDate != null) 'rca_paid_date': rcaPaidDate,
      if (nextRevisionDate != null) 'next_revision_date': nextRevisionDate,
      if (revisionOdometer != null) 'revision_odometer': revisionOdometer,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (bolloCost != null) 'bollo_cost': bolloCost,
      if (bolloExpirationDate != null)
        'bollo_expiration_date': bolloExpirationDate,
    });
  }

  CarsCompanion copyWith(
      {Value<int>? id,
      Value<String>? brand,
      Value<String>? model,
      Value<int>? year,
      Value<int?>? rcaPaidDate,
      Value<int?>? nextRevisionDate,
      Value<int?>? revisionOdometer,
      Value<int?>? registrationDate,
      Value<double?>? bolloCost,
      Value<int?>? bolloExpirationDate}) {
    return CarsCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      rcaPaidDate: rcaPaidDate ?? this.rcaPaidDate,
      nextRevisionDate: nextRevisionDate ?? this.nextRevisionDate,
      revisionOdometer: revisionOdometer ?? this.revisionOdometer,
      registrationDate: registrationDate ?? this.registrationDate,
      bolloCost: bolloCost ?? this.bolloCost,
      bolloExpirationDate: bolloExpirationDate ?? this.bolloExpirationDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (rcaPaidDate.present) {
      map['rca_paid_date'] = Variable<int>(rcaPaidDate.value);
    }
    if (nextRevisionDate.present) {
      map['next_revision_date'] = Variable<int>(nextRevisionDate.value);
    }
    if (revisionOdometer.present) {
      map['revision_odometer'] = Variable<int>(revisionOdometer.value);
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<int>(registrationDate.value);
    }
    if (bolloCost.present) {
      map['bollo_cost'] = Variable<double>(bolloCost.value);
    }
    if (bolloExpirationDate.present) {
      map['bollo_expiration_date'] = Variable<int>(bolloExpirationDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('rcaPaidDate: $rcaPaidDate, ')
          ..write('nextRevisionDate: $nextRevisionDate, ')
          ..write('revisionOdometer: $revisionOdometer, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('bolloCost: $bolloCost, ')
          ..write('bolloExpirationDate: $bolloExpirationDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CarsTable cars = $CarsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cars];
}

typedef $$CarsTableCreateCompanionBuilder = CarsCompanion Function({
  Value<int> id,
  required String brand,
  required String model,
  required int year,
  Value<int?> rcaPaidDate,
  Value<int?> nextRevisionDate,
  Value<int?> revisionOdometer,
  Value<int?> registrationDate,
  Value<double?> bolloCost,
  Value<int?> bolloExpirationDate,
});
typedef $$CarsTableUpdateCompanionBuilder = CarsCompanion Function({
  Value<int> id,
  Value<String> brand,
  Value<String> model,
  Value<int> year,
  Value<int?> rcaPaidDate,
  Value<int?> nextRevisionDate,
  Value<int?> revisionOdometer,
  Value<int?> registrationDate,
  Value<double?> bolloCost,
  Value<int?> bolloExpirationDate,
});

class $$CarsTableFilterComposer extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rcaPaidDate => $composableBuilder(
      column: $table.rcaPaidDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextRevisionDate => $composableBuilder(
      column: $table.nextRevisionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionOdometer => $composableBuilder(
      column: $table.revisionOdometer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get registrationDate => $composableBuilder(
      column: $table.registrationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bolloCost => $composableBuilder(
      column: $table.bolloCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bolloExpirationDate => $composableBuilder(
      column: $table.bolloExpirationDate,
      builder: (column) => ColumnFilters(column));
}

class $$CarsTableOrderingComposer extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rcaPaidDate => $composableBuilder(
      column: $table.rcaPaidDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextRevisionDate => $composableBuilder(
      column: $table.nextRevisionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionOdometer => $composableBuilder(
      column: $table.revisionOdometer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get registrationDate => $composableBuilder(
      column: $table.registrationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bolloCost => $composableBuilder(
      column: $table.bolloCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bolloExpirationDate => $composableBuilder(
      column: $table.bolloExpirationDate,
      builder: (column) => ColumnOrderings(column));
}

class $$CarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get rcaPaidDate => $composableBuilder(
      column: $table.rcaPaidDate, builder: (column) => column);

  GeneratedColumn<int> get nextRevisionDate => $composableBuilder(
      column: $table.nextRevisionDate, builder: (column) => column);

  GeneratedColumn<int> get revisionOdometer => $composableBuilder(
      column: $table.revisionOdometer, builder: (column) => column);

  GeneratedColumn<int> get registrationDate => $composableBuilder(
      column: $table.registrationDate, builder: (column) => column);

  GeneratedColumn<double> get bolloCost =>
      $composableBuilder(column: $table.bolloCost, builder: (column) => column);

  GeneratedColumn<int> get bolloExpirationDate => $composableBuilder(
      column: $table.bolloExpirationDate, builder: (column) => column);
}

class $$CarsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CarsTable,
    Car,
    $$CarsTableFilterComposer,
    $$CarsTableOrderingComposer,
    $$CarsTableAnnotationComposer,
    $$CarsTableCreateCompanionBuilder,
    $$CarsTableUpdateCompanionBuilder,
    (Car, BaseReferences<_$AppDatabase, $CarsTable, Car>),
    Car,
    PrefetchHooks Function()> {
  $$CarsTableTableManager(_$AppDatabase db, $CarsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int?> rcaPaidDate = const Value.absent(),
            Value<int?> nextRevisionDate = const Value.absent(),
            Value<int?> revisionOdometer = const Value.absent(),
            Value<int?> registrationDate = const Value.absent(),
            Value<double?> bolloCost = const Value.absent(),
            Value<int?> bolloExpirationDate = const Value.absent(),
          }) =>
              CarsCompanion(
            id: id,
            brand: brand,
            model: model,
            year: year,
            rcaPaidDate: rcaPaidDate,
            nextRevisionDate: nextRevisionDate,
            revisionOdometer: revisionOdometer,
            registrationDate: registrationDate,
            bolloCost: bolloCost,
            bolloExpirationDate: bolloExpirationDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String brand,
            required String model,
            required int year,
            Value<int?> rcaPaidDate = const Value.absent(),
            Value<int?> nextRevisionDate = const Value.absent(),
            Value<int?> revisionOdometer = const Value.absent(),
            Value<int?> registrationDate = const Value.absent(),
            Value<double?> bolloCost = const Value.absent(),
            Value<int?> bolloExpirationDate = const Value.absent(),
          }) =>
              CarsCompanion.insert(
            id: id,
            brand: brand,
            model: model,
            year: year,
            rcaPaidDate: rcaPaidDate,
            nextRevisionDate: nextRevisionDate,
            revisionOdometer: revisionOdometer,
            registrationDate: registrationDate,
            bolloCost: bolloCost,
            bolloExpirationDate: bolloExpirationDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CarsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CarsTable,
    Car,
    $$CarsTableFilterComposer,
    $$CarsTableOrderingComposer,
    $$CarsTableAnnotationComposer,
    $$CarsTableCreateCompanionBuilder,
    $$CarsTableUpdateCompanionBuilder,
    (Car, BaseReferences<_$AppDatabase, $CarsTable, Car>),
    Car,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CarsTableTableManager get cars => $$CarsTableTableManager(_db, _db.cars);
}

mixin _$CarDaoMixin on DatabaseAccessor<AppDatabase> {
  $CarsTable get cars => attachedDatabase.cars;
}
