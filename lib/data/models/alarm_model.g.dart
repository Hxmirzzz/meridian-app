// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlarmModelCollection on Isar {
  IsarCollection<AlarmModel> get alarmModels => this.collection();
}

const AlarmModelSchema = CollectionSchema(
  name: r'AlarmModel',
  id: 1796575337475990193,
  properties: {
    r'activeDays': PropertySchema(
      id: 0,
      name: r'activeDays',
      type: IsarType.boolList,
    ),
    r'alarmHour': PropertySchema(
      id: 1,
      name: r'alarmHour',
      type: IsarType.long,
    ),
    r'alarmMinute': PropertySchema(
      id: 2,
      name: r'alarmMinute',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'excludeHolidays': PropertySchema(
      id: 4,
      name: r'excludeHolidays',
      type: IsarType.bool,
    ),
    r'isActive': PropertySchema(id: 5, name: r'isActive', type: IsarType.bool),
    r'isInsideRadius': PropertySchema(
      id: 6,
      name: r'isInsideRadius',
      type: IsarType.bool,
    ),
    r'lastTriggered': PropertySchema(
      id: 7,
      name: r'lastTriggered',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 8,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 9,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'name': PropertySchema(id: 10, name: r'name', type: IsarType.string),
    r'radiusMeters': PropertySchema(
      id: 11,
      name: r'radiusMeters',
      type: IsarType.long,
    ),
  },

  estimateSize: _alarmModelEstimateSize,
  serialize: _alarmModelSerialize,
  deserialize: _alarmModelDeserialize,
  deserializeProp: _alarmModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _alarmModelGetId,
  getLinks: _alarmModelGetLinks,
  attach: _alarmModelAttach,
  version: '3.3.2',
);

int _alarmModelEstimateSize(
  AlarmModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activeDays.length;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _alarmModelSerialize(
  AlarmModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBoolList(offsets[0], object.activeDays);
  writer.writeLong(offsets[1], object.alarmHour);
  writer.writeLong(offsets[2], object.alarmMinute);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.excludeHolidays);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeBool(offsets[6], object.isInsideRadius);
  writer.writeDateTime(offsets[7], object.lastTriggered);
  writer.writeDouble(offsets[8], object.latitude);
  writer.writeDouble(offsets[9], object.longitude);
  writer.writeString(offsets[10], object.name);
  writer.writeLong(offsets[11], object.radiusMeters);
}

AlarmModel _alarmModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlarmModel();
  object.activeDays = reader.readBoolList(offsets[0]) ?? [];
  object.alarmHour = reader.readLong(offsets[1]);
  object.alarmMinute = reader.readLong(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.excludeHolidays = reader.readBool(offsets[4]);
  object.id = id;
  object.isActive = reader.readBool(offsets[5]);
  object.isInsideRadius = reader.readBool(offsets[6]);
  object.lastTriggered = reader.readDateTimeOrNull(offsets[7]);
  object.latitude = reader.readDouble(offsets[8]);
  object.longitude = reader.readDouble(offsets[9]);
  object.name = reader.readString(offsets[10]);
  object.radiusMeters = reader.readLong(offsets[11]);
  return object;
}

P _alarmModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _alarmModelGetId(AlarmModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _alarmModelGetLinks(AlarmModel object) {
  return [];
}

void _alarmModelAttach(IsarCollection<dynamic> col, Id id, AlarmModel object) {
  object.id = id;
}

extension AlarmModelQueryWhereSort
    on QueryBuilder<AlarmModel, AlarmModel, QWhere> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmModelQueryWhere
    on QueryBuilder<AlarmModel, AlarmModel, QWhereClause> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> nameEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> nameNotEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AlarmModelQueryFilter
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'activeDays', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeDays', length, true, length, true);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeDays', 0, true, 0, true);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeDays', 0, false, 999999, true);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeDays', 0, true, length, include);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeDays', length, include, 999999, true);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  activeDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmHourEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alarmHour', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  alarmHourGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'alarmHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'alarmHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'alarmHour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  alarmMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alarmMinute', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  alarmMinuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'alarmMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  alarmMinuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'alarmMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  alarmMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'alarmMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  excludeHolidaysEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'excludeHolidays', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  isInsideRadiusEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isInsideRadius', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastTriggered'),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastTriggered'),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastTriggered', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastTriggered',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastTriggered',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  lastTriggeredBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastTriggered',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  radiusMetersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'radiusMeters', value: value),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  radiusMetersGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'radiusMeters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  radiusMetersLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'radiusMeters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
  radiusMetersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'radiusMeters',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AlarmModelQueryObject
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {}

extension AlarmModelQueryLinks
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {}

extension AlarmModelQuerySortBy
    on QueryBuilder<AlarmModel, AlarmModel, QSortBy> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmHour', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmHour', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmMinute', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmMinute', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByExcludeHolidays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeHolidays', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
  sortByExcludeHolidaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeHolidays', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsInsideRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInsideRadius', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
  sortByIsInsideRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInsideRadius', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLastTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTriggered', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLastTriggeredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTriggered', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRadiusMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.desc);
    });
  }
}

extension AlarmModelQuerySortThenBy
    on QueryBuilder<AlarmModel, AlarmModel, QSortThenBy> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmHour', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmHour', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmMinute', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmMinute', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByExcludeHolidays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeHolidays', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
  thenByExcludeHolidaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeHolidays', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsInsideRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInsideRadius', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
  thenByIsInsideRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInsideRadius', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLastTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTriggered', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLastTriggeredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTriggered', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRadiusMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.desc);
    });
  }
}

extension AlarmModelQueryWhereDistinct
    on QueryBuilder<AlarmModel, AlarmModel, QDistinct> {
  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeDays');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByAlarmHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmHour');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByAlarmMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmMinute');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByExcludeHolidays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'excludeHolidays');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsInsideRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInsideRadius');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLastTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTriggered');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radiusMeters');
    });
  }
}

extension AlarmModelQueryProperty
    on QueryBuilder<AlarmModel, AlarmModel, QQueryProperty> {
  QueryBuilder<AlarmModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AlarmModel, List<bool>, QQueryOperations> activeDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeDays');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> alarmHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmHour');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> alarmMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmMinute');
    });
  }

  QueryBuilder<AlarmModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> excludeHolidaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'excludeHolidays');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isInsideRadiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInsideRadius');
    });
  }

  QueryBuilder<AlarmModel, DateTime?, QQueryOperations>
  lastTriggeredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTriggered');
    });
  }

  QueryBuilder<AlarmModel, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<AlarmModel, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> radiusMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radiusMeters');
    });
  }
}
