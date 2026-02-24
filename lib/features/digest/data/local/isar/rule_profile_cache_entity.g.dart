// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_profile_cache_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRuleProfileCacheEntityCollection on Isar {
  IsarCollection<RuleProfileCacheEntity> get ruleProfileCacheEntitys =>
      this.collection();
}

const RuleProfileCacheEntitySchema = CollectionSchema(
  name: r'RuleProfileCacheEntity',
  id: 5842015853598540356,
  properties: {
    r'profileId': PropertySchema(
      id: 0,
      name: r'profileId',
      type: IsarType.string,
    ),
    r'profileJson': PropertySchema(
      id: 1,
      name: r'profileJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(id: 3, name: r'version', type: IsarType.long),
  },
  estimateSize: _ruleProfileCacheEntityEstimateSize,
  serialize: _ruleProfileCacheEntitySerialize,
  deserialize: _ruleProfileCacheEntityDeserialize,
  deserializeProp: _ruleProfileCacheEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'profileId': IndexSchema(
      id: 6052971939042612300,
      name: r'profileId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _ruleProfileCacheEntityGetId,
  getLinks: _ruleProfileCacheEntityGetLinks,
  attach: _ruleProfileCacheEntityAttach,
  version: '3.1.0+1',
);

int _ruleProfileCacheEntityEstimateSize(
  RuleProfileCacheEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.profileId.length * 3;
  bytesCount += 3 + object.profileJson.length * 3;
  return bytesCount;
}

void _ruleProfileCacheEntitySerialize(
  RuleProfileCacheEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.profileId);
  writer.writeString(offsets[1], object.profileJson);
  writer.writeDateTime(offsets[2], object.updatedAt);
  writer.writeLong(offsets[3], object.version);
}

RuleProfileCacheEntity _ruleProfileCacheEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RuleProfileCacheEntity();
  object.id = id;
  object.profileId = reader.readString(offsets[0]);
  object.profileJson = reader.readString(offsets[1]);
  object.updatedAt = reader.readDateTime(offsets[2]);
  object.version = reader.readLong(offsets[3]);
  return object;
}

P _ruleProfileCacheEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ruleProfileCacheEntityGetId(RuleProfileCacheEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ruleProfileCacheEntityGetLinks(
  RuleProfileCacheEntity object,
) {
  return [];
}

void _ruleProfileCacheEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  RuleProfileCacheEntity object,
) {
  object.id = id;
}

extension RuleProfileCacheEntityByIndex
    on IsarCollection<RuleProfileCacheEntity> {
  Future<RuleProfileCacheEntity?> getByProfileId(String profileId) {
    return getByIndex(r'profileId', [profileId]);
  }

  RuleProfileCacheEntity? getByProfileIdSync(String profileId) {
    return getByIndexSync(r'profileId', [profileId]);
  }

  Future<bool> deleteByProfileId(String profileId) {
    return deleteByIndex(r'profileId', [profileId]);
  }

  bool deleteByProfileIdSync(String profileId) {
    return deleteByIndexSync(r'profileId', [profileId]);
  }

  Future<List<RuleProfileCacheEntity?>> getAllByProfileId(
    List<String> profileIdValues,
  ) {
    final values = profileIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'profileId', values);
  }

  List<RuleProfileCacheEntity?> getAllByProfileIdSync(
    List<String> profileIdValues,
  ) {
    final values = profileIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'profileId', values);
  }

  Future<int> deleteAllByProfileId(List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'profileId', values);
  }

  int deleteAllByProfileIdSync(List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'profileId', values);
  }

  Future<Id> putByProfileId(RuleProfileCacheEntity object) {
    return putByIndex(r'profileId', object);
  }

  Id putByProfileIdSync(
    RuleProfileCacheEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'profileId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByProfileId(List<RuleProfileCacheEntity> objects) {
    return putAllByIndex(r'profileId', objects);
  }

  List<Id> putAllByProfileIdSync(
    List<RuleProfileCacheEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'profileId', objects, saveLinks: saveLinks);
  }
}

extension RuleProfileCacheEntityQueryWhereSort
    on QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QWhere> {
  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterWhere>
  anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension RuleProfileCacheEntityQueryWhere
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QWhereClause
        > {
  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
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

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  idBetween(
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

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  profileIdEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'profileId', value: [profileId]),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  profileIdNotEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [],
                upper: [profileId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [profileId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [profileId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [],
                upper: [profileId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'updatedAt', value: [updatedAt]),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  updatedAtGreaterThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [updatedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  updatedAtLessThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [],
          upper: [updatedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterWhereClause
  >
  updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [lowerUpdatedAt],
          includeLower: includeLower,
          upper: [upperUpdatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RuleProfileCacheEntityQueryFilter
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QFilterCondition
        > {
  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profileId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'profileId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profileId', value: ''),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'profileId', value: ''),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profileJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'profileJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'profileJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profileJson', value: ''),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  profileJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'profileJson', value: ''),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: value),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  versionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  versionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RuleProfileCacheEntity,
    RuleProfileCacheEntity,
    QAfterFilterCondition
  >
  versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RuleProfileCacheEntityQueryObject
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QFilterCondition
        > {}

extension RuleProfileCacheEntityQueryLinks
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QFilterCondition
        > {}

extension RuleProfileCacheEntityQuerySortBy
    on QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QSortBy> {
  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByProfileJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileJson', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByProfileJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileJson', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension RuleProfileCacheEntityQuerySortThenBy
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QSortThenBy
        > {
  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByProfileJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileJson', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByProfileJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileJson', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QAfterSortBy>
  thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension RuleProfileCacheEntityQueryWhereDistinct
    on QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QDistinct> {
  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QDistinct>
  distinctByProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QDistinct>
  distinctByProfileJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<RuleProfileCacheEntity, RuleProfileCacheEntity, QDistinct>
  distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension RuleProfileCacheEntityQueryProperty
    on
        QueryBuilder<
          RuleProfileCacheEntity,
          RuleProfileCacheEntity,
          QQueryProperty
        > {
  QueryBuilder<RuleProfileCacheEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RuleProfileCacheEntity, String, QQueryOperations>
  profileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileId');
    });
  }

  QueryBuilder<RuleProfileCacheEntity, String, QQueryOperations>
  profileJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileJson');
    });
  }

  QueryBuilder<RuleProfileCacheEntity, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<RuleProfileCacheEntity, int, QQueryOperations>
  versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
